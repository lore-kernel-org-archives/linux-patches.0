Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993F7344DAC;
	Thu, 28 May 2026 19:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998339; cv=none; b=Rm9yhwc6u+0AnQHCYA3Ybhb4uT9fC2Ur+D6i2iG8Wbm38INLaAk7n+HPS58Nqbxn4v3CCB78Wt2mcU1aEbBghyYLF7G6KkrQiJ5JTD322e7+wiCi9cffwiXNIfyPJ2KBvoB32ApjVv2YsnotVg4j5BdWkcqK/hZHxWBRhpdp8rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998339; c=relaxed/simple;
	bh=tnHfvVyWyEk0LYWVmtGxQUjV149PXd6VfRUZnWRykcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BV8F6mJJF7TdJh9/xz/t57w3LCw9Jz7re3hjW4C0XsQ2FS/DX9vozDj4zeNHassBV+xlJJwhuOsDl7boHPVxyg8gfzLuM09+s1O3NH0IIGvfmrwviqLs/czCAE1Pkn4GG1EHiSL+s0RyHmtC+5/xlsUHyAT4jdinsI2O466gvWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5YZyRzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5YZyRzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BFC1F000E9;
	Thu, 28 May 2026 19:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998338;
	bh=1q0qIeEXJsGK4ghXa8DjifhqjdIzhL16O9qTSuW2ObE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5YZyRzx0cZ+9SSQO+uf4xDPbbrtEuGahFHN0f/brn8bwRyoGaPOKfZADy0T75Nv0
	 oKuSZFiwXy++YsfH3EBQDRBPn/sJK9hLZUuQgBuH8D9CRvzo4j6AYI5YZ6wH0M5B66
	 zXNRcY/jSL6IycCrGhj6ru/+YlkAOO2YIZtH4/g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 138/461] drm/amd/display: Fix integer overflow in bios_get_image()
Date: Thu, 28 May 2026 21:44:27 +0200
Message-ID: <20260528194650.989732669@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit cd86529ec61474a38c3837fb7823790a7c3f8cce upstream.

[Why&How]
The bounds check in bios_get_image() computes 'offset + size' using
unsigned 32-bit arithmetic before comparing against bios_size. If a
VBIOS image contains a near-UINT32_MAX offset the addition wraps to a
small value, the comparison passes, and the function returns a wild
pointer past the VBIOS mapping.

Additionally, the comparison uses '<' (strict), which incorrectly
rejects the valid exact-fit case where offset + size == bios_size.

Fix both issues by restructuring the check to avoid the addition
entirely: first reject if offset alone exceeds bios_size, then check
size against the remaining space (bios_size - offset). This eliminates
the overflow and correctly permits exact-fit accesses.

Assisted-by: GitHub Copilot:claude-opus-4.6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d40fb392af659c4a02b560319f226842f6ec1a95)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.c
@@ -37,10 +37,13 @@ uint8_t *bios_get_image(struct dc_bios *
 	uint32_t offset,
 	uint32_t size)
 {
-	if (bp->bios && offset + size < bp->bios_size)
-		return bp->bios + offset;
-	else
+	if (!bp->bios)
 		return NULL;
+
+	if (offset > bp->bios_size || size > bp->bios_size - offset)
+		return NULL;
+
+	return bp->bios + offset;
 }
 
 #include "reg_helper.h"


