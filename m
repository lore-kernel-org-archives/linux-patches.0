Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C82A1AC8BB;
	Thu, 15 Aug 2024 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731388; cv=none; b=FJcDDWhouW5pjKFNBf8kuxRGnkM5IXIpJqp863ICcYRv4d4JVZznyWCPNOK8fR/ETPoifdxaKfnfNgycykqLLCwbwcJJyIUChalGPhBdTBa0EdlcH7l9IXRYb2VqNbKC0xzMww5ZxoEuijzNRTXQ9Za1kBlIlVeFEzQv0YuVw8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731388; c=relaxed/simple;
	bh=L7LZyKOjSaErfNlAMfHdXqGgwekCq3MWK9BIn6iK3S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1pL67kB+RAKoxFZDun3NSYdkK9GnwayePfscL1yBWOgs/QxbfLG9uKhfnFLkgk88DIrr94CmITwRM3Q8P3UM78r31dW+/poVpyYKFH+Scywyr2gGE6gse4e3gkfZgcL7fl1hQHHB1kYJUyhcPBa7De+XmdHbvsKB4mCKjwFjtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSTQyR9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSTQyR9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4014C32786;
	Thu, 15 Aug 2024 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731388;
	bh=L7LZyKOjSaErfNlAMfHdXqGgwekCq3MWK9BIn6iK3S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSTQyR9UqASdxEWHwqpqp7sWXH9EnfREQAETGbd4hB3AgVS/fjqIcIbEzlagSE7/A
	 Tr7n3T7R9SSjXhhlzZohy+G0zodv3lG8VdjazMDtQFDNWGJu20Es61mUP3gMtnOwcj
	 mnDUi+crHAxKSE5/K+e0kk3qpuMA7B9NRHmRiYZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 5.4 096/259] drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes
Date: Thu, 15 Aug 2024 15:23:49 +0200
Message-ID: <20240815131906.510761664@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -391,6 +391,9 @@ static int cdv_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


