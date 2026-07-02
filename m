Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4758834167B;
	Thu,  2 Jul 2026 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009325; cv=none; b=eIaExZcifKl7YfQVKlqj+cUpq25s2DpfWBWrmZEUzAfaMHDfGjT4/LfCxllIloIp60fQG9nwsqa/BokAIUR9EaoMs2YGdZSRmVCdZ966SFQwRrGy5zg+ZRyrJ7qviO5y7VVZrI2CYoAHlYf4j+lHLKii3tEo73lIeXwTvDyMTCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009325; c=relaxed/simple;
	bh=2OlMMKbvJIC02Q2iqgyGglRo5WExhSdBMz43cb01gEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsWwvwvZKnfOUw/x7vHUbrwwMT23IimqYtE3Rx0vGpcaVNsCJRvGIqgrUcPB1zkYPfERtdqaZCM2pnDbguK6OzhPjKLslqwwNCvV2KAyWV5i4dfoydif5uFgfcf29RR2sprB/xIzgxDO43oALIqtI1MUpGjbdQMHXei7kpY2Tcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgfNkz/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgfNkz/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924081F000E9;
	Thu,  2 Jul 2026 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009324;
	bh=C9E52hM8Gg9hyowPFD4qmWPafTjdgokBLdvc1ln7vEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgfNkz/nFBYyEym0g+HoJvr6H8H7qukhcKeSb7GQGMxo463lH4XcAJOfRLgEHVDfG
	 jWdZWi1thuXM1IhKRbPKwUfhvVdgbGXnEqUeMAzVzEahuqETLEgC4LwAqQzWINU4XE
	 8h3x+GqKO8QAyqcLGXCmfamrjqsSlWCs4QFXjRmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/96] net/sched: act_pedit: use NLA_POLICY for parsing ex keys
Date: Thu,  2 Jul 2026 18:18:53 +0200
Message-ID: <20260702155108.985307603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 5036034572b79daa6d6600338e8e8229e2a44b09 ]

Transform two checks in the 'ex' key parsing into netlink policies
removing extra if checks.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_pedit.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index a44101b2f44191..510a3b5b8c0c1d 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -31,8 +31,9 @@ static const struct nla_policy pedit_policy[TCA_PEDIT_MAX + 1] = {
 };
 
 static const struct nla_policy pedit_key_ex_policy[TCA_PEDIT_KEY_EX_MAX + 1] = {
-	[TCA_PEDIT_KEY_EX_HTYPE]  = { .type = NLA_U16 },
-	[TCA_PEDIT_KEY_EX_CMD]	  = { .type = NLA_U16 },
+	[TCA_PEDIT_KEY_EX_HTYPE] =
+		NLA_POLICY_MAX(NLA_U16, TCA_PEDIT_HDR_TYPE_MAX),
+	[TCA_PEDIT_KEY_EX_CMD] = NLA_POLICY_MAX(NLA_U16, TCA_PEDIT_CMD_MAX),
 };
 
 static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
@@ -82,12 +83,6 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 		k->htype = nla_get_u16(tb[TCA_PEDIT_KEY_EX_HTYPE]);
 		k->cmd = nla_get_u16(tb[TCA_PEDIT_KEY_EX_CMD]);
 
-		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
-		    k->cmd > TCA_PEDIT_CMD_MAX) {
-			err = -EINVAL;
-			goto err_out;
-		}
-
 		k++;
 	}
 
-- 
2.53.0



