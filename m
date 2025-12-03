Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442C435CB7D;
	Wed,  3 Dec 2025 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779182; cv=none; b=HoNH/K5tMnGov++0Uln9FnMCW6MGbsktcR13wunFmR6S3OaM/W4h2S45e46TXhH15iHEv6fElomsBQvaLYwgVu9up9Z8sje6O74phbT5qI8FeJT2czOKkDMX4IF7won6jOq5yTmp6phlaqjZuLeS+saEOfOulicnmNrosdmwWXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779182; c=relaxed/simple;
	bh=P2pQh9dBbm4W0NBUuhceoEcLBbZvrryrF5+6T7Vtc9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joFTmnH6VT0V87uYZ5PaL09g1AoZCI72gdHYFlgzQicviBwwMzt+eE0Rv7RGwM6HIP4Ef9d3uj6LsryX+6yhXvAVI8HKYtPlxRsbYCaKB8/qUAefiZ/fzg9wO/3wheVq6SRfMueU2hMVPbjKhGx8QugPGFPcoSQ5afrbRCnFt4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2s9u6uCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2s9u6uCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A10C4CEF5;
	Wed,  3 Dec 2025 16:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779182;
	bh=P2pQh9dBbm4W0NBUuhceoEcLBbZvrryrF5+6T7Vtc9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2s9u6uCJjbpVYbXa9TxkSJLLN2ki4ICjPtfY2uh/W++mGMv7WJ0zlT+igbyr4bqP+
	 xH3XMLFYlhYTcIEunEj4+KlWhf/te5XH0ctg8gzxQcDuHDWZMRASkt6w99OY0MnmCS
	 J2W0QHfod/qjX8eoq0O5TAr9lFoZxrHFOVdHYjtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/568] drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()
Date: Wed,  3 Dec 2025 16:22:19 +0100
Message-ID: <20251203152445.743713875@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



