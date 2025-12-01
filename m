Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF90302CD6;
	Mon,  1 Dec 2025 11:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588532; cv=none; b=QOWCtF4tWYwJ8y0DyxxZ65O3kc5I6IxKQUqOs5AVjlWIMuX32txgOgg63NEBrvABUsjBZa/fsRIr6Q+2B2d8Zb7Wd/4MZ/MwNcs6SpQv2UDOBq0KTOmpY5H1plGE93VBElIlrenY5xKtUZMySbe/Aw3Z7+yItYFxeawyoHxD8vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588532; c=relaxed/simple;
	bh=vDG12SdH8nIWQFCM46LIPxvycUHwa9GORqMlFLjv6mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keZOxX2mYPIZNzbfqVN9umi/TgOUI4zvXeKAhk66qZBTUjps4A5p40npKcrpUElCJQ7M2WKQOtYDPSHXjm6uqUsqoMiBkl+UaAxe3yJFZsqU/n8wyIrw8u09Y06qXbo3DKu9gBABr82FlwpOYRTGzS+25YWm4/3ADEb+Ujz4Eb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMPvQoMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMPvQoMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC73C4CEF1;
	Mon,  1 Dec 2025 11:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588532;
	bh=vDG12SdH8nIWQFCM46LIPxvycUHwa9GORqMlFLjv6mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMPvQoMru5ZDFMrzvvNE2OcC63zMv96ae6n880WByJ4hPm0vGhErbTdwWO7nlfH8E
	 4YZFlWKvf/5mRUPpJDOmUJCxnB3Nln6wZcdk/tPuZS7snywiEKwNSgY8ZSxM2XyKEH
	 0cZCS5efU5mjsdfwHCDd692yfUMHgs+gIvuwSVRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/187] drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()
Date: Mon,  1 Dec 2025 12:22:36 +0100
Message-ID: <20251201112242.983093790@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



