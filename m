Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537BA14B083;
	Tue, 23 Apr 2024 21:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908785; cv=none; b=SMRFsK6B1FG1t4BRCoNznfDKO763SNkmNvh+89ZtHxnhwpdVxRvO1oPVSymBnIgFb+V7uGGqys9fWqYxIU272khT5zJCt5eIX1f+BOV9qBejymHAU9puisTTb9oQYdm5EJQnfVOvRHvokRQjuaAEirwTYh+VV/OHC37OkaGGwWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908785; c=relaxed/simple;
	bh=sbHfpiqQwza/vNVil8M9cM43c0NojR/w7e/mxW7yxNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upKlK51Jjc6/e+3p+JhAOXqQM1txDcmvqdht0rvR+fBDXKkbTHzCTYyMIBmjKwFVY38YLdYnsTRcr6IPM2KlMkLI+OqBJQ8Nl7mNw24V6qsBZcIdK/Kta/p9jMXz2cd/Uz9xZ6mbJI9BPCxSXPyr+t9RKjTsHy4RgrNH7YpYzKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftmq6UnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftmq6UnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26950C32786;
	Tue, 23 Apr 2024 21:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908785;
	bh=sbHfpiqQwza/vNVil8M9cM43c0NojR/w7e/mxW7yxNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftmq6UnUusyPGFp1uax1XSy98Hh6uEmCriwpyznwqwmmgNG1esIixW4/nQPIYmCpQ
	 P4MsTBra+1V8NbX1SR5/gcnj6zbb5mFRqlOwDbs4LfrYKGdToXkPJ0gEXS1z50ljJ9
	 BPFu+19JBBoafBB9lR/bQ4A113GTUcqQ5xDcFZng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/71] clk: Mark all_lists as const
Date: Tue, 23 Apr 2024 14:39:48 -0700
Message-ID: <20240423213845.361058004@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 75061a6ff49ba3482c6319ded0c26e6a526b0967 ]

This list array doesn't change at runtime. Mark it const to move to RO
memory.

Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20220217220554.2711696-2-sboyd@kernel.org
Stable-dep-of: e581cf5d2162 ("clk: Get runtime PM before walking tree during disable_unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index acbe917cbe775..0d93537d46c34 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -37,7 +37,7 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
 
-static struct hlist_head *all_lists[] = {
+static const struct hlist_head *all_lists[] = {
 	&clk_root_list,
 	&clk_orphan_list,
 	NULL,
@@ -4104,7 +4104,7 @@ static void clk_core_evict_parent_cache_subtree(struct clk_core *root,
 /* Remove this clk from all parent caches */
 static void clk_core_evict_parent_cache(struct clk_core *core)
 {
-	struct hlist_head **lists;
+	const struct hlist_head **lists;
 	struct clk_core *root;
 
 	lockdep_assert_held(&prepare_lock);
-- 
2.43.0



