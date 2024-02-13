Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DAC5F54E;
	Tue, 13 Feb 2024 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845538; cv=none; b=sBpowhx+4JPyCip/EhL8PqclmDBNgCvAldK0xJ84BMZO+niz5xgKRC4TfPmOX5Dloh8IH7/Va298yH7D1nMdwIqqlotHY9rB3L/oOmrxkv0MvzV1XzaAzrhuDU9ot/5czwZbjkAPfhoeojJgqV30DsSEcdgWyZSvKE/8Sclo2Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845538; c=relaxed/simple;
	bh=dkgOXRbZUfExhfUgglUxT9AazFGIq/9nJ0KyJG47DTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYXtSxiZoaKBdu089t7j1J88I2+DUGaL8af8jk9ZhZ3rrj8rRIt2/iu3G/uqaKx0jG/6I8MkE+U6mIfu0lGJxtlcESMGH+NL2ysqN87jRrDl4ruG67cNB23RanohmQ3zxEoPNGwFSaZjwMXg0+Tvuc3gjIJR8rY76enr2l6qCIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6O8Xo0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6O8Xo0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07093C433C7;
	Tue, 13 Feb 2024 17:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845538;
	bh=dkgOXRbZUfExhfUgglUxT9AazFGIq/9nJ0KyJG47DTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6O8Xo0nIDadvKL9jF+xXC8FKa6bECSRPkkS2cgvYLn7ddSscHkhGMlNutqgdnVi2
	 oQ5U/xqvxHJft4H8vTJkWAAT8ngCPWhwftKWziVaYyziEdzsiBFFSDJLoq5CCDTfyb
	 LkUR8QEejXU53schVB9OWnpe5FTLwcjNNcVl2I+E=
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
Subject: [PATCH 6.6 079/121] drm/amd/display: Implement bounds check for stream encoder creation in DCN301
Date: Tue, 13 Feb 2024 18:21:28 +0100
Message-ID: <20240213171855.297236070@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 79d6697d13b6..9485fda890cd 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -996,7 +996,7 @@ static struct stream_encoder *dcn301_stream_encoder_create(enum engine_id eng_id
 	vpg = dcn301_vpg_create(ctx, vpg_inst);
 	afmt = dcn301_afmt_create(ctx, afmt_inst);
 
-	if (!enc1 || !vpg || !afmt) {
+	if (!enc1 || !vpg || !afmt || eng_id >= ARRAY_SIZE(stream_enc_regs)) {
 		kfree(enc1);
 		kfree(vpg);
 		kfree(afmt);
-- 
2.43.0



