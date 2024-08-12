Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838522C1A5;
	Mon, 12 Aug 2024 16:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480322; cv=none; b=GvSnd38zIZ7edhIjVK0nN/DHwky9PwnUkZ6TTPe9o3dw63E6OqtnKeZgyKJjrbA1Vz3ZAAIVdB4PhCOrVkVhxSX+o2FYkzrTttwWcBoq9Nz33LhpNNQaUZ+gGh9zjRCdwYx72V7WSlAVFCkyanCAvODEGLEE9zCXyNHbTMLKJek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480322; c=relaxed/simple;
	bh=WZJkkveFcDEoxLi4SrbWxM20aPg/DcYVFSszlAvkwNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+b/yKfJU//PoaSbME0coMpShhMXanvDtnQw5HrMCbEj5hfa8stlYnL1NxyYnnBLCX2LAnB7A7mbUjkSLHCxooqh0fRq91yDlYcMX77rQ/MiStaJZcrHKV/FIYLVw1IsimYXl5vOQf/JN0mmSnnreDad4zB5yW5/MaYbFidL/BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=En9hfdol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="En9hfdol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4D9C32782;
	Mon, 12 Aug 2024 16:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480322;
	bh=WZJkkveFcDEoxLi4SrbWxM20aPg/DcYVFSszlAvkwNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=En9hfdoljYh/xODamJ2Q6moyU+ZSOrmdrloB4XMqnRQtxnfXAXCjBAHgRG/ZftTOX
	 FJKTaAk+SjL1FOYLFSKecZ7W543R3UVCLtNFT002RBU+rZu7nZXBYFl7hRNqTn16md
	 0t3UERF1/gfoY043+w7cOXcN+X1MUvuknCz2bzlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 163/263] drm/xe/rtp: Fix off-by-one when processing rules
Date: Mon, 12 Aug 2024 18:02:44 +0200
Message-ID: <20240812160152.787001479@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit ae02c7b7fea3e034fbd724c21d88406f71ccc2f8 ]

Gustavo noticed an odd "+ 2" in rtp_mark_active() while processing
rtp rules and pointed that it should be "+ 1". In fact, while processing
entries without actions (OOB workarounds), if the WA is activated and
has OR rules, it will also inadvertently activate the very next
workaround.

Test in a LNL B0 platform by moving 18024947630 on top of 16020292621,
makes the latter become active:

	$ cat /sys/kernel/debug/dri/0/gt0/workarounds
	...
	OOB Workarounds
		18024947630
		16020292621
		14018094691
		16022287689
		13011645652
		22019338487_display

In future a kunit test will be added to cover the rtp checks for entries
without actions.

Fixes: fe19328b900c ("drm/xe/rtp: Add support for entries with no action")
Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240726064337.797576-6-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit fd6797ec50c561f085bc94e3ee26f484a52af79e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_rtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_rtp.c b/drivers/gpu/drm/xe/xe_rtp.c
index fb44cc7521d8c..10326bd1bfa3b 100644
--- a/drivers/gpu/drm/xe/xe_rtp.c
+++ b/drivers/gpu/drm/xe/xe_rtp.c
@@ -200,7 +200,7 @@ static void rtp_mark_active(struct xe_device *xe,
 	if (first == last)
 		bitmap_set(ctx->active_entries, first, 1);
 	else
-		bitmap_set(ctx->active_entries, first, last - first + 2);
+		bitmap_set(ctx->active_entries, first, last - first + 1);
 }
 
 /**
-- 
2.43.0



