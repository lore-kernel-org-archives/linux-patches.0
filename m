Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3496331326C;
	Tue, 31 Mar 2026 17:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976916; cv=none; b=kleKaSyNegFuNriSEDEpoDnxG7E7gwocoj46Z16n/Fti6VOPppARz/mRLWZTVrFO9mti+gMkPkgD98eymOEoFcMma3TiyD+loB7lKK7ppceMguJjKkumkNMRMoqpKh+CxQrM5a1vU2teORcXiFIbzqO9OjMGmU9MXYfzCdtVHWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976916; c=relaxed/simple;
	bh=AN7gpwBfqGFBqXc+BMm8YeTLQqPrVrOGjQpyhU82QzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1Czs72jy5e0mplzBjVT75WpHgjKZW3gUPvA4gHrL/h1qqKYbi4zI3skkOB3uu6X1Z9DHKBr+sy5hPiCTfv5WMBPnvo+0vCiuWUm6Wdnm45emZZ3DYkVUgxEzyvXI2dN0u5zAsH3gCVo8n+nw9qBdKsbAw4KnKm/fSJ90T9pqIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jk6RVRlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jk6RVRlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77B8C19423;
	Tue, 31 Mar 2026 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976916;
	bh=AN7gpwBfqGFBqXc+BMm8YeTLQqPrVrOGjQpyhU82QzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jk6RVRlpqIlKL8P6XH2WidVUDgHE8puf0bgIIA0YReGMWwmFC7kn2gaQ+fNBporXw
	 yAMOWU5T4UpzAWZReBjWm5qgfBEocVsUAIE5EW9fXB15cMvX9dY43BZJ6sLrkAAPm+
	 4hThbGukDfTCftShVJSkkg7uaFox8bn2DcMh4sDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Chuanyu Tseng <chuanyu.tseng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 234/309] drm/amd/display: Fix drm_edid leak in amdgpu_dm
Date: Tue, 31 Mar 2026 18:22:17 +0200
Message-ID: <20260331161802.191907761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

commit 37c2caa167b0b8aca4f74c32404c5288b876a2a3 upstream.

[WHAT]
When a sink is connected, aconnector->drm_edid was overwritten without
freeing the previous allocation, causing a memory leak on resume.

[HOW]
Free the previous drm_edid before updating it.

Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Chuanyu Tseng <chuanyu.tseng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 52024a94e7111366141cfc5d888b2ef011f879e5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3822,8 +3822,9 @@ void amdgpu_dm_update_connector_after_de
 
 		aconnector->dc_sink = sink;
 		dc_sink_retain(aconnector->dc_sink);
+		drm_edid_free(aconnector->drm_edid);
+		aconnector->drm_edid = NULL;
 		if (sink->dc_edid.length == 0) {
-			aconnector->drm_edid = NULL;
 			hdmi_cec_unset_edid(aconnector);
 			if (aconnector->dc_link->aux_mode) {
 				drm_dp_cec_unset_edid(&aconnector->dm_dp_aux.aux);


