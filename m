Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9853D75AD;
	Mon, 17 Aug 2026 14:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977235; cv=none; b=ugI/7faGgbiQ44bkBzCRy21zkNxwbBWxsY0gIT9lgQdGK3sTT/9GTYZ28jdRRQ9PLOM96Q56LkVqp+8jcCSFGT4rJ6+9LmcC7BfNubUlGnQSi6dpeloooeY/P8Dt1ZapnWERJF1kFcSkD662KIPvsNrGxdNsBQ55OZhHxbC17Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977235; c=relaxed/simple;
	bh=V46szd1ba9VdFMD/yRCsGuHLZsfOZwrtQfWvE8JupPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7/FG7MGD5PA7oLu1DswPJUEi3Gg5VZYoarqPZtTUSYFmFJnaYMSn3Q79K1T2IS9QOLCmwKtv4lj33m+fAVGl7OswZg6/M4g72R4qltLjpt9Dnt/Uc38llhj7viMU1h10Ppb4T2gnScDIkMfcZ2OORbkMEZQ9cwOieTshf9VtNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLeBtHN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLeBtHN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017FA1F000E9;
	Mon, 17 Aug 2026 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977234;
	bh=Q34L2MXdaxdj4+QQ70W9LZd70CnYUPZkf/6NznORn3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KLeBtHN9JabGLHUqBkGQMQ8/3+lJYE8n3djiBNdnzrEQJiZHHb5yzQSWPPq1cX7dW
	 L0JD0PdCR1YSsCFjvtvcHRPmAulBF1hhCuynuP30ELTT/HqfRdWGSKyphgjlarwnJR
	 /LNppVMjc1HeyX/4YBxBVPcvivqJ4aWTPCd95y5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	Talha Berk Arslan <talha.anything.info@gmail.com>
Subject: [PATCH 5.15 258/456] netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH
Date: Mon, 17 Aug 2026 15:30:48 +0200
Message-ID: <20260817132550.125343205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 9c5cfd74a0ee4..26918fa575afe 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -118,6 +118,7 @@ struct xt_hashlimit_htable {
 	refcount_t use;
 	u_int8_t family;
 	bool rnd_initialized;
+	bool ratematch;
 
 	struct hashlimit_cfg3 cfg;	/* config */
 
@@ -325,6 +326,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		vfree(hinfo);
 		return -ENOMEM;
 	}
+	hinfo->ratematch = !!(cfg->mode & XT_HASHLIMIT_RATE_MATCH);
 	spin_lock_init(&hinfo->lock);
 
 	switch (revision) {
@@ -868,7 +870,10 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
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
@@ -901,6 +906,15 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
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



