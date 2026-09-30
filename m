Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB635221C6;
	Wed, 30 Sep 2026 17:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790597; cv=none; b=dt9y+LmwAno7cUgugQvHid+DrkKOFgx+KqrGccWCL1sZWyUuXj/vd8cqzqBFontk2iI1t9LHb12Ran5cFFITiM2yx1p1JgPhWNP55hfG/p0HykD1XahrlmjSGSoFHEXE2Fz/u1vmgFBlYcAciRD+YQD2tvKmagDkObuejPBTLy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790597; c=relaxed/simple;
	bh=S5yZ1ErWAVpvB345Aig1EgeVCTuocCREm3Yu3xc5sMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYWEQBA3JA6ce0LQudjVKj535U9rwQ2cLBA3T6R7KBy4Rlso+jzcq5f1XjOZxP3qfPtH7+wjFSnqlZAPovWrwBl5nKbH6QiJZzd5a6pRhsk41CriOSgYRKhpDPKopMoNzPhhJIdLfW1xWW/NYBYdj++wiVQUDod+LZ68tQJx7fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUvCYEds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUvCYEds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F6E1F000FF;
	Wed, 30 Sep 2026 17:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790596;
	bh=kN7UJNg9J62WsQutRHMI3CXR5h0q+MhzjCbiAnga6Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUvCYEdsZRUPT2gwCuap2jar4PeYX37UXy7516Ys8UCIBCK53OZ90fq+M8PQ7IiSO
	 6+wSmltLZxi9h9Yj9CCadsDv6wXYLSYCdIWh6vzYh7dvj4dupN1xqn6Sn1d7o6ImBD
	 Dn0Q+ATzM84Px6BJ4Jk0EvFbNvuNxUvYgHTbWt4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 6.12 875/877] usb: dwc3: gadget: Fix use-after-free in dwc3_gadget_free_endpoints due to race condition
Date: Wed, 30 Sep 2026 17:29:46 +0200
Message-ID: <20260930152433.615214020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3450,6 +3450,7 @@ static void dwc3_gadget_free_endpoints(s
 		}
 
 		dwc3_debugfs_remove_endpoint_dir(dep);
+		cancel_delayed_work_sync(&dep->nostream_work);
 		kfree(dep);
 	}
 }


