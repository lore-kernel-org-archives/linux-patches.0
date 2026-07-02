Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8334C3A6EEE;
	Thu,  2 Jul 2026 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009616; cv=none; b=EEqIxElrQZb0wdM8rutBDV0Wswc6uqSrzUIW6vlpxtMupIVNA/eHbpzji2Pb6Mkv4wLdd2ocyD3/gSzz6uDoWxQOGj9HV2xxyldcU0fYjZrBxwZCMvgQmwcjHj4aNbJnueY8ja8k/6xAu7fBTtq+sXxdDt+vte7wjpmgbyggkOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009616; c=relaxed/simple;
	bh=fwBzhagYMv/sZI/q8KC/BLDnxtjCgixAs2cTwW8UhMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRJuoCM/XTYI0F+jw0nnW88VpEWV45uHostQyinuL9KfV4Ff6ckTN/PpBatzHdYKSw2Xo7D/a2yfjp/TrxbWuKkLTgqmJq/tWxe76qeCc7Wfmtc2kDXMgVGVPq0at7ASp42tloeopzOTLfT1TkIKajJNcK+vqwvcPwmUNpDAha4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2XU3TPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2XU3TPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE311F00A3A;
	Thu,  2 Jul 2026 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009612;
	bh=TKfI6Jz/cCTuLuPxVkMlzUgpLgkpgy6xby1fNH1zVmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2XU3TPrasNY89Ydsa3sf8FFpr2R328tHgERnn0al9TDHI80q9aMXd4280YxAKZ+M
	 knrRcEolzQtgDFvTR1RY+HU+ea/EUi1GoTIs82u+nDZ9DxCMCKG8OmPobj9+wZoPGr
	 dGJn8/U1iy+4BwEZRwv3Ri/sn1J23NrF/Cv+aWJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.15 21/95] vc_screen: fix null-ptr-deref in vcs_notifier() during concurrent vcs_write
Date: Thu,  2 Jul 2026 18:19:24 +0200
Message-ID: <20260702155109.654650021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


