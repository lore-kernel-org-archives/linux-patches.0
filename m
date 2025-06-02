Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446C2221FD2;
	Mon,  2 Jun 2025 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875655; cv=none; b=Rzq4x9SxqC3+MCSP9iJc8GIqiI6Uul+sECj8mO/nnlcF3RWijnL3IkmnBv79P680t2tKX4y3er87TxR+gWGBNRtlV/JyQa/UgPYxwPm4H4fmxa1IbszFI7lAqXi6MrWacxbJsHpKyQz5brszp/X6WFv1w57U7fxO+/iyT5BisqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875655; c=relaxed/simple;
	bh=SYXV8MW7MJ7tyTfzkyXfz/g1uSTSsHdAcbZcMTMlw3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5vYPGJ8aCHUHvmu3ykWHigWajydP/aNev7ZYYEDs6wGcs+BdBqcjDofQ0OSxJZA95e6uUSna35Xgv5ZAz9LHueMstZPUHyiDbIkmE/30Hlnm9TY2HLgZuOhFhygy7/oWUcB4jrp76f+kWVxTsIBP+PYLDPI26MdyfoKmgKiBH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqsMRBun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqsMRBun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55C7C4CEEB;
	Mon,  2 Jun 2025 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875655;
	bh=SYXV8MW7MJ7tyTfzkyXfz/g1uSTSsHdAcbZcMTMlw3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqsMRBunlMJq8GDd/uBdIkVzTy0nCXqkYN1C648diR/yF6aLoolMcPx4fTKVPLjnt
	 K6MButKZWRRqyc5t1x5xw9EMOlGhYJiudS48FGkVCGfgvdroCPk5ZPZ0ALtWLYtwog
	 I9/sZCXy2IaRuN//LJTG9dLCADEazcoFghwRnAJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/270] smack: recognize ipv4 CIPSO w/o categories
Date: Mon,  2 Jun 2025 15:48:08 +0200
Message-ID: <20250602134315.494648935@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 44f0b5148a5b9..6402626e47c69 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -921,6 +921,10 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
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



