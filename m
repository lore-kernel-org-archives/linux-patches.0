Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA1344682B;
	Thu, 30 Jul 2026 16:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427838; cv=none; b=iQf0fIO2t5HVdPW0Pi3eHX5Qq/oZuOga34jEWmginliWSC4eYYwv2QHRlvQrfAIVfOSrCj+udyCbdfSBmP6kB/21cwtk2EQuGkz95clHTB6eOTlIJQPD5zyiw7s1GnkRGgyM7zgHgfwLZmoT5T5aeyjU37qjg+KHI26kFXAjO0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427838; c=relaxed/simple;
	bh=Nylbp4cQ+82eut9gXe8i0Upi1nUhwmDt9JlSN/mR6iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cblTETnSwiDT6rwFk8WjQSz7gkwPuFhe4kmnCd/D2VnkreZROtyBanIvh9I6sRprCxn42NvU5LNVkkBOZwooORs6ClK47VqOVMiX1Lft70fcIkAIPaefBv64geQyM4MFCSPoqXy67WKaJDgGn6Gb5DNJoK9Pa3T9XPM9/vXM11I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoTRM0Jm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoTRM0Jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08E51F000E9;
	Thu, 30 Jul 2026 16:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427837;
	bh=D6NzzKhr9VzuD2SYnPhuZSG8F3Qubei/Nc6yszLT42c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SoTRM0Jm0QeGVckvJA6D11vDwbkxWU8Q8uzzxTanQN9batqyJ1bvVQKGij3hi2H4m
	 EzZ6CHzgQm0VRjpidUTVfV38+CkADPaU5rZc63QXaSjC1f8qR4SlVUfos1LX8vjhSv
	 TUmYoMohsEFoMjwX0/6Im9SI3h80o+8JQGHS4ZXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Douya Le <ldy3087146292@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 310/484] libceph: remove debugfs files before client teardown
Date: Thu, 30 Jul 2026 16:13:27 +0200
Message-ID: <20260730141430.223016132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douya Le <ldy3087146292@gmail.com>

commit e4c804726c4afce3ba648b982d564f6af2cfa328 upstream.

ceph_destroy_client() tears down the monitor client before removing
the per-client debugfs files. A concurrent read of the monmap debugfs
file can enter monmap_show() after ceph_monc_stop() has freed
monc->monmap, triggering a use-after-free.

Remove the debugfs files before stopping the OSD and monitor clients.
debugfs_remove() drains active handlers and prevents new accesses, so
the debugfs callbacks can no longer race the rest of client teardown.

Cc: stable@vger.kernel.org
Fixes: 76aa844d5b2f ("ceph: debugfs")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/ceph_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -763,13 +763,13 @@ void ceph_destroy_client(struct ceph_cli
 
 	atomic_set(&client->msgr.stopping, 1);
 
+	ceph_debugfs_client_cleanup(client);
+
 	/* unmount */
 	ceph_osdc_stop(&client->osdc);
 	ceph_monc_stop(&client->monc);
 	ceph_messenger_fini(&client->msgr);
 
-	ceph_debugfs_client_cleanup(client);
-
 	ceph_destroy_options(client->options);
 
 	kfree(client);


