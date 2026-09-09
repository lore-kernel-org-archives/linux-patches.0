Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C88E423A85;
	Wed,  9 Sep 2026 13:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961659; cv=none; b=S5O3UAAhl3/TW7f+FhLc7xf8PvyIwUpau8BMhnIrhqj5vQJ0EXzxnIipN6DyFJ7V9H2SPmhYd9l5ES/at3PkeqB2GF6ZcSAEcHMjQdzWymSw5754IUy+pSu4v0JI3S+41ALAQSH7qDevy5Em89AJ0nuk/SgZngQwuFernG9sbEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961659; c=relaxed/simple;
	bh=Sl2mP1vUuKfWWYHDLPjHt5Pzom5+ldTxVafEbSSnWqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZBWZWVOph107W2wPKbMXcFykOtSzrQw78qIQe/fKxRmO04WIi/Uq2C+o7KHgXVCG77Vlu2fnkEf1yBWGP/hfPpzNsAkyfcfvJpSKvylI0SfeYlVYRXaAZN1JiV6dOcGC3lP+o0MkP7nXnqQGYPGxHavGlTI1vMbDAjNZjoep5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPTsxz51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPTsxz51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B1E1F00A3D;
	Wed,  9 Sep 2026 13:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961658;
	bh=lHUc4XFVs6fIPV3nb4XDGVnFsEq+SDg1IeJtynYk7Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPTsxz51qreTDXSYIc0Fk3giq3gjOSKK/P8SOIQ91Vgs/FoxawkcLEFcUA+ZYXRDb
	 SI6RQ+KNNiAqnl9JiohLVdx4ZG76Hrr7Hd2gUoEj2U7dbcp9OrAj3w6G7AB8L83a14
	 kxegpCdQdMG7WbeOOYGF/pubfK8N4lBQeLZyS3S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 024/556] drm/amd/display: fix division by zero in get_estimated_bw()
Date: Wed,  9 Sep 2026 15:35:04 +0200
Message-ID: <20260909134231.349321694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -103,6 +103,11 @@ static int get_estimated_bw(struct dc_li
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


