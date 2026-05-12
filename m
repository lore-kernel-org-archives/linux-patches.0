Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBCD3955D7;
	Tue, 12 May 2026 17:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608394; cv=none; b=BpGTb+0oH+lQ0GnW1Tisyhh/NPel11sKpHGxfOHSk5WcDuSz3dTmSwERFp4eoE1DkiNeSyBQYwv0j8FKNtEzhlURkp/tOkzBg6TeWATikRd30K4cTjNiqs7y3mrQNqpJRP+lx4cpt6zRnAFRWIuRR5+kyO4tWJmx7lddtueC1MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608394; c=relaxed/simple;
	bh=T3V6DAFXQR3+N7AX7ZsIaAQfJeSf2VBHj1XY08pO1lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYjR0vUm5j/Ly4nbSANRITTwGpWtgF5mWbZQdMv9ch8tkMUplAI3o+weGNqbGGQkbJvUvZoRDmgXj97JZ4rvuDOwVS7OT+p8UUfhqMmD1oBplhFCWkp9YSd2EyiWgl9uE76jQvGEWyhzjdDW9yf1g+Isi+ZHXGxNw+ufaqSV5Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCKY/PRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCKY/PRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66E2C2BCB0;
	Tue, 12 May 2026 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608394;
	bh=T3V6DAFXQR3+N7AX7ZsIaAQfJeSf2VBHj1XY08pO1lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCKY/PRCAy6wLTkbHJhFcwLraRTSbVEIdNmlw1fiHDwCmlO+3229t7RiSz/YhvYuL
	 hg//XBwVhWdW3veuHiIGkMBDDcL/fMA68UpC7ZpYO/KPBcLjf1D6g9+Ms4bT7oFFrw
	 J+y467WnMahDbOVfgEKYZ3uurluHTTC7UkCzCcXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongyao Chen <ZongYao.Chen@linux.alibaba.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 061/270] selinux: use sk blob accessor in socket permission helpers
Date: Tue, 12 May 2026 19:37:42 +0200
Message-ID: <20260512173939.736407534@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -4780,7 +4780,7 @@ static bool sock_skip_has_perm(u32 sid)
 
 static int sock_has_perm(struct sock *sk, u32 perms)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = selinux_sock(sk);
 	struct common_audit_data ad;
 	struct lsm_network_audit net;
 
@@ -6087,7 +6087,7 @@ static unsigned int selinux_ip_postroute
 
 static int nlmsg_sock_has_extended_perms(struct sock *sk, u32 perms, u16 nlmsg_type)
 {
-	struct sk_security_struct *sksec = sk->sk_security;
+	struct sk_security_struct *sksec = selinux_sock(sk);
 	struct common_audit_data ad;
 	u8 driver;
 	u8 xperm;


