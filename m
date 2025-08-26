Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9362C17A303;
	Tue, 26 Aug 2025 12:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213074; cv=none; b=RqkPyiTRZECLueWd09PNG9bS8zwywW0JCrDwRP3uXB/URwaIWKxJrSPnbhTNYrjwNQnuRLLxV8bDjvm38VAIg6wXeVeVQLnyS8E/ylHA1SBccvnGsH1C83ojtnCH39dgzaCxazVdbSMTAEXRnkStNkPWT1sbk2YPHtdWDh7xlbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213074; c=relaxed/simple;
	bh=rJRoroA7T0hbpHaWvS4Vqfe4ozF9LkxUL5h9EFTaV8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bICVVeet9UDbArGwi+/A+w0KbMwjUcf6kdlXKSeJ2QfhojpD/1UZ17aR+7Iy4SwhIMi41HJC4b34Q2WaInYc2p3tK9estTpUtDkhNSc0XYDADPerz9nEbLRbexr5jQqbswZjM4cN00Tph/zew430GW3qwbUMMxpGoGE+NUyYIAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlGj321e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlGj321e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220E1C4CEF4;
	Tue, 26 Aug 2025 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213074;
	bh=rJRoroA7T0hbpHaWvS4Vqfe4ozF9LkxUL5h9EFTaV8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlGj321eKoZ/NmR6nk+v4giIaC57hu813+kvh2xj9AVILnIiOk75Dp7Gn0rvR4kwD
	 lZCVu04UDLoyuvWtyi9F1I44rdby0DijTz+Eg+RTVxi80yb8+vJpgCNo1P+qgU6H+e
	 Rk3lgCINqV8DKkOwnduZ1RvJXDPXgcQYgpKShwJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/587] drm/amd/display: Avoid trying AUX transactions on disconnected ports
Date: Tue, 26 Aug 2025 13:06:00 +0200
Message-ID: <20250826110958.305311045@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit deb24e64c8881c462b29e2c69afd9e6669058be5 ]

[Why & How]
Observe that we try to access DPCD 0x600h of disconnected DP ports.
In order not to wasting time on retrying these ports, call
dpcd_write_rx_power_ctrl() after checking its connection status.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index 9b470812d96a..2ce2d9ff7568 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -137,7 +137,8 @@ void link_blank_dp_stream(struct dc_link *link, bool hw_init)
 				}
 		}
 
-		if ((!link->wa_flags.dp_keep_receiver_powered) || hw_init)
+		if (((!link->wa_flags.dp_keep_receiver_powered) || hw_init) &&
+			(link->type != dc_connection_none))
 			dpcd_write_rx_power_ctrl(link, false);
 	}
 }
-- 
2.39.5



