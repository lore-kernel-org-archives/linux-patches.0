Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A6B274B29;
	Tue, 21 Oct 2025 20:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077291; cv=none; b=dVhJD3Ii3+urLQAbvyYOPR/xG4EEjYQ3oQJtOR8LK5M7sWcVeFNKkc24wLj4bO/cAlqT5iKBmeCZMBVHwWlXN+SlQFQ4fmC2vlNmLAMRzXOUCAqtcPWsfy+hcu7CvBWcwUFiyOjHx2NSWHrYQBxkr3NQWCgHXCFk6FyyJ9BYHFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077291; c=relaxed/simple;
	bh=FrTyMk6yXfQJHwRBrmXu8ta+PqkSxX0uSqg1Xp3WQ0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oezN/fEs9fvKQ+lMTe49KHXF9pXaSuDI6ahJqLhUY9x77e0yhGoH7OrwaRHiwVLDaZs/nmEy7hO6GLLsuTp3k5b9CHxjJnLaLNrcaWCNi2AwQGW9N4r8c40o9YnFyyJ85p8tpkRh6RdZzeriBXPtnPrlVHsSy4QA2IvagMbsMuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3pq+/vR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3pq+/vR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB182C4CEF1;
	Tue, 21 Oct 2025 20:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077291;
	bh=FrTyMk6yXfQJHwRBrmXu8ta+PqkSxX0uSqg1Xp3WQ0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3pq+/vR+axRMaTzqnVnB554mIVrByHCCjnT9NLz7KllabgKPMRc7mvOTkr2H1cmb
	 2DTiGAZOiWIwuLxv6LP+USjXwUKaMrrfwcU1f5phG9fbXyvKg3elg6tNGrgMXmdF/8
	 vuxuOotiD7kUSRjirAlIuB8h0A05W5UM+DcLtyB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 042/159] drm/amdgpu: fix gfx12 mes packet status return check
Date: Tue, 21 Oct 2025 21:50:19 +0200
Message-ID: <20251021195044.215711106@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Jonathan Kim <jonathan.kim@amd.com>

commit d0de79f66a80eeb849033fae34bd07a69ce72235 upstream.

GFX12 MES uses low 32 bits of status return for success (1 or 0)
and high bits for debug information if low bits are 0.

GFX11 MES doesn't do this so checking full 64-bit status return
for 1 or 0 is still valid.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -225,7 +225,12 @@ static int mes_v12_0_submit_pkt_and_poll
 			pipe, x_pkt->header.opcode);
 
 	r = amdgpu_fence_wait_polling(ring, seq, timeout);
-	if (r < 1 || !*status_ptr) {
+
+	/*
+	 * status_ptr[31:0] == 0 (fail) or status_ptr[63:0] == 1 (success).
+	 * If status_ptr[31:0] == 0 then status_ptr[63:32] will have debug error information.
+	 */
+	if (r < 1 || !(lower_32_bits(*status_ptr))) {
 
 		if (misc_op_str)
 			dev_err(adev->dev, "MES(%d) failed to respond to msg=%s (%s)\n",


