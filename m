Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4AA44AB62;
	Tue, 21 Jul 2026 21:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670872; cv=none; b=IAwcIA9HBt4eG4L+nvX10D2Q3O2dQ7PJcUCOTSqd4oQiYbMxAzusiF1WWXaRnkmrU1P8yV0tneeWwKRSaK7sG6yyLym0/+vW99fLNXjvNSMfcDTGzU9yritDEjCIQVsyt7CQdIetYDxLzFwkBFAKM4ngv0vjM9NTe8zU0U9/+3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670872; c=relaxed/simple;
	bh=q4JNjy7Lu1/NG+fsRpPEe40I+EqdAuAV+yllek1dB3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgSgr6JWMSBwqM6zJ8b4RKn8aAkUc0+0jBACURozx3Vxep3IVl6qPIOWtN6Xzt+6LzIz6toofTCUsR640IHBilpUM1rE4HgY5LZ8zTWUXRdZ8DmuYewxq+297JkqEyrUwHiqPgnOWwKk0VKZwUiKiGjKMJdgelSCsb0GFrGOYgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXhW45OT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXhW45OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747B81F000E9;
	Tue, 21 Jul 2026 21:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670871;
	bh=vZaTxxZ+2VViJRzPihH4fFOhxJXEx+jvMQ0oRZxs//U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXhW45OTJVpIaOLzwEfA2yWtWoBu6OHdTDy+ojnkAGOYMF/AY9wTU8hwGVREzETkU
	 f3ppXA6cvJtlmXKzgZF+s46BWYc5lRUrSKSJZFpKNoQLXe1NC1/0cDlBah4RcdZYAW
	 CDY6QKWoEY08JIbhOiCJd6vr6SC8cQPHwnHDnvCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/843] net/sched: act_pedit: use NLA_POLICY for parsing ex keys
Date: Tue, 21 Jul 2026 17:14:02 +0200
Message-ID: <20260721152406.119982809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 5036034572b79daa6d6600338e8e8229e2a44b09 ]

Transform two checks in the 'ex' key parsing into netlink policies
removing extra if checks.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_pedit.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index efcbca97bf2eda..a987f60d202826 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -35,8 +35,9 @@ static const struct nla_policy pedit_policy[TCA_PEDIT_MAX + 1] = {
 };
 
 static const struct nla_policy pedit_key_ex_policy[TCA_PEDIT_KEY_EX_MAX + 1] = {
-	[TCA_PEDIT_KEY_EX_HTYPE]  = { .type = NLA_U16 },
-	[TCA_PEDIT_KEY_EX_CMD]	  = { .type = NLA_U16 },
+	[TCA_PEDIT_KEY_EX_HTYPE] =
+		NLA_POLICY_MAX(NLA_U16, TCA_PEDIT_HDR_TYPE_MAX),
+	[TCA_PEDIT_KEY_EX_CMD] = NLA_POLICY_MAX(NLA_U16, TCA_PEDIT_CMD_MAX),
 };
 
 static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
@@ -86,12 +87,6 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
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



