Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2199F2797B5;
	Thu, 27 Nov 2025 14:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254935; cv=none; b=rSNYxMUEo9MgJ8zXtNChQMK/Rq9kzMNlBKIXaKCK3GO1xxjSAQ1P38IYo7J8Pk8fas4UJQVnwMVq2IHTcjMIx8No3Bf81ivJE2/xWMHoPhuxcR6of/RR4fjCeKg4OqpbZLi5ywnT+GZy7vkvYv+bD+4YsT3hlVTumWQ2c4u+wTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254935; c=relaxed/simple;
	bh=RU3Hurs/dW7S7jCa8K070tUVJYtZKInYBiEZtBTNyGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nW6BjkweKghHGFK/4XEyDRmbdr2qeVRbfJDo+1MzwGeGy7lGW3fxKJXGV01+w8G+OV9ELkRSgaAeogzktUSeU+NnecuroyH7cCOr1SPZMZj449JjduaLcIQpKxdUpvFMfGHjXr8tEpIFvSBiXwZLvaDbOo5krg6Oy74R1vOZ7qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Chr36V3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Chr36V3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A1EC4CEF8;
	Thu, 27 Nov 2025 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254934;
	bh=RU3Hurs/dW7S7jCa8K070tUVJYtZKInYBiEZtBTNyGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Chr36V3uSfCWwWxSmSlbm25MuqefGd7EnLv6Ib3K8t4CKi26RvBshSoWV3meyZwDT
	 YmPty6dbvaMclpbGvM9eNnlST15JSCpcOW9xe9vGRd/wWuIB4A6dHfTnSmDFWnddkr
	 mybwDrfsHyu93wNNZuoUTnDdtG5SkJjXxtV1dOEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 37/86] drm/amd/display: Move sleep into each retry for retrieve_link_cap()
Date: Thu, 27 Nov 2025 15:45:53 +0100
Message-ID: <20251127144029.182078280@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 71ad9054c1f241be63f9d11df8cbd0aa0352fe16 upstream.

[Why]
When a monitor is booting it's possible that it isn't ready to retrieve
link caps and this can lead to an EDID read failure:

```
[drm:retrieve_link_cap [amdgpu]] *ERROR* retrieve_link_cap: Read receiver caps dpcd data failed.
amdgpu 0000:c5:00.0: [drm] *ERROR* No EDID read.
```

[How]
Rather than msleep once and try a few times, msleep each time.  Should
be no changes for existing working monitors, but should correct reading
caps on a monitor that is slow to boot.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4672
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 669dca37b3348a447db04bbdcbb3def94d5997cc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -1598,12 +1598,13 @@ static bool retrieve_link_cap(struct dc_
 	status = dpcd_get_tunneling_device_data(link);
 
 	dpcd_set_source_specific_data(link);
-	/* Sink may need to configure internals based on vendor, so allow some
-	 * time before proceeding with possibly vendor specific transactions
-	 */
-	msleep(post_oui_delay);
 
 	for (i = 0; i < read_dpcd_retry_cnt; i++) {
+		/*
+		 * Sink may need to configure internals based on vendor, so allow some
+		 * time before proceeding with possibly vendor specific transactions
+		 */
+		msleep(post_oui_delay);
 		status = core_link_read_dpcd(
 				link,
 				DP_DPCD_REV,


