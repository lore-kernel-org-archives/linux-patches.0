Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D522E540B;
	Tue,  8 Jul 2025 16:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993970; cv=none; b=O4yEZ6HEKH+aNiUUPmPZcZWPpBQQLpl3xcxzq5QdezIwfMDViiEhD6LmtvU6QYGvYnt9VyBzCRa5vKgmtHqjgT8+GcPAjkVaENMhWQ4cxoP0SwoQZ+p/I/0tRP7CALCZ0kbaJH+XDMTaN5Fc+oHuJa2mPmZmLjf837QsqSRqdMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993970; c=relaxed/simple;
	bh=1I3cOiAs0YqyZ8ezuMQUegBQMdVBoiDyYYZEOL6VGUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfc0wfaTz9WNs3515Iej819EUiBBALvuv2o0MED7xVinQV0H1N7wsSGOT0dwwL0Hho1eCaWbIhyUozhl7hvxBENGYEBzx47U7xu3p+AHrzXhT1c666xFdaBgymwwd3b2SZPFNF6NPNa+Njc5ogyU1DsbFxZCBaIBrRHwkUaQxdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmebui5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmebui5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BD7C4CEED;
	Tue,  8 Jul 2025 16:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993969;
	bh=1I3cOiAs0YqyZ8ezuMQUegBQMdVBoiDyYYZEOL6VGUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmebui5wwo39u06+huWusv1ai/68VWmtOrcVHG5L/FuTly8s+0iR7se3DAaww3Gox
	 WWGsmy2m4mCa0GJKnwpDFMm2o4pr47La900uIzERJVuoy06tUSgJt7+hRwCDkEq7Hf
	 M2/DPSsQ6r37BEaGVKN2kxlrCFGnsP5aGSjGFSBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.15 081/160] drm/tegra: Fix a possible null pointer dereference
Date: Tue,  8 Jul 2025 18:21:58 +0200
Message-ID: <20250708162233.777777804@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1293,7 +1293,10 @@ static void tegra_crtc_reset(struct drm_
 	if (crtc->state)
 		tegra_crtc_atomic_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 static struct drm_crtc_state *


