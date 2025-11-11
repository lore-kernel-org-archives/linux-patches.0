Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9BF248F6A;
	Tue, 11 Nov 2025 01:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823106; cv=none; b=FvnRtqoOq2SkNCcAN+kFifNMwbb/gBYv2RncZOCT1NgPnCihYvoQOvVpfZMJFs6ZYlyl81MqYzmI2CrR1vaGHjWgCRlSUSYV+Lks3TtMavNBDRP4wTriUblbFU9sMgj+kMP3bgS7DBzH9K3P2D0zhZtHhkR54HBpl/EGGYtsHY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823106; c=relaxed/simple;
	bh=PBSYkpkFvPYgKoXrizRIk/5BtJoCm5ebFn6H2nCTIEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiE1smf80g0Nw0m7/6oULg4dzqKcPQehDzlw2D4izHF+Q7oLoXAcBHf/m7Dls+b7SI7PRV2jLHCwJJQKTE7QFKqvmE2xmgSCFYp1+CxMYDlgyHB0/lybZH2m4K/m39OuJv00Ws0JreDOX44cESlzeUoiJy5Yk/mWMhG5Hm1y3ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SyTuilIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SyTuilIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCAAC4CEFB;
	Tue, 11 Nov 2025 01:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823105;
	bh=PBSYkpkFvPYgKoXrizRIk/5BtJoCm5ebFn6H2nCTIEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyTuilITZ26XSA+GQO51IYlfvMLk3uQjE05pi13SCftsldJvlmKOmWVVJoYCXtnlz
	 KLTJHJd7/+4v26/wuvIssdQdVWFfabqKEf8c5DKRpUWaYE849X2NwpVMSyfG0+Obju
	 9aYKT0CAQMLy63c9kpmKMHImw8f1jbkMPiCUQZeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 232/849] drm/amd/display: fix condition for setting timing_adjust_pending
Date: Tue, 11 Nov 2025 09:36:42 +0900
Message-ID: <20251111004542.052018241@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 1a6a3374ecb9899ccf0d209b5783a796bdba8cec ]

timing_adjust_pending is used to defer certain programming sequences
when OTG timing is about to be changed, like with VRR. Insufficient
checking for timing change in this case caused a regression which
reduces PSR Replay residency.

Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Robin Chen <robin.chen@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index dcc48b5238e53..bb189f6773397 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -459,7 +459,9 @@ bool dc_stream_adjust_vmin_vmax(struct dc *dc,
 	 * avoid conflicting with firmware updates.
 	 */
 	if (dc->ctx->dce_version > DCE_VERSION_MAX) {
-		if (dc->optimized_required || dc->wm_optimized_required) {
+		if ((dc->optimized_required || dc->wm_optimized_required) &&
+			(stream->adjust.v_total_max != adjust->v_total_max ||
+			stream->adjust.v_total_min != adjust->v_total_min)) {
 			stream->adjust.timing_adjust_pending = true;
 			return false;
 		}
-- 
2.51.0



