Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814BB15FCFC;
	Mon, 27 May 2024 19:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837658; cv=none; b=nPlX0fWrD6xYmIugU72QSOcme9jcTGHAUnkegONJh6fMQ25nmJ8tEzP9q3oitETkHpEDbPNPkS1sYXipU/ZyzFrJOTW1TjSR+XocixI7gR8KPmcjCGvVU54SrsgRSEKLMUnPAObIvjudvhN68CLEwueoiesO2OY/nHmEeMErl18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837658; c=relaxed/simple;
	bh=9YO7JulpMClPAgXOCsrl8UH1KlaBYbjqZx9d22j2S48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erVTo9K0tQI2E8NtoUw0wE6mBf9EXJQdMDs5bcMQKYo/7cmKn226vA23+dF1rkgZ28z/28gKHe/gwu6e1dckE53OK1QE5S7OjZmMRj0HrB/A9ClXCU5D1B1GNz6b+QgcpueiCvyjnTp6WKpmzHKrTXdlEylKwtdIkJglpXNfkB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcBOppe8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcBOppe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1925AC2BBFC;
	Mon, 27 May 2024 19:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837658;
	bh=9YO7JulpMClPAgXOCsrl8UH1KlaBYbjqZx9d22j2S48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcBOppe8KtGK8/c/k3tmoBTcNxRmajtL/uebvaEKy8Rdz1KVJaIEzIJ3xnsXrEECO
	 NDFiQYJFgDl3JopY0BsNRXdzGThD35N18m010/NhKcUDzk+qQ2Y+WkoeTwgojY3YeX
	 0tsCu4YnY6z6WmAwT8ADy0/bwG/sOktv1cfdXK9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	PeiChen Huang <peichen.huang@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 095/493] drm/amd/display: Allocate zero bw after bw alloc enable
Date: Mon, 27 May 2024 20:51:37 +0200
Message-ID: <20240527185633.530715031@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>

[ Upstream commit 46fe9cb1a9e62f4e6229f48ae303ef8e6c1fdc64 ]

[Why]
During DP tunnel creation, CM preallocates BW and reduces
estimated BW of other DPIA. CM release preallocation only
when allocation is complete. Display mode validation logic
validates timings based on bw available per host router.
In multi display setup, this causes bw allocation failure
when allocation greater than estimated bw.

[How]
Do zero alloc to make the CM to release preallocation and
update estimated BW correctly for all DPIAs per host router.

Reviewed-by: PeiChen Huang <peichen.huang@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/link/protocols/link_dp_dpia_bw.c    | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
index 5491b707cec88..5a965c26bf209 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
@@ -270,7 +270,7 @@ static void set_usb4_req_bw_req(struct dc_link *link, int req_bw)
 
 	/* Error check whether requested and allocated are equal */
 	req_bw = requested_bw * (Kbps_TO_Gbps / link->dpia_bw_alloc_config.bw_granularity);
-	if (req_bw == link->dpia_bw_alloc_config.allocated_bw) {
+	if (req_bw && (req_bw == link->dpia_bw_alloc_config.allocated_bw)) {
 		DC_LOG_ERROR("%s: Request bw equals to allocated bw for link(%d)\n",
 			__func__, link->link_index);
 	}
@@ -341,6 +341,14 @@ bool link_dp_dpia_set_dptx_usb4_bw_alloc_support(struct dc_link *link)
 			ret = true;
 			init_usb4_bw_struct(link);
 			link->dpia_bw_alloc_config.bw_alloc_enabled = true;
+
+			/*
+			 * During DP tunnel creation, CM preallocates BW and reduces estimated BW of other
+			 * DPIA. CM release preallocation only when allocation is complete. Do zero alloc
+			 * to make the CM to release preallocation and update estimated BW correctly for
+			 * all DPIAs per host router
+			 */
+			link_dp_dpia_allocate_usb4_bandwidth_for_stream(link, 0);
 		}
 	}
 
-- 
2.43.0



