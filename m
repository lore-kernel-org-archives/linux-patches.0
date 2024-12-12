Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805622054F8;
	Thu, 12 Dec 2024 15:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017017; cv=none; b=V1VLt1lapKtGurKYvCTJwtUTUWSuTuJ/Z/AbYIa8uX3nA33oPrO5BDc9hz/6/RK0NSLTdqytg+GTYcoV+3mIsO/XW2Ga5VBucyC4E8B1hTNt7UcF9roX/H+77aikxaI1HEHw+KYU63IE9VLag5ZuQhQcRQoh6YWSpA9G6AXYBjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017017; c=relaxed/simple;
	bh=onKu6VwAEoqzz26bnCheuqeo8pQvGqPy/ZuQQYPSu3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LShyJYATeBx7DAJDODJKds1qas6Rl2b3s37gyu8xvPrwH2S7Oe3QTdRMICphFER8q/N6chCvIU+IRc7ejkc12FeR0zBvdqZfddFGX2oF1uXZz/ovfXc+nVToUNTITRB56XFoElsfBzUC4ejzHgiK7e9USOW5uraay3u1vnpu3UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGAAZK/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGAAZK/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFBAC4CECE;
	Thu, 12 Dec 2024 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017017;
	bh=onKu6VwAEoqzz26bnCheuqeo8pQvGqPy/ZuQQYPSu3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGAAZK/BNWjZ0G2uFwiO9POCHJIrTTOBStC5j4YVcrABkHs+yvCTuIaJrXhjlDIJ+
	 +nS5oAraMT+tZrc/ZSLiminIQDSIQptCLiaTfDcB3JeDTqI6WmLhtsPot6fa9xzhi2
	 l1uV39/v2HiJ3DjOXAq5Pgbb5kLy+RLixB6ro95I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/466] drm/amd/display: parse umc_info or vram_info based on ASIC
Date: Thu, 12 Dec 2024 15:58:16 +0100
Message-ID: <20241212144319.707275577@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 2551b4a321a68134360b860113dd460133e856e5 ]

An upstream bug report suggests that there are production dGPUs that are
older than DCN401 but still have a umc_info in VBIOS tables with the
same version as expected for a DCN401 product. Hence, reading this
tables should be guarded with a version check.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3678
Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index c9a6de110b742..902491669cbc7 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -3127,7 +3127,9 @@ static enum bp_result bios_parser_get_vram_info(
 	struct atom_data_revision revision;
 
 	// vram info moved to umc_info for DCN4x
-	if (info && DATA_TABLES(umc_info)) {
+	if (dcb->ctx->dce_version >= DCN_VERSION_4_01 &&
+		dcb->ctx->dce_version < DCN_VERSION_MAX &&
+		info && DATA_TABLES(umc_info)) {
 		header = GET_IMAGE(struct atom_common_table_header,
 					DATA_TABLES(umc_info));
 
-- 
2.43.0



