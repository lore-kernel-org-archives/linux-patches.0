Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19DB31CA61;
	Mon, 18 Aug 2025 13:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523624; cv=none; b=nrZXSedmQaczlYV1YloSAZkYl9S26WvhzlASuxduBEUTfvb/WRGoaf1ehUpbOW5Gigiv0kATmsiZfDT7qLJA8PpF4etDUVoXwUBObFGOvxm0fyKCU9mZlwbaGRj1Hm3kwM2rYvOiFM72bc0vMsiPGhtJdPi0hiYiWKpOSum50JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523624; c=relaxed/simple;
	bh=4HO5ElV4/Pd5Z+1jy2TftiyK6GTLT5F3dxtMNQdC37o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3K0EqoGgGgLKHofpuJVXMfKxp3UC7+R+JOFLElIzrrR3kjdoQU1IB8NPV4JW8hJn+CKYzmJffcN81o5h79FsIomaBdko+Egz4Ce4/gcaYIxlfxalA6RWN6o1pWxkII7nkV5LA7Mbv5X4GNkMwjpgI/aQ7Op620Mzy7oFUpAG18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEMWvfwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEMWvfwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66503C4CEEB;
	Mon, 18 Aug 2025 13:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523623;
	bh=4HO5ElV4/Pd5Z+1jy2TftiyK6GTLT5F3dxtMNQdC37o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEMWvfwREmlmQf1roy/LVJUE7m+s1e0cBnkKQGSbHrAVZ6pu1OzVgi+HREkMfw0/j
	 cuK3pQhFqiZSfoMZhvyjB2B/2uvNNxjO4MTX1bdA4E1yGaL14MD7KMvR9/nN3UKWGa
	 lp5bG5jAjyWN0taE0z0wHo4ucyrYnwodG9QAQ6yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Syed Hassan <syed.hassan@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 221/515] drm/amd/display: limit clear_update_flags to dcn32 and above
Date: Mon, 18 Aug 2025 14:43:27 +0200
Message-ID: <20250818124506.875379169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit f354556e29f40ef44fa8b13dc914817db3537e20 ]

[why]
dc has some code out of sync:
dc_commit_updates_for_stream handles v1/v2/v3,
but dc_update_planes_and_stream makes v1 asic to use v2.

as a reression fix: limit clear_update_flags to dcn32 or newer asic.
need to follow up that v1 asic using v2 issue.

Reviewed-by: Syed Hassan <syed.hassan@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 40561c4deb3c..d6f0c82d8dda 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -5335,8 +5335,7 @@ bool dc_update_planes_and_stream(struct dc *dc,
 	else
 		ret = update_planes_and_stream_v2(dc, srf_updates,
 			surface_count, stream, stream_update);
-
-	if (ret)
+	if (ret && dc->ctx->dce_version >= DCN_VERSION_3_2)
 		clear_update_flags(srf_updates, surface_count, stream);
 
 	return ret;
@@ -5367,7 +5366,7 @@ void dc_commit_updates_for_stream(struct dc *dc,
 		ret = update_planes_and_stream_v1(dc, srf_updates, surface_count, stream,
 				stream_update, state);
 
-	if (ret)
+	if (ret && dc->ctx->dce_version >= DCN_VERSION_3_2)
 		clear_update_flags(srf_updates, surface_count, stream);
 }
 
-- 
2.39.5



