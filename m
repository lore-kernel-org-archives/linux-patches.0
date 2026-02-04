Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F53423A6D;
	Wed,  4 Feb 2026 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218609; cv=none; b=L+P41YI2tTrbQqIDaj90xs73fiVj6SfmEfA7eTCVnV1NStCHEV6MwP0LRNTvYV4GqWWjHWcT4f1yA7LsRrBLmXt8VTlraozWZrvTRG7bquz7a2zga0ZWK/mm8kj/DAdaxL5rilxkr+7O6+KFgLOMCXIJqm4b96QdtnsiY19C68A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218609; c=relaxed/simple;
	bh=mYcoy+Uy3Ae5YrT6HoEzyYQOVhmTMA5QgrBUqjljtl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wp7SoKAJWgJfrizu0JlKM2MoWWl4Pegx8aRXK9vtTNmMDubyRPIiAzXTOHKPe4fUjEjDktE951ovk47jpiXbmxY/qaEPb++8lsimL+7p8eYRCqD/NOHSUjQ3E/z4bcHzuUyqkgtB7PEd7nVuhFPjfDTRP0WNhstmnn5ocNnvIho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3xZUebA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3xZUebA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E0DC4CEF7;
	Wed,  4 Feb 2026 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218609;
	bh=mYcoy+Uy3Ae5YrT6HoEzyYQOVhmTMA5QgrBUqjljtl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3xZUebAb53+1LgqIrHEmJTr/7MaKTUoZ8jL5KZGDdJpUQwdiBmsiyRYZpreFD/6w
	 jIiZYgA1Ly+m3jhUB9r6Ucy2TTq0XMt3y7/DUd/Kzib3O8jmSAAVPB6R2qFcSvAWrE
	 Ws8gN6gvsHwtVoGQR6QKkepi8mK7eMKRtixDlM5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 40/72] drm/amdgpu/gfx10: fix wptr reset in KGQ init
Date: Wed,  4 Feb 2026 15:40:43 +0100
Message-ID: <20260204143847.079141795@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cc4f433b14e05eaa4a98fd677b836e9229422387 upstream.

wptr is a 64 bit value and we need to update the
full value, not just 32 bits. Align with what we
already do for KCQs.

Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e80b1d1aa1073230b6c25a1a72e88f37e425ccda)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -6459,7 +6459,7 @@ static int gfx_v10_0_gfx_init_queue(stru
 			memcpy_toio(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset the ring */
 		ring->wptr = 0;
-		*ring->wptr_cpu_addr = 0;
+		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
 		amdgpu_ring_clear_ring(ring);
 	}
 


