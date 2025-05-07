Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF38214813;
	Wed,  7 May 2025 18:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644144; cv=none; b=QOKEov6OUOEjDs0TLNyHc4hmNxjxoZd11/cYV5cax3ukZGSHliN1/AKgX9xXQZooW0ya7poJuTa67PXdvrgXuWBmk98FN0GrO/u2+S+0XrIw8jIZUdEzNCDbW7A3/oDhnAx9+nPe8RV3PaX5i7W/bjFFOCYIayP1QZzEKIljmPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644144; c=relaxed/simple;
	bh=Vui2QwIJ1aOuUs3FaB75p1Br7V8f4JdD87C5uFz1ibI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gE6c3Hndn9ppqlrLLn9Ad7gIA1+aSZlY8PDj6YkZ5Ldu3a/4fNZZKc2V5Nlave3AyLgVBuV61RL+NL8Vo6EtMV8sJA71Dequ5Nk3mRYho/FV1jciLfaE6orrhVefy9zIGTfNvTnHUj1S+X0LfsaEkW7VX7eP/mutIWGMjqdEU4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OKHL3tJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OKHL3tJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6346AC4CEE9;
	Wed,  7 May 2025 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644144;
	bh=Vui2QwIJ1aOuUs3FaB75p1Br7V8f4JdD87C5uFz1ibI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OKHL3tJAP/jR3Wrcs3/xdNO7oGkSUJAt+Hj8jFeHviRgSi5WbgYWYcnMqr4YnEqx
	 uuu7E+7opmScSc6KrPZIZ5RM+vkM6HDC02085VVga+z35SIs7Be+GC4sjgOj9t78jz
	 OVkjEL/kt2JZlFYAJJuHsIUzWzKVew9jXd3VYy+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 133/183] ASoC: simple-card-utils: Fix pointer check in graph_util_parse_link_direction
Date: Wed,  7 May 2025 20:39:38 +0200
Message-ID: <20250507183830.208843281@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 32efb30c55d69..8bd5b93f34576 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1146,9 +1146,9 @@ void graph_util_parse_link_direction(struct device_node *np,
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



