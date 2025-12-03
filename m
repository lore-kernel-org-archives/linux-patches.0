Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC48346E72;
	Wed,  3 Dec 2025 16:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777622; cv=none; b=n7tDeicfziNx5VJHkxQAwvxrYWu/M7trgHU8GPofnic7HfJ+/SQ1wFwcNRWPvnZRNR4U2mwE8hhd90XRq/hFD2Qcj+cWIy7QDhOb05nt0aXqQikDSQLEXcE8sOUPqYQBztznvT2tyo33rtxFl6ea7BSrlXIh0evsCHblrxGskQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777622; c=relaxed/simple;
	bh=+AMqbujxpTymEembM702tCSVaM9eXHgAPGw08IU24A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFLMMYw1PcLhNQAmdQrPiZVTu4IM9+SP19qmi/XMBKJXPB8Uw6kGc7MIHi5EsXtVOKCDj19KMWNw9x4ztK+OGmJsWu1Yj7Brn8gXWzCFHuAggNQza8yGsb4OFJfxgnLBNBRb2E3o/PXq/pc/z2u7445v11lLA8SgQlW4BeMXqtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oeXN28D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oeXN28D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CB6C4CEF5;
	Wed,  3 Dec 2025 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777622;
	bh=+AMqbujxpTymEembM702tCSVaM9eXHgAPGw08IU24A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oeXN28DrjlK6bNS2SHHxwiRspolqOf9puhsEvOm5ZkoAyuIIyb/oe/F8lTKwhWRK
	 HeMdbyQrA6PlbttOdveN6KgWJamunYxOMwzgYcuTmes892Xak9enjhgUvAVDx//7qX
	 3ee9DBO92w6T61KgJtzEH3LC9Uyt9O/P3tJAwFjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/392] drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()
Date: Wed,  3 Dec 2025 16:24:03 +0100
Message-ID: <20251203152417.524915159@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



