Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B2B70831;
	Tue, 15 Jul 2025 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587660; cv=none; b=Wa87nltOrKmD/XAxj7hrmseIgHkdew/gfn3mb94m5CWVBgGNiQUvwwGd+EPKvSsRNrk3/Ef0PVuFbDVp2R1jy4h3Vw/3B+jjPBtkcB+JTk036TAlRkoQpFv0aGfQxMtP1/DnkcKcu03htcYRnXqPPQ8kDDSzPb2zukrlk4+CTDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587660; c=relaxed/simple;
	bh=HFBy1s9B6TkHjA+sOWVWCB7isd+JZ+wWosA6L52hFRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRaJORtThkykCeGibQ6VP2w+vtSznU7lnqxp4+9VHRaPzeidqWJ0b4u2K8Mw2K+q11d1ewDMgP65mKvqKVbGArh6BVFVWO6E3zuOa0SBFuH68+TDWXk+/WgJIart6b7pWYhc9pV4QG6cBFlL9aTrRXoMco0DthcyCRXtaHJyMys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nDVKVVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nDVKVVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F20C4CEE3;
	Tue, 15 Jul 2025 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587660;
	bh=HFBy1s9B6TkHjA+sOWVWCB7isd+JZ+wWosA6L52hFRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nDVKVVv2JnCfH/QHqZHjnRIyO9l3xbbOenesm2s9aFTxTpK4VP232XrLoQIp2qXx
	 7qOotzbDaS0j9V86Gm+sf3aEZTJ8H1ARNex4U81oCtkylXh66w8RjezvMys0OhiRos
	 ZType6i1gWgHbRme5zAoHVPJnbmQREkEYVkaZ4sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.10 064/208] drm/tegra: Fix a possible null pointer dereference
Date: Tue, 15 Jul 2025 15:12:53 +0200
Message-ID: <20250715130813.517331784@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit 780351a5f61416ed2ba1199cc57e4a076fca644d upstream.

In tegra_crtc_reset(), new memory is allocated with kzalloc(), but
no check is performed. Before calling __drm_atomic_helper_crtc_reset,
state should be checked to prevent possible null pointer dereference.

Fixes: b7e0b04ae450 ("drm/tegra: Convert to using __drm_atomic_helper_crtc_reset() for reset.")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20241106095906.15247-1-chenqiuji666@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/dc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1206,7 +1206,10 @@ static void tegra_crtc_reset(struct drm_
 	if (crtc->state)
 		tegra_crtc_atomic_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 static struct drm_crtc_state *


