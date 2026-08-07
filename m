Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27E431327A;
	Fri,  7 Aug 2026 15:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116700; cv=none; b=OgYnwEe+8N+PwdtvA/QvdDnTqY7CEFFzppryRURuput/RtkqYuET9F7+OzSEQ2NsG9m08GHFK0t6GwiYVW2mlQBSQFzhMHN4msfDb4pnedq44GGCvF4PRIcfXBFm11ti3vApB3RytOrbRnnJEJXFseY9ll9r0CMiEAwLwdvK9fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116700; c=relaxed/simple;
	bh=ZiJvSSKa270o+XqXdnn44boWbb6ps/QM4fPohaLgIDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJgMwHkz7TJuUjwq1EpuBDB+mhijZchhIzwaGbDPALOinJ7FGbQhpv3MfGpRTQ50e9JWzt3qSYRsvzj27/fA9hdX6yyueVBAJS/5UcxCa4IWVYKN9jlCYRylXHQEKi3KF6tgbpnjWIZhq3YPVAms1p/z+1B4YK/UZ9LZ9wPx4AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDOz3J/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDOz3J/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB291F000E9;
	Fri,  7 Aug 2026 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116699;
	bh=olZ1SCBvD9S09L+2x75rRCTNRk+96L9o3V+dp7Jo9ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDOz3J/8T8JKjhnj/EKugY0dx+Zag9u3f/caAGzDwaeywl08tFpN3sYCzoEWNYlnN
	 /aGsM2jek0U5h289lFhA2ygYd7Dz5G93HIyD3+lkLbkvIbNfYSfrW0Nd64D7o+2a5M
	 wC/YpsGAuTvs0HpLobBvloLtyoAvUpGFYkdGKxTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	Talha Berk Arslan <talha.anything.info@gmail.com>
Subject: [PATCH 7.1 058/438] netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH
Date: Fri,  7 Aug 2026 16:34:14 +0200
Message-ID: <20260807143429.225891168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 305b63e1402267459fdabb183af4527f6799eebf ]

The XT_HASHLIMIT_RATE_MATCH flag mode changes the semantics of the
dsthash_ent structure which represents an entry in the hashtable.  There
is a union area which uses a different layout to express the rate match
mode.

Update .checkentry path to validate the XT_HASHLIMIT_RATE_MATCH mode
flag is requested by two or more different rules that refer to the same
hashtable. Otherwise, uninitialized access to the burst field in the
union is possible.

Reject the use of the XT_HASHLIMIT_RATE_MATCH mode flag if set on by
revision less than 3 too.

Fixes: bea74641e378 ("netfilter: xt_hashlimit: add rate match mode")
Reported-and-tested-by: Talha Berk Arslan <talha.anything.info@gmail.com>
Link: https://patch.msgid.link/20260721074629.668-1-talha.anything.info@gmail.com/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_hashlimit.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 2704b4b60d1e0..9af0fa895f730 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -117,6 +117,7 @@ struct xt_hashlimit_htable {
 	refcount_t use;
 	u_int8_t family;
 	bool rnd_initialized;
+	bool ratematch;
 
 	struct hashlimit_cfg3 cfg;	/* config */
 
@@ -323,6 +324,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		kvfree(hinfo);
 		return -ENOMEM;
 	}
+	hinfo->ratematch = !!(cfg->mode & XT_HASHLIMIT_RATE_MATCH);
 	spin_lock_init(&hinfo->lock);
 
 	switch (revision) {
@@ -872,7 +874,10 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 	}
 
 	/* Check for overflow. */
-	if (revision >= 3 && cfg->mode & XT_HASHLIMIT_RATE_MATCH) {
+	if (cfg->mode & XT_HASHLIMIT_RATE_MATCH) {
+		if (revision < 3)
+			return -EINVAL;
+
 		if (cfg->avg == 0 || cfg->avg > U32_MAX) {
 			pr_info_ratelimited("invalid rate\n");
 			return -ERANGE;
@@ -905,6 +910,15 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 			mutex_unlock(&hashlimit_mutex);
 			return ret;
 		}
+	} else {
+		if ((cfg->mode & XT_HASHLIMIT_RATE_MATCH &&
+		     !(*hinfo)->ratematch) ||
+		    (!(cfg->mode & XT_HASHLIMIT_RATE_MATCH) &&
+		      (*hinfo)->ratematch)) {
+			mutex_unlock(&hashlimit_mutex);
+			htable_put(*hinfo);
+			return -EINVAL;
+		}
 	}
 	mutex_unlock(&hashlimit_mutex);
 
-- 
2.53.0



