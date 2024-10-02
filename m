Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EB21D042F;
	Wed,  2 Oct 2024 13:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876756; cv=none; b=A13fiB440r6/ot6bGOhh8KJd18OfdkzaJxYob4n4eTdRwIi4GoiWfR4eQKGSdeObwAdQomL3gy0mAFW0ZfwTSzyEN2gRc8BZW/R+mFMn1vUxKp6i2xoOsamy/fbC0LsdNMLpqfrVDmiYj4TT3pTBTLDgsJktZRxTyAqw7jW09u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876756; c=relaxed/simple;
	bh=BU+pohYJBy6SoK4oe2S0N/36Zzr7Jz6SSW0MQ2qXudg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXYPXCaeZ2vAKE7utumx6365pDdCXIEOQSnYpJB/vO+GpJPQqK72isNlJf7hm4h8CYItOQEdBSIfTMaNv4xsrsxvsHRx0kzmCXoDlc2JVN5GdvOJjAozatmoYgdGJaNHQoIzXm1ugGZCa08q2bDIjdr5USgSlTJ4OCaRngFZvQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPzKdvu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPzKdvu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B24C4CEC2;
	Wed,  2 Oct 2024 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876756;
	bh=BU+pohYJBy6SoK4oe2S0N/36Zzr7Jz6SSW0MQ2qXudg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPzKdvu3PVvhrXcUNk98lq4B6FVkSkRk9VzC58v0k0NquhibRjGIHAg4TrONR2BCe
	 V1iFGijjvhPsOusUc7JwGuQOuWNBq0kDC+oUXqg9jsVSDlvcw1hFY0cRBs9uUIhdSf
	 gtAX8u04KSKJL9MmKjnH/m9lf1bAW3xB40NzTJFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Anthony Koo <anthony.koo@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 552/695] drm/amd/display: Round calculated vtotal
Date: Wed,  2 Oct 2024 14:59:10 +0200
Message-ID: <20241002125844.538708253@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Chen <robin.chen@amd.com>

commit c03fca619fc687338a3b6511fdbed94096abdf79 upstream.

[WHY]
The calculated vtotal may has 1 line deviation. To get precisely
vtotal number, round the vtotal result.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Signed-off-by: Robin Chen <robin.chen@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -134,7 +134,7 @@ unsigned int mod_freesync_calc_v_total_f
 
 	v_total = div64_u64(div64_u64(((unsigned long long)(
 			frame_duration_in_ns) * (stream->timing.pix_clk_100hz / 10)),
-			stream->timing.h_total), 1000000);
+			stream->timing.h_total) + 500000, 1000000);
 
 	/* v_total cannot be less than nominal */
 	if (v_total < stream->timing.v_total) {


