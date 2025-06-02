Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDB8226188;
	Mon,  2 Jun 2025 14:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873725; cv=none; b=idyJtHAyycJloUzLOhrmFVzHFFcpteTU2cHR4Uc4U8IvLQD3A2R13PxZ9f1Pvv6rxjSE6SBrz1gY1jdTRMt1q8FezIVPuejb3f6/9eV6gL4ISkQKP1OzJQJO6lQiTcNCm8mtjTT6DpM6KIikP9rMSa8r7C55aQlVP9m/p5LjcqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873725; c=relaxed/simple;
	bh=L6I9z2DIA+rRX6XdgslZTPzz64pvk3C0DWDJJFYOu48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXNdh4BvoXigUNp1cnqehxRBmc4esUJN0/9GIQcyb4NyzQsf0tAmGrF5WVk4oXglCLjGB2ddmE1qW0f1f/KuYOOukxG6OrlcUUOc+GVRAeg9oQpJNJe/zMnn1hLOB/67ztyIHYc8JfP5LUS8UinjOIzm4AGkJGu4xQUoYKAOooc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gwnq66vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gwnq66vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41C1C4CEEB;
	Mon,  2 Jun 2025 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873724;
	bh=L6I9z2DIA+rRX6XdgslZTPzz64pvk3C0DWDJJFYOu48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gwnq66vxxwDRaQ0qn1S6h0FUZYri0BuD10pen/Z+5HXlYQLGtvkGzBVcvFMt9ldjq
	 sNvSCBv5IBnKZ5xQiV6KFM7VW5VXDNr1cGoIKHbpYZ8tPcq/iTFMfLwNCzNa9I6dCj
	 uy2vVnJQKvZwteNLAJJ217/IJiMrWETXhTM0crc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/444] smack: recognize ipv4 CIPSO w/o categories
Date: Mon,  2 Jun 2025 15:44:54 +0200
Message-ID: <20250602134350.248785388@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5dd1e164f9b13..d27e8b916bfb9 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -933,6 +933,10 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
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



