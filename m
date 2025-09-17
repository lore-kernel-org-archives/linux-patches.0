Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1CD337EB9;
	Wed, 17 Sep 2025 12:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112993; cv=none; b=mDrp42bWCOLK9+SnnSZaQ7yO8sdxQm3sMkBTP/AAIb33KiRb9115tM4LBQajlCuh4fvDeUsTAXJQdyy3X/mHG/1SDa2IhfjyOks6DU/f8ExWq32v3BI9Lc/MxjgfwjqBZ0No0usNgEx2aIBn6ts7OYAfbkvYAs4BCiQnoOx4quU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112993; c=relaxed/simple;
	bh=bE1VpIfNqX5dUfIq+Na/njvP8jf2MK+o6LgMUF0Gxjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLqvPbuygXxz0z8vLR0eoEU1MeR8n0m/CKFRW5K+xOceFqEZiXTI0XPF65wsWPQg2V+mR4EpckOahc2l/uwhmFt8rCD8CpHmhckT9EWlW95RqS//UM5rbHK7XSQgT7mSraAxGNCOEhCKIWhKaN57auoR0Eq9ycxevwgjii46ol0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1dcSj29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1dcSj29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE1FC4CEF0;
	Wed, 17 Sep 2025 12:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112992;
	bh=bE1VpIfNqX5dUfIq+Na/njvP8jf2MK+o6LgMUF0Gxjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1dcSj29F4EeiMDx8MilkyergsKNdKW9BTW6YWZ9JYGEv0R8wRJB7Melsl5ThsO4j
	 jzHcDQQW52Od1McJSGZTtXihpmJNxlL+cXGDG/ipafXamF6nQVp2LpYNKUZCTGzyq3
	 Df++mX/TMGBoZ6Yxm9MfLa0F9kmlgeBopBIaiAiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 137/189] net: bridge: Bounce invalid boolopts
Date: Wed, 17 Sep 2025 14:34:07 +0200
Message-ID: <20250917123355.211234824@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 8625f5748fea960d2af4f3c3e9891ee8f6f80906 ]

The bridge driver currently tolerates options that it does not recognize.
Instead, it should bounce them.

Fixes: a428afe82f98 ("net: bridge: add support for user-controlled bool options")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/e6fdca3b5a8d54183fbda075daffef38bdd7ddce.1757070067.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 0adeafe11a365..ad2d8f59fc7bc 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -324,6 +324,13 @@ int br_boolopt_multi_toggle(struct net_bridge *br,
 	int err = 0;
 	int opt_id;
 
+	opt_id = find_next_bit(&bitmap, BITS_PER_LONG, BR_BOOLOPT_MAX);
+	if (opt_id != BITS_PER_LONG) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Unknown boolean option %d",
+				       opt_id);
+		return -EINVAL;
+	}
+
 	for_each_set_bit(opt_id, &bitmap, BR_BOOLOPT_MAX) {
 		bool on = !!(bm->optval & BIT(opt_id));
 
-- 
2.51.0



