Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D13319068E;
	Tue, 10 Sep 2024 10:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963700; cv=none; b=la3PTzF4QQm7WS+SgyNhcPjBTjlXr7ZdqWH2/p1nTCbfEMW6f7EsnOIAf2yNi9W5gF4D3g9islKN154bqJFESi+Fv27gucebQBo71+ojlxWO9xds+EflRiWtXa5/kCde3myS9jBU5CZaFQfc5YKQ3z3MPr2+0mxZ3VtaH6LzpxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963700; c=relaxed/simple;
	bh=kGvEwT0vXv6dwzjaveXedjlI1H5Vgh/aoVdSqfunJss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ihWojvEs3Fre7RbxgNOpUxR5FB4QjZ2LhhIPdtDaomPA6qZXERodqFx64eauTBxKC3HaiHNHCzHBUfMzSdRsi+wykxiVJLi/22pz6l/ms7ifMJ7l9bpuOfMfsMOv8vNJz0BdQuuS6MUUwJX+j4sMbpIxydjqJKjRU1aQ16J8cV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncp+p0qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncp+p0qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6B0C4CEC3;
	Tue, 10 Sep 2024 10:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963700;
	bh=kGvEwT0vXv6dwzjaveXedjlI1H5Vgh/aoVdSqfunJss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncp+p0qvpMO/UFIOfDNlloBUoO535M/3hwvS/sbFdSzzZzd/kR7Kt07z3nmjsoioZ
	 wLtOZg/0E7t8uyxkQ4gYZNr+Z8wgB/p/ELS3Rjnne9rNIFz6q6Bkyk8PbXmkkT1c9I
	 2MI9vEOFgwvJOqf/9lrc4BZkDd1tOApPRnuHei8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/214] drm/amdgpu: check for LINEAR_ALIGNED correctly in check_tiling_flags_gfx6
Date: Tue, 10 Sep 2024 11:32:21 +0200
Message-ID: <20240910092603.652024376@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 11413b3e80c5..1f7ddb65383d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -842,8 +842,7 @@ static int check_tiling_flags_gfx6(struct amdgpu_framebuffer *afb)
 {
 	u64 micro_tile_mode;
 
-	/* Zero swizzle mode means linear */
-	if (AMDGPU_TILING_GET(afb->tiling_flags, SWIZZLE_MODE) == 0)
+	if (AMDGPU_TILING_GET(afb->tiling_flags, ARRAY_MODE) == 1) /* LINEAR_ALIGNED */
 		return 0;
 
 	micro_tile_mode = AMDGPU_TILING_GET(afb->tiling_flags, MICRO_TILE_MODE);
-- 
2.43.0



