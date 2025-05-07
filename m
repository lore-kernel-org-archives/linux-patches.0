Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F9928E596;
	Wed,  7 May 2025 19:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644701; cv=none; b=m2wKAAU/bH5FcE21WnAs5s3+TRBS+XrvBK8kGq63aguMMt05JkVZE/NXAKRVOOFwM2vrFA7VzhD+ZRUxRKg8yWAecSuzWXDkrZo3w8Ubf4ee3XO7UQllQRzCCs4Tbyus5z2BnK7LyQ5svmh1fuquU9pgkL+/ucvL4NRnG7nWIwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644701; c=relaxed/simple;
	bh=OjBu5Xp60UNFrapSqpe1dtMrAoecNpd6o/hYSckzYiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4QXv2EJTFoeNUGxZ8ZBaZ4+X9U1tFuuro8UOCXVVfos3EpJV5ZPeLu6Gqz0ZJKRQxbIIUEu1wbAbW/Gm0oQs9seEQg/ypxY+7AERBtCPqH0DRmNL293yfvjf0RgFSXfcjTK2EtSX7+Nv3qI5sV+QZ3xfAu1q23Cs6/ZDkPb728=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1LklG/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1LklG/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13119C4CEE2;
	Wed,  7 May 2025 19:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644701;
	bh=OjBu5Xp60UNFrapSqpe1dtMrAoecNpd6o/hYSckzYiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1LklG/5SrLUR3718n2vMh05moc0WBEdoq8Fg9z4r/Xt9vYDF6VEAZzQJr7sMTZOP
	 LjKiM7PdWiLf9cbh1s5UgHzk35zyniLSQntGtIsfq3O6RZg2Xf9RM31dmc24KkOC/d
	 EsVQ4FKLRwM/iAWwnZa5NCGB7CbwoHauxFDcSbac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/164] ASoC: simple-card-utils: Fix pointer check in graph_util_parse_link_direction
Date: Wed,  7 May 2025 20:40:06 +0200
Message-ID: <20250507183825.872516100@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 3cc393d2232ec770b5f79bf0673d67702a3536c3 ]

Actually check if the passed pointers are valid, before writing to them.
This also fixes a USBAN warning:
UBSAN: invalid-load in ../sound/soc/fsl/imx-card.c:687:25
load of value 255 is not a valid value for type '_Bool'

This is because playback_only is uninitialized and is not written to, as
the playback-only property is absent.

Fixes: 844de7eebe97 ("ASoC: audio-graph-card2: expand dai_link property part")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://patch.msgid.link/20250429094910.1150970-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 975ffd2cad292..809dbb9ded365 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1150,9 +1150,9 @@ void graph_util_parse_link_direction(struct device_node *np,
 	bool is_playback_only = of_property_read_bool(np, "playback-only");
 	bool is_capture_only  = of_property_read_bool(np, "capture-only");
 
-	if (is_playback_only)
+	if (playback_only)
 		*playback_only = is_playback_only;
-	if (is_capture_only)
+	if (capture_only)
 		*capture_only = is_capture_only;
 }
 EXPORT_SYMBOL_GPL(graph_util_parse_link_direction);
-- 
2.39.5



