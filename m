Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40542BB1B;
	Fri, 15 Nov 2024 06:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653915; cv=none; b=WaWGM4eX6oXyQfgL7+aNJkyYj0u/qn8eXfjZwASPo0Ql/x8WLQpf5segtjaA5Eew2xM5m4dfBe8iDTUKdrRVL1Auktr4UfgUVW4Lgm/Elnc5mwdaQqwNOXLX8MEdkJ1eZkG8E90e0boao7HWUfF5DabTiECiq2KZ9w5+1XtFzSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653915; c=relaxed/simple;
	bh=qkddp2HSVhLouY9YJwXJCNhG8CHK2jJ6QUQ7sa+G/Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZ0XxdP9SObQpnYs/kGYWSkmN61dc5Sf+MeJrovQUANrkiC+9s5Z7kvIk7N9B72P4cDRWAKwPsCTev7BNEinFoKbGkegrMQ5QBwX+Si9rQU5f1UcGT81C/sZD26LRxYTSgAjgKcEyOqYlUr5lNvBWRklRcQcX8LKbH+6zh3G3QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLN/WPqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLN/WPqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5961C4CED0;
	Fri, 15 Nov 2024 06:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653915;
	bh=qkddp2HSVhLouY9YJwXJCNhG8CHK2jJ6QUQ7sa+G/Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLN/WPqiL6MpVRtbqaLmqV2Iyteo3KE3GQGPG/YuXNduxFt0MFTFULAmAAiBu6DfD
	 l1amvxIEvXK1lb+FxITa6KjuIdD1klNB1/zoywjU6XevoATyqUfIu2A5Gr3oJH9ksz
	 jxC4JAVTm8Whekzah/L5bbkAfFeqC1fT8ZRNJeho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yann Sionneau <ysionneau@kalrayinc.com>,
	Julian Vetter <jvetter@kalrayinc.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 74/82] sound: Make CONFIG_SND depend on INDIRECT_IOMEM instead of UML
Date: Fri, 15 Nov 2024 07:38:51 +0100
Message-ID: <20241115063728.214125914@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Vetter <jvetter@kalrayinc.com>

[ Upstream commit ad6639f143a0b42d7fb110ad14f5949f7c218890 ]

When building for the UM arch and neither INDIRECT_IOMEM=y, nor
HAS_IOMEM=y is selected, it will fall back to the implementations from
asm-generic/io.h for IO memcpy. But these fall-back functions just do a
memcpy. So, instead of depending on UML, add dependency on 'HAS_IOMEM ||
INDIRECT_IOMEM'.

Reviewed-by: Yann Sionneau <ysionneau@kalrayinc.com>
Signed-off-by: Julian Vetter <jvetter@kalrayinc.com>
Link: https://patch.msgid.link/20241010124601.700528-1-jvetter@kalrayinc.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/Kconfig b/sound/Kconfig
index aaf2022ffc57d..cb4cb0d5b9591 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig SOUND
 	tristate "Sound card support"
-	depends on HAS_IOMEM || UML
+	depends on HAS_IOMEM || INDIRECT_IOMEM
 	help
 	  If you have a sound card in your computer, i.e. if it can say more
 	  than an occasional beep, say Y.
-- 
2.43.0



