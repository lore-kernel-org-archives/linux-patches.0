Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6942253F2;
	Mon,  2 Jun 2025 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877159; cv=none; b=ocsfyIZuWs4IUqU572f8Vl72jJGKxOU+HZjvvZhU1x1UECwUhlXdiqC+iAExu2lDrgbej5TpM4WICFanTTLjox3Q2bVtZrzUPvt2bVslUijkXJi6/qiM012xNNMQ97AXdZT9YUm2b3fKwNSFJFtxytYqR8SMZUzI1ILFpoLIAjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877159; c=relaxed/simple;
	bh=1CVYTQ/KAxjP7arXTbFQKsk/ux3QkN8E23c08REt/Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahpq3MSO2quYrqt/yuIpvUJPU4MhXnwCsx6NrzGJGjTrFUnJVRqGP+7JGS73dFFKDy6rBNmvRu1Hksbm/DLFUoLyTIFgqWdcXohrpGKGwdDIL5cuPbPoDgQd+O8ohY/ES5ZHD83DP09dGGbKZ8t0RdAL8hJhK+jiWPM+0thnrPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvuFpQgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvuFpQgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FE1C4CEEB;
	Mon,  2 Jun 2025 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877159;
	bh=1CVYTQ/KAxjP7arXTbFQKsk/ux3QkN8E23c08REt/Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvuFpQgMzzVuY1nIFzGpEM8FdYON6XqioM9M0bl+apPBfJAgAPSlADfrIv788Wwfd
	 T+fF4Rg/CdmmFwY2inls74CloHECP6HNgW2V+7Yh92o1OY6z57RbnVGq8aI0yP5lf0
	 xEkSfX60euwgkngLwK8jdhXprltrsWwPaLVeweP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/325] smack: recognize ipv4 CIPSO w/o categories
Date: Mon,  2 Jun 2025 15:47:29 +0200
Message-ID: <20250602134326.851030859@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit a158a937d864d0034fea14913c1f09c6d5f574b8 ]

If SMACK label has CIPSO representation w/o categories, e.g.:

| # cat /smack/cipso2
| foo  10
| @ 250/2
| ...

then SMACK does not recognize such CIPSO in input ipv4 packets
and substitues '*' label instead. Audit records may look like

| lsm=SMACK fn=smack_socket_sock_rcv_skb action=denied
|   subject="*" object="_" requested=w pid=0 comm="swapper/1" ...

This happens in two steps:

1) security/smack/smackfs.c`smk_set_cipso
   does not clear NETLBL_SECATTR_MLS_CAT
   from (struct smack_known *)skp->smk_netlabel.flags
   on assigning CIPSO w/o categories:

| rcu_assign_pointer(skp->smk_netlabel.attr.mls.cat, ncats.attr.mls.cat);
| skp->smk_netlabel.attr.mls.lvl = ncats.attr.mls.lvl;

2) security/smack/smack_lsm.c`smack_from_secattr
   can not match skp->smk_netlabel with input packet's
   struct netlbl_lsm_secattr *sap
   because sap->flags have not NETLBL_SECATTR_MLS_CAT (what is correct)
   but skp->smk_netlabel.flags have (what is incorrect):

| if ((sap->flags & NETLBL_SECATTR_MLS_CAT) == 0) {
| 	if ((skp->smk_netlabel.flags &
| 		 NETLBL_SECATTR_MLS_CAT) == 0)
| 		found = 1;
| 	break;
| }

This commit sets/clears NETLBL_SECATTR_MLS_CAT in
skp->smk_netlabel.flags according to the presense of CIPSO categories.
The update of smk_netlabel is not atomic, so input packets processing
still may be incorrect during short time while update proceeds.

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index d955f3dcb3a5e..9dca3672d82b4 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -922,6 +922,10 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	if (rc >= 0) {
 		old_cat = skp->smk_netlabel.attr.mls.cat;
 		rcu_assign_pointer(skp->smk_netlabel.attr.mls.cat, ncats.attr.mls.cat);
+		if (ncats.attr.mls.cat)
+			skp->smk_netlabel.flags |= NETLBL_SECATTR_MLS_CAT;
+		else
+			skp->smk_netlabel.flags &= ~(u32)NETLBL_SECATTR_MLS_CAT;
 		skp->smk_netlabel.attr.mls.lvl = ncats.attr.mls.lvl;
 		synchronize_rcu();
 		netlbl_catmap_free(old_cat);
-- 
2.39.5



