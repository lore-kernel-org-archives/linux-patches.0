Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9367C580394;
	Wed,  9 Sep 2026 14:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963242; cv=none; b=XQ3PY+aQPJXk9HBwSoZjROsWfmaBLMRqrQA6Sg0q0lfyo/gtKMCZ16q58LqfB3F13dsUrxTCLm2+tdKd3VJcQqkY/QOxsjxdX5Rj2NxWdQE5Pv1Ujwe8CEh5erit/gHyi1sYnX43VzhWkIDUrTdJK8wwwPEkD4aTe1em3UPq2p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963242; c=relaxed/simple;
	bh=UwPdZds5jkXAmkuySswx98xDQExDR3Uo8ecydy4+3iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCBmjeF8bYXftKqt+tyj/oe+C3YojQzzG8GcDfLlZyEdx3ui2za5XRiIzHItgFkJkGd+pRNGVI02g0eOlzf3YGj9YHULlfYoWF0unbld2Nv45QWUcuHmUergLJEOQ+ZzjdJBQn/kD9/c03trsiC5eqLQtOPo7kblGyxC8U7J87E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sq2ShG7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sq2ShG7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA84D1F00A3D;
	Wed,  9 Sep 2026 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963241;
	bh=lOgWfaxSZaXXPtvlC0nO/96piRx6n3c+N8ro98Mb2sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sq2ShG7jsPeCudSyBkW6/fz9CO1Rpr5R+F+nHFUA50Zd8vstq1xoDWLOkjv+NDBeW
	 26hvJZNocoAAKvxe4cZyfC3SPjEgcxg0G7NRyuIhiXhDa+Nqklc/icnMB1EKZPVA5K
	 VmvdZPw5rIZKgHljL6mYl956VaIxXNNbjMZi9SKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 012/583] drm/amd/display: fix division by zero in get_estimated_bw()
Date: Wed,  9 Sep 2026 15:34:57 +0200
Message-ID: <20260909134238.224186505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


