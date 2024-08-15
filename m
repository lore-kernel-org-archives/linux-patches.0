Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCA17DA9E;
	Thu, 15 Aug 2024 13:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729710; cv=none; b=RV74OkLIrIg5zfoTVIBhk6dOWCY7iFDd0BEcAlSfEbrEmDhCx+V5KvkPRVhLwS2Xikr4l2gM+zXHj48JclmAXGW/udIk8dNzjYj6/stydNbg+wa5CmrsykDnk0SF5fMpRdmj/8CRLzz1AM5F9MXWrMmJ08HP8UaSU2V4FCnQMAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729710; c=relaxed/simple;
	bh=joaQF8ROzCVcLG2YmaRAGLFGlLO3+5rStLnhs08uiyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qts6NkHP/l9XclDlN+yzwbJAtNtj+XlKeXMtWJKBUMUYrIKOQ6fa+oMw+NzcgIVIg94vSpqoYycob6cMU+Q01r1QIT62nXI7DkKc9chHHgl8itRxg8LyUD7Rc//Yvy0V0t6/aHFj3KQoLMK8TVKSTczI6fOLqm/lVKhuA88PF2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABTxnlFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABTxnlFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F060C32786;
	Thu, 15 Aug 2024 13:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729710;
	bh=joaQF8ROzCVcLG2YmaRAGLFGlLO3+5rStLnhs08uiyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABTxnlFzy0545cYqSwfBffAq2NeC4+MpODkoW/tALhZrj1aECXjMSsxHmCX9h+V2F
	 pFtSdMS7xWxfuWgt1mX2t+9SSf+UdFmYUbUZpvcYgMVngsPE6iLdpEX1Bs81E04+iU
	 9spPeDmn85YkbjoahGnuYCFaf0CE7lPLNFcdMVzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 5.15 183/484] drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes
Date: Thu, 15 Aug 2024 15:20:41 +0200
Message-ID: <20240815131948.484248399@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
@@ -508,6 +508,9 @@ static int psb_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


