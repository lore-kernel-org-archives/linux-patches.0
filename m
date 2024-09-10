Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2C219923A;
	Tue, 10 Sep 2024 10:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964261; cv=none; b=DVPSK95NxAETaI+Fg+vmNFSm+sHduzYEhzjgpY9gcxQPi3zXZ55uJ+2KvHvJ/0nGRLu7yOCcDod2kJq8L3zdtdJodSTR33I0qvSyV2D8EZi5wz/yN9sAaArXYxMl8KBPjigRFzmSlzTd15OgcFk2BJ7DIfjS8m0i0PAceNyEbOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964261; c=relaxed/simple;
	bh=/AGYgotNZikr+BjL6vNXBV1T7DiloU13tIgQoUIA/iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dTPBhlDGRj/qTnQQGgCi3Kej3XQrgszvVG6ULEk8XdUkpjH/9QC/3DV9J0zf9SbWN1Kp54sPnrZRsK/pfC1nvv0loomRS1pa3vyXVawYo91AXHeEUJcEBfiCcNMvNoh2dJj6hMqLFQby0EP3IKblXvAu1jyDngeP8kL5/LdB3bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHTDi7RI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHTDi7RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29580C4CEC3;
	Tue, 10 Sep 2024 10:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964261;
	bh=/AGYgotNZikr+BjL6vNXBV1T7DiloU13tIgQoUIA/iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHTDi7RIhhL7YHjhBKTZZQLekbHxJbG//P/TAut1HJYrU2e8iKjcK/OCj/Qn85C7I
	 TOv9Vhk7OH0R+CulHMczs7akDU1hnl+Fr8fPPVJF7qcX8w26rsqTZ/h2A7wUKtT5MG
	 pLQMPjcLMAEB+mgl5yZ7Lv2vCRDUr3VVrggZ1xac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/269] drm/amdgpu: check for LINEAR_ALIGNED correctly in check_tiling_flags_gfx6
Date: Tue, 10 Sep 2024 11:31:22 +0200
Message-ID: <20240910092611.594865843@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 578aeba49ea8..82ad2b01f2e9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -909,8 +909,7 @@ static int check_tiling_flags_gfx6(struct amdgpu_framebuffer *afb)
 {
 	u64 micro_tile_mode;
 
-	/* Zero swizzle mode means linear */
-	if (AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) == 0)
+	if (AMDGPU_TILING_GET(afb->tiling_flags, ARRAY_MODE) == 1) /* LINEAR_ALIGNED */
 		return 0;
 
 	micro_tile_mode = AMDGPU_TILING_GET(afb->tiling_flags, MICRO_TILE_MODE);
-- 
2.43.0



