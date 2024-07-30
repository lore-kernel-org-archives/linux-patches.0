Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F501A76B2;
	Tue, 30 Jul 2024 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360045; cv=none; b=EqOa3YcwF0d4dwAOpssCH2L5ssdj2GbFwTBBGlTLwkZqihHPP678dGZ3RGR2vxunZHmLTJDo8dYsTcb59JG7X4TrCdbEWbKtUdqPqlAT+0tlWjh35Q5LUnplcvCiZoDFqO8HwF92vYepNGgJqbGbC/CxXaMlJX4QZkUf7rnF7VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360045; c=relaxed/simple;
	bh=ZgrPRf0flEbtqCDLINURLq6+hmIjdYlTTeifhHaX+Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNtnjwaDaK//wrHmCHqoRpxDa+HsW0QCL3CEwB0FSu56VAokQqQL27nAIHkI2gFTq2LnhZV79p8TtR6CGuGZcUxHc5q9ypK0DPOBa43q+GjFUZGFjtYKdN9VDQ1GNnJxGCCn0heX4N6FZIPbNUkPtyZeG5DtTuNNJZ6h7Nc1pr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwnOoHQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwnOoHQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91939C4AF0E;
	Tue, 30 Jul 2024 17:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360045;
	bh=ZgrPRf0flEbtqCDLINURLq6+hmIjdYlTTeifhHaX+Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwnOoHQOgyDEgkd/zsd7eGZEX+qBEz8jaxh3/uK780Jjcs+y6gzUUv/VD11MbPzLW
	 XKFKzxdLaMFzIlGitb+zN1tPsJDZ9TUnMGs09PSVVn6KegocV2YFIHDU0bVG28QnI1
	 YLjWJOwAW2MQ5f+vd+GA9ABW761kqTDZFn/GOaWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.10 579/809] drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes
Date: Tue, 30 Jul 2024 17:47:35 +0200
Message-ID: <20240730151747.649476999@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 2df7aac81070987b0f052985856aa325a38debf6 upstream.

In psb_intel_lvds_get_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 89c78134cc54 ("gma500: Add Poulsbo support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709092011.3204970-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/psb_intel_lvds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -504,6 +504,9 @@ static int psb_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


