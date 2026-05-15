Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC2F3F6C49;
	Fri, 15 May 2026 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861582; cv=none; b=aS+f7MNl0dwenaBg73z9k+X0AXeDNuIRQoy6Rpt8Wt35qdAomf5WPbBZAN0gf2EdK4RT9kh15dWVDgBCT6xbH9nDYRe9j/tfSLQSdQW3Qpdh8uxdesMenXCskQQJ6rX0/SVcF3qomODAs0vvjPqL3KiSadr5e/lIKnNyDUb4UX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861582; c=relaxed/simple;
	bh=C9NIVVe5fJqAuA733+3pwvee/9qwZq0rlOa4QgJeAng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lZsgMbkhrXA1FYjo0DjTO1E+bVX7sjmbGHfBDVoGHfWTvo3OuNRC7adQrJzTK7wXhzpp+UG4s3f41yUQ24auhpG9oOtnZLhLpZMOvyzCl5u8wiyP3L0iCkvzzCNJkkf7rAyLJenVb7OZ25bbW0o7UMrZfXK7MV8Qr2kNQ3WuODk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRa95pDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRa95pDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB287C2BCB0;
	Fri, 15 May 2026 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861582;
	bh=C9NIVVe5fJqAuA733+3pwvee/9qwZq0rlOa4QgJeAng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRa95pDYo6DbgT0oXuBxDGNnDhorlhTW0yHApSuOsrtoJlhwnbVqkQKzgXtpiGPrB
	 y1/be9+7CWfVDCgDsOP0SqnfO1HdP8lOgpgUVJt5/5IKsLTzDZhFYYSwK3z8vQFc5R
	 vK8Yc+aptCLGCRd06/1C2v+AzvBmhPg4Lod21VEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 343/474] drm/amdgpu/vcn4: Prevent OOB reads when parsing IB
Date: Fri, 15 May 2026 17:47:32 +0200
Message-ID: <20260515154722.437177186@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit 2444eb0ec8283f4a3845eb7febad378476e1ba3c upstream.

Rewrite the IB parsing to use amdgpu_ib_get_value() which handles the
bounds checks.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1755,9 +1755,10 @@ out:
 static int vcn_v4_0_enc_find_ib_param(struct amdgpu_ib *ib, uint32_t id, int start)
 {
 	int i;
+	uint32_t len;
 
-	for (i = start; i < ib->length_dw && ib->ptr[i] >= 8; i += ib->ptr[i] / 4) {
-		if (ib->ptr[i + 1] == id)
+	for (i = start; (len = amdgpu_ib_get_value(ib, i)) >= 8; i += len / 4) {
+		if (amdgpu_ib_get_value(ib, i + 1) == id)
 			return i;
 	}
 	return -1;
@@ -1768,8 +1769,6 @@ static int vcn_v4_0_ring_patch_cs_in_pla
 					   struct amdgpu_ib *ib)
 {
 	struct amdgpu_ring *ring = amdgpu_job_ring(job);
-	struct amdgpu_vcn_decode_buffer *decode_buffer;
-	uint64_t addr;
 	uint32_t val;
 	int idx = 0, sidx;
 
@@ -1780,20 +1779,22 @@ static int vcn_v4_0_ring_patch_cs_in_pla
 	while ((idx = vcn_v4_0_enc_find_ib_param(ib, RADEON_VCN_ENGINE_INFO, idx)) >= 0) {
 		val = amdgpu_ib_get_value(ib, idx + 2); /* RADEON_VCN_ENGINE_TYPE */
 		if (val == RADEON_VCN_ENGINE_TYPE_DECODE) {
-			decode_buffer = (struct amdgpu_vcn_decode_buffer *)&ib->ptr[idx + 6];
+			uint32_t valid_buf_flag = amdgpu_ib_get_value(ib, idx + 6);
+			uint64_t msg_buffer_addr;
 
-			if (!(decode_buffer->valid_buf_flag & 0x1))
+			if (!(valid_buf_flag & 0x1))
 				return 0;
 
-			addr = ((u64)decode_buffer->msg_buffer_address_hi) << 32 |
-				decode_buffer->msg_buffer_address_lo;
-			return vcn_v4_0_dec_msg(p, job, addr);
+			msg_buffer_addr = ((u64)amdgpu_ib_get_value(ib, idx + 7)) << 32 |
+				amdgpu_ib_get_value(ib, idx + 8);
+			return vcn_v4_0_dec_msg(p, job, msg_buffer_addr);
 		} else if (val == RADEON_VCN_ENGINE_TYPE_ENCODE) {
 			sidx = vcn_v4_0_enc_find_ib_param(ib, RENCODE_IB_PARAM_SESSION_INIT, idx);
-			if (sidx >= 0 && ib->ptr[sidx + 2] == RENCODE_ENCODE_STANDARD_AV1)
+			if (sidx >= 0 &&
+			    amdgpu_ib_get_value(ib, sidx + 2) == RENCODE_ENCODE_STANDARD_AV1)
 				return vcn_v4_0_limit_sched(p, job);
 		}
-		idx += ib->ptr[idx] / 4;
+		idx += amdgpu_ib_get_value(ib, idx) / 4;
 	}
 	return 0;
 }


