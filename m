Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92529313271;
	Wed,  3 Dec 2025 15:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776173; cv=none; b=oDLkx+DnFOpYtQfdtQbbuTHcohVI+KdIfHZT/hk1Ma+y8k+78vyWV1/JwLHc9a1ywKVMJBP6HtA1PeMGngs6/B4ovB7B1/IPfWQTOydMuI1mOKi72kMHAzfBgwdJe6f36Kg6cVCvtxZ/evYU367+4e9iqkI+OKWRHZgpe1DhtoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776173; c=relaxed/simple;
	bh=t+FwBxn4EQfgWcfmS6OYrh7ywagWTfmSgjbVTtot7pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QziuzPdD3z9Q/Kej93uTEe+PFeqqyLGYIHXAGUFtjmWr9Bmb+caNGtRM3r8z17oUbwsgSyv46+msjiSis/H95jiaDlgUlXSjn0uBWnYxFykkA7HL1yRvoAvcbnayfXiicpPcSbBNKaB6lhK263fXuiBaqiuJE0vsptxz8D32vO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtnZL/Zz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtnZL/Zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D1EC4CEF5;
	Wed,  3 Dec 2025 15:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776173;
	bh=t+FwBxn4EQfgWcfmS6OYrh7ywagWTfmSgjbVTtot7pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtnZL/ZzYzbOfGocsa0dcDdFLLFcQ9MN/vkEHvK4SLEFZACX6f84GTgTucj6yfc9l
	 jAt3dcD8CYn3ZibEoWUVJ9dt3MmoQHcoEk7vSKTWi44dv4zrxox1oPf8s4ug0K2uha
	 t369bRdu8CZTyFJCTKMt47JxqdOnVgtONbZV22hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/300] drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()
Date: Wed,  3 Dec 2025 16:24:34 +0100
Message-ID: <20251203152403.214620382@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



