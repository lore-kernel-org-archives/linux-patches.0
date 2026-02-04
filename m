Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5DB22332E;
	Wed,  4 Feb 2026 15:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219239; cv=none; b=h8XQQhJIVKsmvsnDbCAwveuOHimFe9zI0uvS2tF6ESS7NHS+CGbbIVTOICU7uvXiokyFe8igrnneV/cJCsKyVsdt74ZrUDcU3PIuW4DMnVUdKSd3iiVeL4QZYN6/G6RP1bwZXQ4tSnLqBvfOeoLcabWF8ZQ+tDWSXTzwzgMMQVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219239; c=relaxed/simple;
	bh=psr/iY23d8o8WRp8ny9A3xIDdldDfBl8cTqD/gXeoG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q9aipBAAB3ks46Xko5zCMhi84Q2QaphQJfTb9kWlfCH2uXd/HItgtIifUF1YhvfRe7g//cOWO9+56/2heHvT7gMRzIAc1SelQESdtttfCMoEJbvFB2RQkKK+HeZDG5WUMwAlctJNu8n+KEQILsctIRufdVJu1viE8rtl+T5Jlc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FA82HK5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FA82HK5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B788C4CEF7;
	Wed,  4 Feb 2026 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219239;
	bh=psr/iY23d8o8WRp8ny9A3xIDdldDfBl8cTqD/gXeoG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FA82HK5vZjqbwEOHnDNoJLr/DXXL+nIUyecjE1JTHjqbZ1GBBxkEZpNJ024RGM6q2
	 BIXDou+5kWfHZs3xya1hspA/tjGROF4mjR86GsujkZ/6A2+y9jsUC2nN9Myufa37KR
	 UCkKnRPME0nJ78d4bpxPo2+DEzymX8+gMpel9pXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 109/122] drm/amdgpu/gfx11: fix wptr reset in KGQ init
Date: Wed,  4 Feb 2026 15:41:31 +0100
Message-ID: <20260204143855.774813445@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b1f810471c6a6bd349f7f9f2f2fed96082056d46 upstream.

wptr is a 64 bit value and we need to update the
full value, not just 32 bits. Align with what we
already do for KCQs.

Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1f16866bdb1daed7a80ca79ae2837a9832a74fbc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4199,7 +4199,7 @@ static int gfx_v11_0_kgq_init_queue(stru
 			memcpy_toio(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset the ring */
 		ring->wptr = 0;
-		*ring->wptr_cpu_addr = 0;
+		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
 		amdgpu_ring_clear_ring(ring);
 	}
 


