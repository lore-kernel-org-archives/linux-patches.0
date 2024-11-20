Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2881A9B5A;
	Wed, 20 Nov 2024 12:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107558; cv=none; b=fG2DmSQQ6lU3KSlsNbpGjXNLRLOuvRPlJuLQ5usjloOeCh9JlvesBW3/zKFVZ8K4wHpWIRER/18i9+UKcSzmazCZM0r8DuLhLp1UsL8L7bsPH8cjjqrdmz+vi0CSVLV8ICvcet84Tf2gTUBLD1BMUqvHuQYxS+NTdZV5/txDyg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107558; c=relaxed/simple;
	bh=lcR18F6vJiBpITXuZVzKPpiIaC9mylazjSQHTC1wQ6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwSvV4b5x7fvlgfrGisZm8ZgijqLDbJgE7wOM5xat1W3um0qwZgpDkzCAUbQAI8eMu+VFygh2kDDHGS6piUY1scxQ3mFc2Uxv8iZp9ZfUwQ3gJX66GvyzAgs3D0CkX+MiwMUJB30xEbm0idajqPxGHTOmFSImEndR3GZjvc9pkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq5AN8pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq5AN8pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F756C4CED1;
	Wed, 20 Nov 2024 12:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107558;
	bh=lcR18F6vJiBpITXuZVzKPpiIaC9mylazjSQHTC1wQ6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lq5AN8pq/wRW3KP9xLnqM6Jd11qLYErpOyU3f0wKFmmwFIOUkX0k3xiKczmlXOklS
	 gNrnHF32vkrwaC3kCQk4Z9WlYnVPJ7PpMbXnvX0E+ZwCidWx3zKgbCIvJcNYgqGyoX
	 ZclYM9QX3kIvPZ6mXyCzTBVypOv+hMo9RlNk+QYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Ryan Seto <ryanseto@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 100/107] drm/amd/display: Handle dml allocation failure to avoid crash
Date: Wed, 20 Nov 2024 13:57:15 +0100
Message-ID: <20241120125631.986328080@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Seto <ryanseto@amd.com>

commit 6825cb07b79ffeb1d90ffaa7a1227462cdca34ae upstream.

[Why]
In the case where a dml allocation fails for any reason, the
current state's dml contexts would no longer be valid. Then
subsequent calls dc_state_copy_internal would shallow copy
invalid memory and if the new state was released, a double
free would occur.

[How]
Reset dml pointers in new_state to NULL and avoid invalid
pointer

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Ryan Seto <ryanseto@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bcafdc61529a48f6f06355d78eb41b3aeda5296c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_state.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_state.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_state.c
@@ -265,6 +265,9 @@ struct dc_state *dc_state_create_copy(st
 	dc_state_copy_internal(new_state, src_state);
 
 #ifdef CONFIG_DRM_AMD_DC_FP
+	new_state->bw_ctx.dml2 = NULL;
+	new_state->bw_ctx.dml2_dc_power_source = NULL;
+
 	if (src_state->bw_ctx.dml2 &&
 			!dml2_create_copy(&new_state->bw_ctx.dml2, src_state->bw_ctx.dml2)) {
 		dc_state_release(new_state);


