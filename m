Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443F6763F6;
	Wed, 21 Feb 2024 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522730; cv=none; b=Rqmgm7rNd0FqJwFlU5bA5xa6gznNOsbVR+3zCHUYCAkzZvNn4m7yPbvb0Y82784Dpa8HNZq5jqqM1I3JU7AJL4vyeuwBcEEY0pkWbEkzzzc5vhLjvTBGssdAYS+2go74g/hA8ZHBvB7XzUKId7CyRZUFMxtJch45xbg6dpZ4SHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522730; c=relaxed/simple;
	bh=cO6ejIwLajDoipaqFll6Ex03AxhgVvIqYUvY1Q3b8NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMCMPGw0t3wdPnwoo5ynBa9ETboC3K2/6wQqIK0YKGQ0vLNtU259uJ9zsDNBxUIngc4cuq2n+v/yTRyiXldok0oOdcR9wr9Ucl+zrH/rNFx/BCIw4H9GRDakiVlscOdaoDMaAzWGSLSMZ5j8cimZhczgjavj4H3jE2OhBk2ogkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACsrtfrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACsrtfrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC81DC433F1;
	Wed, 21 Feb 2024 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522730;
	bh=cO6ejIwLajDoipaqFll6Ex03AxhgVvIqYUvY1Q3b8NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACsrtfrPpAPIJFz+kclzY6MztHKn+WiL9v/Q4+W8wmJ201J4CNQpnjXHEsDeNSWB0
	 m1T3S8likvVI6ajdmpPP9PScs5YaYaMgbJGEZ6Lli3MvidXBHN9itArvlbqH3FbDIL
	 WYF1XmAsyA/V7JmVuJEFmOxdoSvv587FgsRFtNZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/476] drm/amd/display: Fix tiled display misalignment
Date: Wed, 21 Feb 2024 14:04:24 +0100
Message-ID: <20240221130015.775217130@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>

[ Upstream commit c4b8394e76adba4f50a3c2696c75b214a291e24a ]

[Why]
When otg workaround is applied during clock update, otgs of
tiled display went out of sync.

[How]
To call dc_trigger_sync() after clock update to sync otgs again.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 3919e75fec16..ef151a1bc31c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1680,6 +1680,10 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 		wait_for_no_pipes_pending(dc, context);
 		/* pplib is notified if disp_num changed */
 		dc->hwss.optimize_bandwidth(dc, context);
+		/* Need to do otg sync again as otg could be out of sync due to otg
+		 * workaround applied during clock update
+		 */
+		dc_trigger_sync(dc, context);
 	}
 
 	if (dc->ctx->dce_version >= DCE_VERSION_MAX)
-- 
2.43.0



