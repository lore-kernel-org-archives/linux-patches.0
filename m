Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1A4433A9;
	Tue, 30 Jul 2024 16:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357425; cv=none; b=JmOGUEhSFcORdi+BM3YRJPrY87eq5zS1yBk399PhyE57K76PQtmIdfoZbjikBTmRWlg59M/A0IL4y9INuW1bBG4poOoZuoZ9g+S0/1xTOeMIBlWVtGskNnJPMPnTY5Kv02EVBCN+GK4gKz/8W4pyTJhqR2s/vDSxTCXlYxloTLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357425; c=relaxed/simple;
	bh=6nnXBmCiwQZUl6EL9nrfyxw3locsw1M48D6Ec1CznhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOu7S5m0zdiJ21KMRXJwILIe6xo2KQ/gecdUTOuW2VYT6jpL89gTsuitglEyhmwP3tJZ7JI+ZHjUtyR8izTtrBAhtpQUx44CgeF7WpKK+orlN/6A1KGLIajzqO5FhjRFBzRaSwbZUntGG7SIcatciD66TfOS1euXxqZ82fzhQog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4L9J8nF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4L9J8nF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA631C32782;
	Tue, 30 Jul 2024 16:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357425;
	bh=6nnXBmCiwQZUl6EL9nrfyxw3locsw1M48D6Ec1CznhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4L9J8nFdiPhUu66gjnrcbSMJCQji0DD2qU2oGZpOK4kxjV6KZe4WckTo0E82x6Bj
	 v4uw/Ms+wGF56+AF+9pbwmIdOH132Ex0CeA5iXKonIfQvmduz/5mxCj5gZ86OGVkYJ
	 jC7p1ZWLU4ueU3eI0kCEUmOm2xQvrsZEHlCrJ8Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.1 291/440] drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes
Date: Tue, 30 Jul 2024 17:48:44 +0200
Message-ID: <20240730151627.198182273@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 2df7aac81070987b0f052985856aa325a38debf6 upstream.

In psb_intel_lvds_get_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 89c78134cc54 ("gma500: Add Poulsbo support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709092011.3204970-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/psb_intel_lvds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -502,6 +502,9 @@ static int psb_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


