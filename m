Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0097E7469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9A7C433C7;
	Sun, 17 Sep 2023 20:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982321;
	bh=FKBJ5R9iTA+fU2YExrqrdS2SgT84/RggpNbMH4/H5no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6p3RnXkF9u9BehTyn2ntaQbtAhkwE5IsxDKadGKWfGPrKSOE+6LrFH0VeLx0M4ZI
	 S0Q1umAYYSmTeOQEGeVl7eJ+EPMGiAtwKGP0qKOFIUZBlG6kqLANuK9jQJ2nACycyp
	 /RX1gt4IRF7oW5K2du6pLZ4uJRGur27o36eri/Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/511] of: overlay: Call of_changeset_init() early
Date: Sun, 17 Sep 2023 21:10:17 +0200
Message-ID: <20230917191118.411846416@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a9515ff4fb142b690a0d2b58782b15903b990dba ]

When of_overlay_fdt_apply() fails, the changeset may be partially
applied, and the caller is still expected to call of_overlay_remove() to
clean up this partial state.

However, of_overlay_apply() calls of_resolve_phandles() before
init_overlay_changeset().  Hence if the overlay fails to apply due to an
unresolved symbol, the overlay_changeset.cset.entries list is still
uninitialized, and cleanup will crash with a NULL-pointer dereference in
overlay_removal_is_ok().

Fix this by moving the call to of_changeset_init() from
init_overlay_changeset() to of_overlay_fdt_apply(), where all other
early initialization is done.

Fixes: f948d6d8b792bb90 ("of: overlay: avoid race condition between applying multiple overlays")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/4f1d6d74b61cba2599026adb6d1948ae559ce91f.1690533838.git.geert+renesas@glider.be
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index 8f2ddba3947e5..ee7f3659b353c 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -752,8 +752,6 @@ static int init_overlay_changeset(struct overlay_changeset *ovcs)
 	if (!of_node_is_root(ovcs->overlay_root))
 		pr_debug("%s() ovcs->overlay_root is not root\n", __func__);
 
-	of_changeset_init(&ovcs->cset);
-
 	cnt = 0;
 
 	/* fragment nodes */
@@ -995,6 +993,7 @@ int of_overlay_fdt_apply(const void *overlay_fdt, u32 overlay_fdt_size,
 
 	INIT_LIST_HEAD(&ovcs->ovcs_list);
 	list_add_tail(&ovcs->ovcs_list, &ovcs_list);
+	of_changeset_init(&ovcs->cset);
 
 	/*
 	 * Must create permanent copy of FDT because of_fdt_unflatten_tree()
-- 
2.40.1



