Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489DB16419;
	Mon, 23 Jun 2025 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685994; cv=none; b=uPUjH6DT8O9LVMwzBCzhHnLqImPsff5Id0NuzpbWEPBAWyQenNH7WmNrdQI3g1UHnpEDJFlyBef/7U/Z/iAXNWxIhrMkSGIzvysCCC924RBfOShmFnQKZsk/3YOX1cpy5tTEcE6erUh63tQXiB81NtFgKTOzNaWc4FcPwS1qLTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685994; c=relaxed/simple;
	bh=qWg1gKEXQ1V7UVM24j6v9d+n/nOAVF9j/MXxjvYPRjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgckecmiRgF6njDHzIhMSjGwEXdPHBwjAoZcFj9YRLMIgoCuZDNxYupVvlnH98ZaaNsQwsCwBpR5SH70+OK1BWnkazPRG0KF74ci3Ysy9BGVbqCOSm3Sq9dz0M7HnwA7rlS6Q2zgTy2m4xYen8NmLX8DgBcw7RPrcu5nkF6Za/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj+dr7O8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj+dr7O8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0990C4CEF1;
	Mon, 23 Jun 2025 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685994;
	bh=qWg1gKEXQ1V7UVM24j6v9d+n/nOAVF9j/MXxjvYPRjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sj+dr7O8JxVQkEfmf6hobT2pSlhwjgNWTJrzCU5zTG1WTPcoce3VsocpJELH6ZOzF
	 gtbXNqXXZpqYeIgDXMAEh3FdHK6GNb+SoYrTNokU2pAZvAOJo+CP/Lk1BEU6+hPl08
	 HiOCar8aARVGW+ugYjLSWpH6BXjFyZiEOOKx0rOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 275/592] drm/amdgpu/gfx7: fix CSIB handling
Date: Mon, 23 Jun 2025 15:03:53 +0200
Message-ID: <20250623130706.876511593@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit be7652c23d833d1ab2c67b16e173b1a4e69d1ae6 ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
index 8181bd0e4f189..0deeee542623a 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
@@ -3906,8 +3906,6 @@ static void gfx_v7_0_get_csb_buffer(struct amdgpu_device *adev,
 				buffer[count++] = cpu_to_le32(ext->reg_index - PACKET3_SET_CONTEXT_REG_START);
 				for (i = 0; i < ext->reg_count; i++)
 					buffer[count++] = cpu_to_le32(ext->extent[i]);
-			} else {
-				return;
 			}
 		}
 	}
-- 
2.39.5



