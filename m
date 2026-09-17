Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6419E26B2AD;
	Thu, 17 Sep 2026 15:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660290; cv=none; b=f62WJXGmchjLbZIKUN+MrBu1ilMu5+/WYm38UgBTn0+9Jon7kAHdsX0DPMRod6ynHHjJ59kVew3rs6cdoQ8/DrSSwKLbpL2P94+Wq4ZkExSsKT83x4+b7jjJrIU6yHXeNwqFamjXl4FRgB/w7uKGvWQ6VrH4LgnAfgvIWB1cM6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660290; c=relaxed/simple;
	bh=77G6SsZUhUKlMJbBlxLZbRXzicLFujweQZTuSgR1lsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASQ0xbZwSnZ9Up3ZZszo1YdkdY7OXTTIhcHHmoNmmgUwKQfe2Tb5341k1CGm//kVjR2Q1ZBxcpInB+VMW3ci2dFIsjz1AeWRPFTW9FtD7Ihry9XbEdPFKokxkU0mrBwZaXraG4K6M36pB9W+T5l22odTv2OQ3na0wp7EuOQO6sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8O+xC4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8O+xC4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDC11F000FF;
	Thu, 17 Sep 2026 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660289;
	bh=/rgIhTCWrD/Z2/pRqS72m4PvCSJx5ekMPHaIGg3HHl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8O+xC4/DsZ6HFKsmHx/zTEXJ0RfOEvVttDbD2ZIYoSK/wkPrj+U56YGUmBSIBEnj
	 u+McENsHLNaMUIYRXQogRz/3jN5ijgeU39HpUrHUEnvhcUz11dzgPuLcu6kzTq/yW9
	 AX59J4pholJLyaXqFfjA4kry3Uw01TOoay16nTl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 535/733] drm/amd/display: Exit IPS before connector detection on resume
Date: Thu, 17 Sep 2026 16:14:03 +0100
Message-ID: <20260917151405.541902544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Fangzhi Zuo <jerry.zuo@amd.com>

commit 3001d2073d6542a9e51fa5bca3a39a078094d3c6 upstream.

[Why & How]
On resume, dm_resume() walks the connector list and, for each connector,
calls dc_link_detect_connection_type() at the top of the loop iteration
before the per-connector dc_exit_ips_for_hw_access() that sits in the
detection branch. There is no dc_exit_ips_for_hw_access() before the loop,
so the very first HW access relies on an earlier connector having already
taken the display out of IPS.

Commit d1d51519bc3b ("drm/amd/display: Skip eDP detection when no sink")
skips the eDP connector when no panel is present. On a DCN3.5 APU whose
eDP link has no sink, the eDP iteration - which used to bring the HW out
of IPS first - is now skipped, so a downstream DP connector becomes the
first one processed. Its initial DDC/AUX access then runs while the HW is
still idle, the AUX transfers time out (-ETIMEDOUT), and the EDID read
fails:

  [drm:dm_helpers_read_local_edid [amdgpu]] *ERROR* EDID err: 2, on connector: DP-1
  amdgpu: [drm] *ERROR* No EDID read.

Take the display out of IPS once before the detection loop so the first
connector processed no longer touches the AUX/DDC engine while the HW is
still in idle power state. This keeps the eDP-skip boot/resume
optimization while fixing the DP EDID read failure.

Fixes: d1d51519bc3b ("drm/amd/display: Skip eDP detection when no sink")
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 86420fe3093161971b4064e05be11ffff1df76aa)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3925,6 +3925,10 @@ static int dm_resume(struct amdgpu_ip_bl
 	/* On resume we need to rewrite the MSTM control bits to enable MST*/
 	s3_handle_mst(ddev, false);
 
+	/* Exit IPS before the detection loop's first AUX/DDC access. */
+	scoped_guard(mutex, &dm->dc_lock)
+		dc_exit_ips_for_hw_access(dm->dc);
+
 	/* Do detection*/
 	drm_connector_list_iter_begin(ddev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {


