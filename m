Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7612DC35A;
	Tue, 11 Nov 2025 01:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823210; cv=none; b=sAhMFhtfQ16rl2hHQLcsXfJf7VlR1r1KFt4VhRzJvQ/dq0As/eoig+gIQCcfxp49haMmkALMrSbw/6czVIbJevC41APtogo6xOF4BrVN6FyHaeraz4AlHykUx1NxUbn0whuRK6QkYpY+06Tw5O1YBzOhZy1IzGh/P7sjtwK6Sjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823210; c=relaxed/simple;
	bh=dtq16UT8eGHiiwym3rlk0hFs8hdATeevvxShHfWZ0VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8/IjGGc0apE5dIQ/VpWLK2fIcbUNPtx7h+1L505pnj5zQ4wLoWmLoT1nmJw/Ax7RSk3VMy/6DK8ihxuE2lyb2ooqlE0Vyqo/1wk/KgIYcRPErZg1NaD37jkbZ1IZc5jz+bgxO0OtLK0z328moEpEn8L9ueCw2jybVl0WQ5eais=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stsF3hpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stsF3hpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDB2C113D0;
	Tue, 11 Nov 2025 01:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823210;
	bh=dtq16UT8eGHiiwym3rlk0hFs8hdATeevvxShHfWZ0VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stsF3hpc5OoonH9utBMKEa+Ayowe7oy5FP950soSUOwQTtRJSpGNtzYOfrZudk4Er
	 OMFrEx1CVM7eJxCL2qCP30rFti5zgl/WHc9jEKQRMBDKS7JpiwddGQ7qrS+vibNqXD
	 ZQXLmmCLOBzHEXz67z/7fpfJvTOCboeTFhOWdijU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/565] drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()
Date: Tue, 11 Nov 2025 09:40:44 +0900
Message-ID: <20251111004531.161736423@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seyediman Seyedarab <imandevel@gmail.com>

[ Upstream commit 6510b62fe9303aaf48ff136ff69186bcfc32172d ]

snprintf() returns the number of characters that *would* have been
written, which can overestimate how much you actually wrote to the
buffer in case of truncation. That leads to 'data += this' advancing
the pointer past the end of the buffer and size going negative.

Switching to scnprintf() prevents potential buffer overflows and ensures
consistent behavior when building the output string.

Signed-off-by: Seyediman Seyedarab <ImanDevel@gmail.com>
Link: https://lore.kernel.org/r/20250724195913.60742-1-ImanDevel@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/core/enum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/core/enum.c b/drivers/gpu/drm/nouveau/nvkm/core/enum.c
index b9581feb24ccb..a23b40b27b81b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/core/enum.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/enum.c
@@ -44,7 +44,7 @@ nvkm_snprintbf(char *data, int size, const struct nvkm_bitfield *bf, u32 value)
 	bool space = false;
 	while (size >= 1 && bf->name) {
 		if (value & bf->mask) {
-			int this = snprintf(data, size, "%s%s",
+			int this = scnprintf(data, size, "%s%s",
 					    space ? " " : "", bf->name);
 			size -= this;
 			data += this;
-- 
2.51.0



