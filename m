Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF730157E6A;
	Mon, 29 Jan 2024 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548293; cv=none; b=ns4m8yn7FkrEBjHawVKRfQOaZFMQz091LlfIglGEGIaqSa8vNsvr9MVpi/Y1MqPjN+q2/MlGaI6nwzO2xFQms/AjOi/dRsF+U+i3OcNwy5OTlioqfUOFaRzKQJpkz1FtHETxM4rgauGvMgJA+HLWeq0w+g0UrAL6nOlKeGCtn4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548293; c=relaxed/simple;
	bh=zcf5lCtaWQz/HFDhvJJ97VH2N25ohuJzxjLjYCdxJas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxd3nYsswhUxM5neFLq6LcJQXVAjHelh69UGlbyE+kJUakAzd6ap9itwccSpLEyngaLByp/4NK5djbVeSCgbucfpCTRGFJxIEQKvM0n9iK2FtmOOlb73hlglFiS8L8S9m2PINGryTyXuQWCVOlBtEIpmtyN71GsRw1ohxzAf7yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xA8XlH4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xA8XlH4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A86C433A6;
	Mon, 29 Jan 2024 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548293;
	bh=zcf5lCtaWQz/HFDhvJJ97VH2N25ohuJzxjLjYCdxJas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xA8XlH4O9SlfwmOOHri4V781sVJRhoAMsL3zuLiyZmwaMl4SgAmGEkpFQuuYpkahf
	 cBiOBlUhL8zG4cUKpl295uzRJmNxqVuxpAzMEkpKwR+C0eIEudWnDOWVh1bSfL04Ca
	 WOQZLKhPB0nxyvlXaYWX2l5OZicHQEmu24MnUwxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wade Wang <wade.wang@hp.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 075/185] drm/amd/display: pbn_div need be updated for hotplug event
Date: Mon, 29 Jan 2024 09:04:35 -0800
Message-ID: <20240129170001.013123430@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <wayne.lin@amd.com>

commit 9cdef4f720376ef0fb0febce1ed2377c19e531f9 upstream.

link_rate sometime will be changed when DP MST connector hotplug, so
pbn_div also need be updated; otherwise, it will mismatch with
link_rate, causes no output in external monitor.

This is a backport to 6.7 and older.

Cc: stable@vger.kernel.org
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Wade Wang <wade.wang@hp.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6677,8 +6677,7 @@ static int dm_encoder_helper_atomic_chec
 	if (IS_ERR(mst_state))
 		return PTR_ERR(mst_state);
 
-	if (!mst_state->pbn_div)
-		mst_state->pbn_div = dm_mst_get_pbn_divider(aconnector->mst_port->dc_link);
+	mst_state->pbn_div = dm_mst_get_pbn_divider(aconnector->mst_port->dc_link);
 
 	if (!state->duplicated) {
 		int max_bpc = conn_state->max_requested_bpc;


