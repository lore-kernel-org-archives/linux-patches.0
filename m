Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FC01E4B2;
	Wed, 21 Feb 2024 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523036; cv=none; b=Szinq7nkIec8Lkl/FKd/aDvU/NcBKrrj+rWUZzmQ/fknKN6wtJ65ZN24oQSqf7Ctro78yXEKi8YgoTBvVn9EV2fgRpaWzsjCvs8siwvkitNHe64oY5HP6tXknQc2ncpIbDyMMUC4NuYi/dLAIW+BLPaBWDIPcVJsaNvtV+CR3mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523036; c=relaxed/simple;
	bh=DoYrstMneQxsRzIItpXslW2mAGarsUMY0YNRWZaK+34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5eQUUgkhs91dQi0M8KJHok20mDZOE42XbpFQZfGpF4qP2DD2+/9cTnAMHPigRbzcfUNQt7DLh4WlpjILqyZ7efZNUk3oSPd21jTTPZkfDwl9xf/sRyuh2LBbUwbWArwATO5N/xluYdc2UXCuNmnwDF6Xkuvl+2CtB3e3YHVh9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcIyby3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcIyby3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B37C433C7;
	Wed, 21 Feb 2024 13:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523035;
	bh=DoYrstMneQxsRzIItpXslW2mAGarsUMY0YNRWZaK+34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcIyby3XkdRMT69RDohHhVrOnUqWYGC7OKzRod9FRl8ky55RcA2QB+d1byMy3Ap4D
	 5PC3xybDRjdlmxfSb4dfAjkYn111jihX3kNFXfqqgdsxQIDBKnQSNMlO7d5yTKQ+VT
	 MH+jYYZncHoi8fbEGNMTrQ0I9VRQ3xoR2l/51cJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <Roman.Li@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 321/476] drm/amd/display: Implement bounds check for stream encoder creation in DCN301
Date: Wed, 21 Feb 2024 14:06:12 +0100
Message-ID: <20240221130019.878627648@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 58fca355ad37dcb5f785d9095db5f748b79c5dc2 ]

'stream_enc_regs' array is an array of dcn10_stream_enc_registers
structures. The array is initialized with four elements, corresponding
to the four calls to stream_enc_regs() in the array initializer. This
means that valid indices for this array are 0, 1, 2, and 3.

The error message 'stream_enc_regs' 4 <= 5 below, is indicating that
there is an attempt to access this array with an index of 5, which is
out of bounds. This could lead to undefined behavior

Here, eng_id is used as an index to access the stream_enc_regs array. If
eng_id is 5, this would result in an out-of-bounds access on the
stream_enc_regs array.

Thus fixing Buffer overflow error in dcn301_stream_encoder_create
reported by Smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/resource/dcn301/dcn301_resource.c:1011 dcn301_stream_encoder_create() error: buffer overflow 'stream_enc_regs' 4 <= 5

Fixes: 3a83e4e64bb1 ("drm/amd/display: Add dcn3.01 support to DC (v2)")
Cc: Roman Li <Roman.Li@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index b6c363b462a7..a24f1c215da9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -1195,7 +1195,7 @@ struct stream_encoder *dcn301_stream_encoder_create(
 	vpg = dcn301_vpg_create(ctx, vpg_inst);
 	afmt = dcn301_afmt_create(ctx, afmt_inst);
 
-	if (!enc1 || !vpg || !afmt) {
+	if (!enc1 || !vpg || !afmt || eng_id >= ARRAY_SIZE(stream_enc_regs)) {
 		kfree(enc1);
 		kfree(vpg);
 		kfree(afmt);
-- 
2.43.0



