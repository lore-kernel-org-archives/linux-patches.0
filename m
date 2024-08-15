Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158907DA78;
	Thu, 15 Aug 2024 13:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728659; cv=none; b=tXg9hIbw8fzJEWZAHmqLMax+Lnw67Jp3nxXIwq1k4Rpf/a/SZUq7NDA0DvxVYyFgYUktMQbkiQ3l41zo27m2LE81I7xfdNvlGJdjmtW2GmvcnHtA1nnBMxEa1dLb5uPccxjRf7TVKmb5uuB4l48lnZBfszEbVtm9FHjAGdQ2Tk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728659; c=relaxed/simple;
	bh=GPPx87Hq6sRB3FhnWxiZIUdq2qEkmB4/42OrCox/v+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/7dVy3lrHNA/RIToY1GGa1HFXVBTvDxeM/dYS9ova4KX4HB17wJkDPFUD0jO/sZRY//n94Hb1r7WXc2djyzgmFzeFLugy9tLixLYCHljMqKiSS/7EjQ7PuCeK/VyuEpCgPiss3PnOLKWNXdVPbL7pTzdHGCS3zlPXFZD+wXQT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E55tafs7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E55tafs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C84C32786;
	Thu, 15 Aug 2024 13:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728659;
	bh=GPPx87Hq6sRB3FhnWxiZIUdq2qEkmB4/42OrCox/v+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E55tafs7sBBjc7w7sAgeoynroYKIFhvkgyQkFvEF1gOfF/BBj9pfILil0mCyrYL++
	 Xh/TKV1lBY8FkZIJLLCeslg6Eb0M+G1tzI7Em/ghB1TfANwrjaNwzoajOFH3vqS1KT
	 +RehdAcF/rFDVrjSMcx3n3HChQGtWCMzfwBGEx9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 4.19 069/196] drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes
Date: Thu, 15 Aug 2024 15:23:06 +0200
Message-ID: <20240815131854.716680776@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit cb520c3f366c77e8d69e4e2e2781a8ce48d98e79 upstream.

In cdv_intel_lvds_get_modes(), the return value of drm_mode_duplicate()
is assigned to mode, which will lead to a NULL pointer dereference on
failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 6a227d5fd6c4 ("gma500: Add support for Cedarview")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709113311.37168-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/cdv_intel_lvds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gma500/cdv_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_lvds.c
@@ -404,6 +404,9 @@ static int cdv_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


