Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1872F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F756C433D2;
	Wed, 12 Apr 2023 08:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289642;
	bh=mK2Ns8JCogFUngEMgEalWqg+zYAbpD644AXbLretVZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEZrF9n+jgmdTf231nz+vJL85sRbDqzTOqKyZwvVNNXo4s3TSO42sSSZHkO23oB93
	 sAZJIyusBNiNj4a6O2SH2qcLjzrIpPBxUOpL9s3lJbPPuqing/4YFwBs/ReCKearen
	 ugANVQKbCQBZ7rQIng0X6nd2CrAoef5E+/0SyaXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Jasdeep Dhillon <jdhillon@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.2 156/173] drm/amd/display: Clear MST topology if it fails to resume
Date: Wed, 12 Apr 2023 10:34:42 +0200
Message-Id: <20230412082844.408680622@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roman Li <roman.li@amd.com>

commit 3f6752b4de41896c7f1609b1585db2080e8150d8 upstream.

[Why]
In case of failure to resume MST topology after suspend, an emtpty
mst tree prevents further mst hub detection on the same connector.
That causes the issue with MST hub hotplug after it's been unplug in
suspend.

[How]
Stop topology manager on the connector after detecting DM_MST failure.

Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2183,6 +2183,8 @@ static int detect_mst_link_for_all_conne
 				DRM_ERROR("DM_MST: Failed to start MST\n");
 				aconnector->dc_link->type =
 					dc_connection_single;
+				ret = dm_helpers_dp_mst_stop_top_mgr(aconnector->dc_link->ctx,
+								     aconnector->dc_link);
 				break;
 			}
 		}


