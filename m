Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAD33AFB1C;
	Fri,  4 Sep 2026 05:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500531; cv=none; b=PnY6Uco8aE0bxVIYRdNd2qwwkRDergQZKZxHdT4E4pKAm4rQdbhYXZB8I4hw+vbL9pSchvyuC49BKd0XmEeCBBhxx2hct+/u2xPfJ2bFJ66+IpOb/47fFSSdloXZV8mD3n2EZckbpKbljNRTD72Isytf7SAwL3erdNvPjVLBjwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500531; c=relaxed/simple;
	bh=tR6CFgUpzdVK+9LnYFoGiUFzdd3pD73XLORgbsgcTUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Frwk6CdbNH2nO9BarKV6/rj7u6N7y2H8YSWy3Kf63e3awQwn4d2YveSRPpy1Y9MQpJaIk/bQ0d6W70Enae/GlUez5N2B0h99Y297h9+L5NyqvuEv74Tg+KUxyb/UnNNQiu65kZqpk+g4/waR3bstI/7lLenJ832toavJadSyAkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmFXqBtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmFXqBtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFA21F00A3D;
	Fri,  4 Sep 2026 05:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500529;
	bh=KWkhrC4p1jHOm/RyxoFz2qV9vhV7HufYRaZUql9XcpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NmFXqBttHH3Uq+DaCJnFz2PSlCizTI1g+4YisNbOKLtj/SrczlMG8ON/l0NsEKj65
	 QO/PUEyyRBaVAvIkp9rErHbyUXv+GzrpNL0BMKEpAUuE0aim/yWUpYhJoX29HJDaSq
	 0omhy6J2CpU+bHD88WT+GMrA5b86w+sldpTm00VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 6.18 072/552] usb: dwc3: gadget: Fix use-after-free in dwc3_gadget_free_endpoints due to race condition
Date: Fri,  4 Sep 2026 06:53:49 +0200
Message-ID: <20260904045749.480490945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

commit 9c855832790cd488d87de1885974f4c37cfe7358 upstream.

In dwc3_gadget_init_endpoint, &dep->nostream_work is bound with
dwc3_nostream_work, and dwc3_gadget_endpoint_stream_event can queue
this delayed work on system_percpu_wq when a DEPEVT_STREAM_NOSTREAM
event is received.

If we remove the gadget, dwc3_gadget_free_endpoints makes cleanup and
the memory allocated for dep with kzalloc() is released by kfree(dep),
while the delayed work mentioned above may still be pending or
running. The sequence of operations that may lead to a UAF bug is as
follows:

CPU0                                      CPU1

                                          | dwc3_thread_interrupt
                                          | dwc3_endpoint_interrupt
                                          | dwc3_gadget_endpoint_stream_event
                                          | queue_delayed_work(system_percpu_wq,
                                          |                    &dep->nostream_work)
dwc3_gadget_free_endpoints                |
dwc3_free_trb_pool(dep)                   |
list_del(&dep->endpoint.ep_list)          |
dwc3_debugfs_remove_endpoint_dir(dep)     |
kfree(dep)                                |
// dep is freed                           |
                                          | dwc3_nostream_work
                                          | // use dep (use-after-free)

Fix it by canceling the delayed work before kfree(dep) in
dwc3_gadget_free_endpoints.

Fixes: dcfe437492e2 ("usb: dwc3: gadget: Reinitiate stream for all host NoStream behavior")
Assisted-by: Codex:deepseek-v4-flash
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: stable@vger.kernel.org
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/331d1d5133496d2b4184e05f8848adb06930a138.1785893865.git.xiaopei01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3497,6 +3497,7 @@ static void dwc3_gadget_free_endpoints(s
 		}
 
 		dwc3_debugfs_remove_endpoint_dir(dep);
+		cancel_delayed_work_sync(&dep->nostream_work);
 		kfree(dep);
 	}
 }


