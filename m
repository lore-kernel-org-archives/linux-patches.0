Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70A634D4ED;
	Fri, 21 Nov 2025 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732441; cv=none; b=ZESb4HephvA8VMyM7zHS/JfF20fW/R58Urz2BNtqczlco4nPOuIOLtRxnItPRdqYHvppCoug5JYUVJ2qMC+u00ruqTfds8mb8CpO9OSW2qiBanpIP8wt5fRmUCQgF4c4JwK+wysmMq/Y8uZP7v+Xi6/V1mXq41HNMKGDtQIbqQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732441; c=relaxed/simple;
	bh=8/KyKQrRnd3r2zpNUchCZO9YfuyptC5UZDGUnjyuTJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqZfm3XcyRgsKoilRKrkvU5EzzDS31KE4PxAUEB+6JicTIq+CZg5abawZVJAyqsRKifWHJWNfqwC9oCKf762MaqIlXrxogaL8SHpP0gpG8v27cHSdfUzIZdfzDiemU2vDMFBoVMiBVengVtXLqB2vFUm5oqLX8CJ7qrbDap5c9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNZzwhPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNZzwhPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323F9C4CEF1;
	Fri, 21 Nov 2025 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732441;
	bh=8/KyKQrRnd3r2zpNUchCZO9YfuyptC5UZDGUnjyuTJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNZzwhPmimdOXdkPbeSh+PwOw/rj9PQTX/LsM+FpGN092/qOGj1Khu0rFGG6OZ+YG
	 ieTWpQUXLQHqKfClyhVylfd8LMuQkBpTaB0nX45RSQj0Zj752PcDioSYR/sQqgpsI+
	 T2vEAEUxsbc7castGlppUiKV+ZJ1JglgHfEoY/14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/529] drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()
Date: Fri, 21 Nov 2025 14:07:01 +0100
Message-ID: <20251121130235.364189710@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



