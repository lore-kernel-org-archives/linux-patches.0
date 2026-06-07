Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924054071DA;
	Sun,  7 Jun 2026 10:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827496; cv=none; b=GHQZiotr4pP8yRlNUgJK9gDa3+ohRHYu4y4K8IVpgN3opEyaaAgR/7P/tRn1Ne6JCL3+sDYAW7xl8wi5oKnZJvIIHV3llmTgug1qlQkFbSs7DOIbLJQ49rHYVljSUOWmPwzn0FfFqPydeyeE835/B446+2wQHIdiaVOkgGhDbbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827496; c=relaxed/simple;
	bh=3RFtf7UWcMQq00+F8fVyyf/xUhkJ49i5HQqrixFbNjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYvCxyAgTDSchvEXpGYjKuzn2IDX8vJG2041S/PRSqac0s4bBG63Qth2Zs9hfjHGFU9vZgb2tzt2yAXZCTcwwJ5230ejjtr8i4utTSt7GlpKlsSLHPGy1QUTE5nWa0pcxBvg00+4qKXiCVP4u83JD/Z3SWItgBBjsZrJ2+1rnhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ign+1JqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ign+1JqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A352D1F00893;
	Sun,  7 Jun 2026 10:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827495;
	bh=7521GtjayYAUv5tCugkzKFtLlSKGJH1wlbZOAxcOYho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ign+1JqHeIKyAgDrNmu9cbi8Wt6amLrHfPuOq9qXqLDrbThyA+zaGvqiBdeGc1iey
	 YcjHqqBycFx5k8I+ykyKH1nW46/N0QSTxZ59tQUlkhzeGAOIgoLbT5gxAOD/pe+C5M
	 aqtD30U10lDNQ1A0AEkGc28wFhslCqx05Y9RaZb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/307] net/smc: Do not re-initialize smc hashtables
Date: Sun,  7 Jun 2026 11:57:16 +0200
Message-ID: <20260607095729.129371020@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 9e4389b0038781f19f97895186ed941ff8ac1678 ]

INIT_HLIST_HEAD(&smc_v*_hashinfo.ht) are called after smc_nl_init(),
proto_register() and sock_register(). This can lead to smc_v*_hashinfo.ht
being reset even though hash entries already exist and are being used,
possibly resulting in a corrupted list.

Remove unnecessary and dangerous re-initialisation of smc_v*_hashinfo.ht in
smc_init(); it is implicitly initialised to zero anyhow. Add
HLIST_HEAD_INIT to the definitions for clarity.

Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
Suggested-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Link: https://patch.msgid.link/20260521145639.10317-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c96abb1386be4b..6f3469ad54a165 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -187,10 +187,12 @@ static bool smc_hs_congested(const struct sock *sk)
 
 struct smc_hashinfo smc_v4_hashinfo = {
 	.lock = __RW_LOCK_UNLOCKED(smc_v4_hashinfo.lock),
+	.ht = HLIST_HEAD_INIT,
 };
 
 struct smc_hashinfo smc_v6_hashinfo = {
 	.lock = __RW_LOCK_UNLOCKED(smc_v6_hashinfo.lock),
+	.ht = HLIST_HEAD_INIT,
 };
 
 int smc_hash_sk(struct sock *sk)
@@ -3594,8 +3596,6 @@ static int __init smc_init(void)
 		pr_err("%s: sock_register fails with %d\n", __func__, rc);
 		goto out_proto6;
 	}
-	INIT_HLIST_HEAD(&smc_v4_hashinfo.ht);
-	INIT_HLIST_HEAD(&smc_v6_hashinfo.ht);
 
 	rc = smc_ib_register_client();
 	if (rc) {
-- 
2.53.0



