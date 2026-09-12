Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC9935201F;
	Sat, 12 Sep 2026 11:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212919; cv=none; b=Uc3gsK3tf3P3+SLDt0FTXLo3hQAmxxHQK3kY4o3orRqh5bHo4Diq2o7iURiy8r61siYeZcxEunRk+CG/d3DHjYQgvF7UGKNMqA5YkAvy4i2n8Out5GF9A0GY7hTMZZmIfszRopBHu72CUphmZWasK1iGPs5os2C0+dona1+GIpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212919; c=relaxed/simple;
	bh=mGDV5pHUAxchPlDMMBYCpmpTnVVItt7quW0o/BbT3f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8/+cSfeg76FmHqACF4DaVc5pcF0+tMxKeWmgMs8slNhXgEwEcXTqIB0Az7RhrxJAS2awywmEclKM10HH+CKlvLSVJLPmIJ30DtimGIvM6pXaR+6+siKx8RPVUCj1YmlL8HdASOq3mmGjkF/6cHKtcsVh+yldzk6LFu8ETr19m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlSawo6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlSawo6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F271F00893;
	Sat, 12 Sep 2026 11:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212916;
	bh=IWOAYCnHXC1KATVWPkkOf6msB3SQPuKLowwY0OMxzsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlSawo6kHoGMI7BLXEF3FE0tnJ220qPtI8KzgJjItcaLFErIWaj3CY1ZVTO75Z31b
	 lWs+OrW3dyS3xxf9vnDWu2M9rcKIqu+9cExgEpgdcqKvkEtOC8US3bdD6K0r9X6GX9
	 E10i8Bu5EtxxBWdRJQ25ch6HJqnEYEiZYOmuFDHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 0016/1376] drm/amd/display: fix division by zero in get_estimated_bw()
Date: Sat, 12 Sep 2026 08:40:42 +0200
Message-ID: <20260912065607.911642002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Mishal <harimishal1@gmail.com>

commit f63de9054da858d57054474c32464106f8375e0d upstream.

get_estimated_bw() divides by link->dpia_bw_alloc_config.bw_granularity,
which is zeroed by reset_bw_alloc_struct() and only populated once
DP_TUNNELING_BW_ALLOC_CAP_CHANGED has been handled.

link_dp_dpia_handle_bw_alloc_status(), the DPCD interrupt handler,
calls get_estimated_bw() whenever DP_TUNNELING_ESTIMATED_BW_CHANGED
is set, independently of whether DP_TUNNELING_BW_ALLOC_CAP_CHANGED
has ever fired for that link. A connected USB4/DPIA tunneling device
that reports an estimated-bandwidth change before ever reporting a
capability change drives a division by zero in this IRQ path.

link_dpia_send_bw_alloc_request() already guards the same
bw_granularity division; add the identical guard here rather than
introducing a new pattern.

Fixes: 8e5cfe547bf3 ("drm/amd/display: upstream link_dp_dpia_bw.c")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Assisted-by: gkh_clanker_t1000
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f2a961457c33dc34223aad5c9e8971de34a4eed3)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
@@ -102,6 +102,11 @@ static int get_estimated_bw(struct dc_li
 {
 	uint8_t bw_estimated_bw = 0;
 
+	if (link->dpia_bw_alloc_config.bw_granularity == 0) {
+		DC_LOG_ERROR("%s: BW granularity is zero!\n", __func__);
+		return 0;
+	}
+
 	core_link_read_dpcd(
 			link,
 			ESTIMATED_BW,


