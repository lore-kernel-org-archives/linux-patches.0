Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DC7306B21;
	Wed, 25 Feb 2026 06:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002769; cv=none; b=SinZh/Fpljer7sbeT3TRdq04ybNSlafxLKp6WiKYtcnnQ95JqHPrZlzAAeJKmcCO9rIftsg7y/kqONZpdlY/KLgbB3DugS5rYbxmdo6isKWixAl50xrFddOGutNO2psGnBKNZ17I4iXfjD0OpC+7aeSb3qz5LxA9XKJipfBsjv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002769; c=relaxed/simple;
	bh=740Z5+vSXC47+1/h4Anf/p1rQiSL/TV84E1cWtUw0WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ulk8L4UXEsowmMdrpuNQDbHCX0W1+DcYRb97vc/u7RFBX56tVI0rea/RCtDw7uOk8bD4RHoCQ7SWEfR+lWlooq7SzDgPpeMoSxsDBecAe/lGCMZ4TjUJnAQ5+1zWiJAPhdajxXoIbOgazJ4wkgpRLYnMK7C03YT57cBaDhiye2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPt8gRhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPt8gRhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D2EC116D0;
	Wed, 25 Feb 2026 06:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002769;
	bh=740Z5+vSXC47+1/h4Anf/p1rQiSL/TV84E1cWtUw0WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPt8gRhuZWJCyKZWjQ4x3BEic9b3fB5f04nP01Wcv5LiSL0Q6nea7l99ExWkRPKtV
	 DQnyL8jxpeeN5RHcrqtSLsC5PVaCPvfI0o1KbEvNpK9FdnvKpfiAQImzinejVruifx
	 a9DbjrpYmSOhgGrQ3mKdR76b+aNv86ApOLh8fa6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamin Mc <jaminmc@gmail.com>,
	=?UTF-8?q?Fabian=20Gr=C3=BCnbichler?= <f.gruenbichler@proxmox.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 563/641] apparmor: fix NULL pointer dereference in __unix_needs_revalidation
Date: Tue, 24 Feb 2026 17:24:49 -0800
Message-ID: <20260225012402.164160645@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: System Administrator <root@localhost>

[ Upstream commit e2938ad00b21340c0362562dfedd7cfec0554d67 ]

When receiving file descriptors via SCM_RIGHTS, both the socket pointer
and the socket's sk pointer can be NULL during socket setup or teardown,
causing NULL pointer dereferences in __unix_needs_revalidation().

This is a regression in AppArmor 5.0.0 (kernel 6.17+) where the new
__unix_needs_revalidation() function was added without proper NULL checks.

The crash manifests as:
  BUG: kernel NULL pointer dereference, address: 0x0000000000000018
  RIP: aa_file_perm+0xb7/0x3b0 (or +0xbe/0x3b0, +0xc0/0x3e0)
  Call Trace:
   apparmor_file_receive+0x42/0x80
   security_file_receive+0x2e/0x50
   receive_fd+0x1d/0xf0
   scm_detach_fds+0xad/0x1c0

The function dereferences sock->sk->sk_family without checking if either
sock or sock->sk is NULL first.

Add NULL checks for both sock and sock->sk before accessing sk_family.

Fixes: 88fec3526e841 ("apparmor: make sure unix socket labeling is correctly updated.")
Reported-by: Jamin Mc <jaminmc@gmail.com>
Closes: https://bugzilla.proxmox.com/show_bug.cgi?id=7083
Closes: https://gitlab.com/apparmor/apparmor/-/issues/568
Signed-off-by: Fabian Grünbichler <f.gruenbichler@proxmox.com>
Signed-off-by: System Administrator <root@localhost>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index c758204028780..919dbbbc87ab6 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -578,6 +578,9 @@ static bool __unix_needs_revalidation(struct file *file, struct aa_label *label,
 		return false;
 	if (request & NET_PEER_MASK)
 		return false;
+	/* sock and sock->sk can be NULL for sockets being set up or torn down */
+	if (!sock || !sock->sk)
+		return false;
 	if (sock->sk->sk_family == PF_UNIX) {
 		struct aa_sk_ctx *ctx = aa_sock(sock->sk);
 
-- 
2.51.0



