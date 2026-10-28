Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216774;
	b=GaHi2en6qPM6pYor/b69Pk3F0l4zsLcjgjSSE4X+hK4yNrzW89hdWSbdyL8fH/wwSdhY
	 c1aRkY1akoEQ7H9TCtTDh+VmX3tcNvl0BjX44VxOold9H/iqoMLWojzsTkdGQMGDRarMw
	 FMvmsogYYkCp5wasH/Z//cUDf7oTdNv7ckBN75+ZZviilIXYijVhyjd+RCxNLQTucIwUT
	 UsPdyujoYOmRj66qYaG4ArJfsSvUIHPDcb4eD5gUJQ1gOeWHDvWBc19dGBim9vzeaFyR2
	 LpySym/6IniapAvSleykk5ipkWYRbj1q6uUz8b9RZtHZFjCJccdX1hTum2rF928/h6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fJMyMK35Odwf63oNYKwSZoH/QBDQveF+KrXSvfOR8/M=;
	b=UqHDpChrzrsIg1fT5xcfQWlLIZ4hmGf7dMvVqTSkhpsGFjl93JsbfyTkgZPkSzyKtdQX
	 lqgSrl+nE5vK+665YGjMv6bgpwitIN7Yff8+5IQZyraWJESnaVOZ2YkWoBsmSH0GxVeEc
	 LarEIBNgXx3ldP2URSKEFYZrZDfUQMYknSXYo6iwCXZGVXtd8HAo5wn8UEZgwkYdu0XqH
	 djkplkFimrZEj50GOE+ENeRTJwFyLI4f73altAXJsaMSvNyBya+XIIXO098ECEBtmVbYt
	 w6EpJJWsk3aFAn2hcW+feDhb973jdPl5HuRmmIo8ZvyTGSSQ3CfGJVWeyP38eSOweaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dQz5mvEe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B397606A31A;
	Wed, 28 Oct 2026 19:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dQz5mvEe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2F21F01825;
	Wed, 28 Oct 2026 19:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216773;
	bh=fJMyMK35Odwf63oNYKwSZoH/QBDQveF+KrXSvfOR8/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQz5mvEeXEeRiR/AXE09lH84V80ySBj1wyzdgysLb09lWnLhsgQS4ngCYn9Z5sLpt
	 oFxlBCAHqe8DbCAhTE49it3R1mZFrGJOXLpeNmBk5qQ4uLyMGuX2S4GBgwrIUOXQdS
	 9SwQcdRfmjO62IOr5xp5g+tLOxrkViDblm2oCnDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwu Zhang <shiwu.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1673/1887] drm/amdgpu: fix buffer overflow during vBIOS update
Date: Wed, 28 Oct 2026 18:02:49 +0100
Message-ID: <20261028170537.527574985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiwu Zhang <shiwu.zhang@amd.com>

[ Upstream commit 6229898d46c0cbc238a6fe9f11c1ea12cf8bb9c5 ]

Clamp the buffer postion to write by setting the bin attribute
to the maximum buffer size so that VFS layer will block the
out-of-bounds accessing.

Signed-off-by: Shiwu Zhang <shiwu.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index f049b625e8988..e7ed99560ffb1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3616,7 +3616,7 @@ static ssize_t amdgpu_psp_vbflash_read(struct file *filp, struct kobject *kobj,
 
 static const struct bin_attribute psp_vbflash_bin_attr = {
 	.attr = {.name = "psp_vbflash", .mode = 0660},
-	.size = 0,
+	.size = AMD_VBIOS_FILE_MAX_SIZE_B,
 	.write = amdgpu_psp_vbflash_write,
 	.read = amdgpu_psp_vbflash_read,
 };
-- 
2.53.0



