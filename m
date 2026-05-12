Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5413EDE67;
	Tue, 12 May 2026 18:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609087; cv=none; b=SzkeKniYGLkyJWOMpJoICSfjDIv71XFmVAewgsCl6/EWWgd+2AYS5Y3mP8cBN16Lqp0xhqEBfmNeNu8cnJFlCsACxEP+F6jIf5I5kcB6Kk/Td1PosG/kLeaP85lr5OmmSjqUsbgGRE9YVOBlWc4l9YnSztJLgqhihtpYmEU1Tk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609087; c=relaxed/simple;
	bh=iQsZanq/1LpKSWsYB5uHWc6cnHNWQs3oN+RrdLLHSKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jztkR91OyxnUaJ+Zfn1X58KI3dOubEdBH0rWwQwKvWdMQztaH9ghQI8TIBOJsdEjR+llyOn8KsiWbvKGYPE/7VL6qrez0GBb0EH1rufpI47kNufFAZF/SPHnxXw9zrSIWqYdIVDxsVPd4FP6igEUcmGrNma/gjIiH6O2fh0jiTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyASBHoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyASBHoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBF1C2BCB0;
	Tue, 12 May 2026 18:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609087;
	bh=iQsZanq/1LpKSWsYB5uHWc6cnHNWQs3oN+RrdLLHSKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyASBHoZj3sCU51Gy7Xe1AeAYu7SVWkqfK+u144xNAQZrCIDep7OciqzR8YjlWPit
	 gBqsJm/KMbxyRQIzl4aTKltP4jdalwzaACBypQiK+AyLpQxj9uOzLDTfkERZlUgLpm
	 iGkxq+GIav1vFRgf9VPu7dpvXTizV86eGzdWEI/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongyao Chen <ZongYao.Chen@linux.alibaba.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 059/307] selinux: use sk blob accessor in socket permission helpers
Date: Tue, 12 May 2026 19:37:34 +0200
Message-ID: <20260512173941.368047076@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongyao Chen <ZongYao.Chen@linux.alibaba.com>

commit 032e70aff025d7c519af9ab791cd084380619263 upstream.

SELinux socket state lives in the composite LSM socket blob.

sock_has_perm() and nlmsg_sock_has_extended_perms() currently
dereference sk->sk_security directly, which assumes the SELinux socket
blob is at offset zero.

In stacked configurations that assumption does not hold. If another LSM
allocates socket blob storage before SELinux, these helpers may read the
wrong blob and feed invalid SID and class values into AVC checks.

Use selinux_sock() instead of accessing sk->sk_security directly.

Fixes: d1d991efaf34 ("selinux: Add netlink xperm support")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Zongyao Chen <ZongYao.Chen@linux.alibaba.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4914,7 +4914,7 @@ static bool sock_skip_has_perm(u32 sid)
 
 static int sock_has_perm(struct sock *sk, u32 perms)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = selinux_sock(sk);
 	struct common_audit_data ad;
 	struct lsm_network_audit net;
 
@@ -6221,7 +6221,7 @@ static unsigned int selinux_ip_postroute
 
 static int nlmsg_sock_has_extended_perms(struct sock *sk, u32 perms, u16 nlmsg_type)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = selinux_sock(sk);
 	struct common_audit_data ad;
 	u8 driver;
 	u8 xperm;


