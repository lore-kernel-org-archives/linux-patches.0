Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E5D26E706;
	Tue, 11 Nov 2025 01:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823252; cv=none; b=TtHVYlyTK+AFUx2lHyATWtiTL0AAT5AVvDBSEsDw+Ne9RuPauoy7Uw8HnRMyw3Ut+XZUSuPtacDyMcittsrZhXZ+SUh3aSwgTT8D+iGfvB4ERVl3OmS1+XnsSetSrqfFGi2P/dtzduTBdsZ88Pysj6RIcMAMXwyMAW9bB94/jBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823252; c=relaxed/simple;
	bh=zaiM3i7N+eYJxtEQ/Ajt1mECgxEZtpBo6DqhsrZRfgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR/iTerS2nViBX5ZCSRSKkmMRy9KOiG3hue4sM3B5GEoMOUG0cQCg3hbA19vypFu6ZDJFsA1pv/cLSdYRt0vcquOT+njn7GeFeV4rDt+uW0tX2mwGYyjNZzBUzZO4GznFbqFD3r0K3Qpq+OmAP/R/ll7RYIMIGeZ85gG78NY1zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNlt7IVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNlt7IVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4761C16AAE;
	Tue, 11 Nov 2025 01:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823252;
	bh=zaiM3i7N+eYJxtEQ/Ajt1mECgxEZtpBo6DqhsrZRfgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNlt7IVywUXUv7lhrvUHcBOKgwpi0kHV9ikXVfpAW4BUfjrN1Hoj9IJ8cz1YC1FvD
	 7qU9ZLR5WQjQGe5QT+uEq5qwT/gdtNWQxiMCoeyX38JH6BI/siESLALPRsp02MnzPu
	 P/+q7X1/wDam1xLh6q7bzNDczAGmlNOEYaPTx2LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 262/849] drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()
Date: Tue, 11 Nov 2025 09:37:12 +0900
Message-ID: <20251111004542.767890624@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



