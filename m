Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510A033689F;
	Thu,  2 Jul 2026 16:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010877; cv=none; b=vDhYELe56SgLffcuiVuUfSKvrbRe+eT36aAe01Hk1Uh9/3W/78kjHYNVDfoA62lXmHcJwzWMmdkOvgT1TNaFJZw3LxG0DmsRn+JB7dMZITN0lWlfI66rekh3+Eim2//I0+F0iFW17d+ENmF5oMD37+VhdVBC2+flxpNYtfwuv5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010877; c=relaxed/simple;
	bh=nzHFW808mKiYCHhhUCoh3jdm0Xr8uA3plSIxGTnjVIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ti6LoUPsWolHRt8w8Vi2d0sJCogWVSlamaKK1QLsZMUpz4oJLYwdsO9HDoQniV11b90/+Cn3zOSwWg6EK81dKZG1DXsinxfd8AtLYtmHMSOocYOtCUV3keha1CbjV+4Cb/hvPAE6na1aY/6dv/+yu6lkWSXZ+DU4ezTx14eF1Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D77xOyc2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D77xOyc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D111F000E9;
	Thu,  2 Jul 2026 16:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010876;
	bh=kyaDQGsLVqREU2ThKA6vJIqswe+aWnjCPBkLdvM3DB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D77xOyc2Ovvrytlm4TD/d2OppAX5Cwzsk2pTEObl8+QrAF7JZ+uVRl0d7ato13uFT
	 5fBoGtOK6pDC9GldlXCtx+C/TQgc/V0MhFV4dWFKHKWTkG9BCFAvt9c/ny/7Vn4kL3
	 e37evLWjIdna8IPRzJpJBliX4GzOYGBZRtV0WFFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.6 071/175] vc_screen: fix null-ptr-deref in vcs_notifier() during concurrent vcs_write
Date: Thu,  2 Jul 2026 18:19:32 +0200
Message-ID: <20260702155117.288498724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Yi Yang <yiyang13@huawei.com>

commit a287620312dc6dcb9a093417a0e589bf30fcf38a upstream.

A KASAN null-ptr-deref was observed in vcs_notifier():

BUG: KASAN: null-ptr-deref in vcs_notifier+0x98/0x130
Read of size 2 at addr qmp_cmd_name: qmp_capabilities, arguments: {}

The issue is a race condition in vcs_write(). When the console_lock is
temporarily dropped (to copy data from userspace), the vc_data pointer
obtained from vcs_vc() may become stale. After re-acquiring the lock,
vcs_vc() is called again to re-validate the pointer. If the vc has been
deallocated in the meantime, vcs_vc() returns NULL, and the while loop
breaks (with written > 0). However, after the loop, vcs_scr_updated(vc)
is still called with the now-NULL vc pointer, leading to a null pointer
dereference in the notifier chain (vcs_notifier dereferences param->vc).

Fix this by adding a NULL check for vc before calling vcs_scr_updated().

Fixes: 8fb9ea65c9d1 ("vc_screen: reload load of struct vc_data pointer in vcs_write() to avoid UAF")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260604060734.2914976-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vc_screen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -699,7 +699,7 @@ vcs_write(struct file *file, const char
 	}
 	*ppos += written;
 	ret = written;
-	if (written)
+	if (written && vc)
 		vcs_scr_updated(vc);
 
 unlock_out:


