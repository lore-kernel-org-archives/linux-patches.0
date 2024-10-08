Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CF71779B1;
	Tue,  8 Oct 2024 12:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391074; cv=none; b=t8Px0jjFri47JQ5ojVK4b01wuBkgh0HitI5qJuDHEYxHYX164owafoqY7nC8mjR19MEIMhJqzwYhkL09oIjMur3BPDUeArJKdFkbPE/fIJD4euY2pLJ4FR1VaSqs5h6im4GbXdCIXHWhVjUPDIaWfYGdRxvKMf63X3+bE4k5F28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391074; c=relaxed/simple;
	bh=Fl9IUoMee1ddZwtMqCI4A5n33S9HrUWqPk4NRS+L68Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEw3lQAcSGMqhUANbAa/0U++mChzuVWd8/KY2D4B8C+z2rCv7LF/HQEkab09mhHkOaTsHDjrKQZUP0kb8bRPgzun/0rxKk6oHdM3TZin1PYi3MaiRoA0IEJmw12WVt0I+mOMWeDc0gAeYgZONzKImEB/i5KtXByTZ3Gn2tuQElE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0/g002f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0/g002f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE3DC4CECD;
	Tue,  8 Oct 2024 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391074;
	bh=Fl9IUoMee1ddZwtMqCI4A5n33S9HrUWqPk4NRS+L68Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0/g002fuwwGOPndqV9+T2PrIn/PorxEBOjKvqSiUDa0IP0Wz+/sYB6TMdpYJMKkv
	 YdEekxic8pOz7ULDGnswf1Vuf1uz8QhGcwvExh8ZJCZlaQ+AbFJ8E4Cy2K5ULDb3yz
	 fLUSZg0X0XTzSiIyKrx1JpGydekPW+4v7kSc00zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 482/482] drm/amd/display: enable_hpo_dp_link_output: Check link_res->hpo_dp_link_enc before using it
Date: Tue,  8 Oct 2024 14:09:05 +0200
Message-ID: <20241008115707.477927346@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit d925c04d974c657d10471c0c2dba3bc9c7d994ee upstream.

[WHAT & HOW]
Functions dp_enable_link_phy and dp_disable_link_phy can pass link_res
without initializing hpo_dp_link_enc and it is necessary to check for
null before dereferencing.

This fixes 1 FORWARD_NULL issue reported by Coverity.

Fixes: 0beca868cde8 ("drm/amd/display: Check link_res->hpo_dp_link_enc before using it")
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c
@@ -110,6 +110,11 @@ void enable_hpo_dp_link_output(struct dc
 		enum clock_source_id clock_source,
 		const struct dc_link_settings *link_settings)
 {
+	if (!link_res->hpo_dp_link_enc) {
+		DC_LOG_ERROR("%s: invalid hpo_dp_link_enc\n", __func__);
+		return;
+	}
+
 	if (link->dc->res_pool->dccg->funcs->set_symclk32_le_root_clock_gating)
 		link->dc->res_pool->dccg->funcs->set_symclk32_le_root_clock_gating(
 				link->dc->res_pool->dccg,


