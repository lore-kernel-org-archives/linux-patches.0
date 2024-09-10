Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACF8194ADB;
	Tue, 10 Sep 2024 10:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962898; cv=none; b=GNQZMn/TqEt9kb7RZcDhgvS4XBqU+MI+6lm6MhNgqhRPD23g1KG04fzzbrPw45rUq6da2uV+bhKwaqP7aJgp5rM+2LsR36srdCA3MIbZtDoQjgl+kY5DgttoekP/7zAYIYYY/sz3REQWK7pBgb04gPeYwkXW0YHhU0cDQV8q9yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962898; c=relaxed/simple;
	bh=4LGTeVzRH9wsHQ1+gad8MazyvEyyNdZrAxzPJLWKtEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WmLrBNTmTFIxJS5GKnHBduFAO1H+0OqiUllAsotFdImGbIiBL0+oQqQ3c0VJ+zkh2zU29bhsLpK65sn8VyrkF53flV4lQlLMHN73nO6YSOwL1bcgGbSffDWqhUd3BbE0+qEl0yGYC+vArgn3X5PH5okNkZsW0Rn7C0Q81uhcWeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIUnQ0q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIUnQ0q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A12C4CEC3;
	Tue, 10 Sep 2024 10:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962898;
	bh=4LGTeVzRH9wsHQ1+gad8MazyvEyyNdZrAxzPJLWKtEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIUnQ0q8B93LToGjZQ/XtZYDXFN1dWhNBWH/UAVnE3uJ+3mJNzZvnIVs/Z8e8HaHC
	 Ztok4oa8+IwlP1gT7W1He/+Yry0A/KyUw8B14rKhha/L85oyxiHwYPrnd9P/ShUfza
	 0SjVFBkTGhHA9biG7OHxJI8B0bjn1oSaP4DKYWQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/192] drm/amdgpu: check for LINEAR_ALIGNED correctly in check_tiling_flags_gfx6
Date: Tue, 10 Sep 2024 11:31:31 +0200
Message-ID: <20240910092600.753578828@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Olšák <marek.olsak@amd.com>

[ Upstream commit 11317d2963fa79767cd7c6231a00a9d77f2e0f54 ]

Fix incorrect check.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index aabde6ebb190..ac773b191071 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -873,8 +873,7 @@ static int check_tiling_flags_gfx6(struct amdgpu_framebuffer *afb)
 {
 	u64 micro_tile_mode;
 
-	/* Zero swizzle mode means linear */
-	if (AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) == 0)
+	if (AMDGPU_TILING_GET(afb->tiling_flags, ARRAY_MODE) == 1) /* LINEAR_ALIGNED */
 		return 0;
 
 	micro_tile_mode = AMDGPU_TILING_GET(afb->tiling_flags, MICRO_TILE_MODE);
-- 
2.43.0



