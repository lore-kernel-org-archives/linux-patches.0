Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5143511710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5625C433C8;
	Mon, 11 Sep 2023 15:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445373;
	bh=wWAAX576/+Vr5q0ErKXH29zxUfchePIUsJRwyzS1aTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCNpVoHNhCv9v2vEUwlEqQwgJm71V2zikZSxkhuMMKjApAz2q7gAeoWJkjYu+7n7i
	 PFuOcGy2Egb9MJSxkRnf4glosszAqiEGV5C0MxW9X7xIQZ/DYioNFc6x7DEUjeuRUO
	 VBDtnyInmoLOt1jelvN9w9IWYI8a8yG4+3cQ7Pz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 323/600] of: overlay: Call of_changeset_init() early
Date: Mon, 11 Sep 2023 15:45:56 +0200
Message-ID: <20230911134643.224885179@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5289975bad708..4402871b5c0c0 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -752,8 +752,6 @@ static int init_overlay_changeset(struct overlay_changeset *ovcs)
 	if (!of_node_is_root(ovcs->overlay_root))
 		pr_debug("%s() ovcs->overlay_root is not root\n", __func__);
 
-	of_changeset_init(&ovcs->cset);
-
 	cnt = 0;
 
 	/* fragment nodes */
@@ -1013,6 +1011,7 @@ int of_overlay_fdt_apply(const void *overlay_fdt, u32 overlay_fdt_size,
 
 	INIT_LIST_HEAD(&ovcs->ovcs_list);
 	list_add_tail(&ovcs->ovcs_list, &ovcs_list);
+	of_changeset_init(&ovcs->cset);
 
 	/*
 	 * Must create permanent copy of FDT because of_fdt_unflatten_tree()
-- 
2.40.1



