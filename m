Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7AC1A76C1;
	Thu, 15 Aug 2024 14:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731247; cv=none; b=rxmY+ZNdagphRLMkorAC+b3W4Q2H7OVPJHtG3lxZiPoPK7hczKIBQBVUQ0/fsGxrf+KpJadhrmzOR8rhCV+NVsVeesIn3DbikUUNazbPCyLVyNr/OfWjwh1w3R1n3CdbW10+qafRg7twaI8gzggWrBPs4GLd6JGba6W8AAPEQWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731247; c=relaxed/simple;
	bh=pvyO057lVB3BrKMNMaaOfh8yRiDfaaThR/hI5HoFA/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROP3rVjqz9UvkMhSJZtD/1566EzNZ/roc6Hy3rcBbvu8YetTHoOJxcqlw0wEo6DAOEQKDmowmnFeQyHm1j4fW6Gd0HeN8x8aexc9Ph+DhEs7Ttx82pSk4RpyS48TZ0WlaCA9ZUkTcEqeZoqbIauQa1XZdcATenHFOvZ4Nd56QlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrbxsY1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrbxsY1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5A2C32786;
	Thu, 15 Aug 2024 14:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731246;
	bh=pvyO057lVB3BrKMNMaaOfh8yRiDfaaThR/hI5HoFA/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrbxsY1fD+GLwaCgZ38C9qdMFlH0qdw3hn2Xsc+UUMYcsPto1yK6o2aWUz6sL9QZ9
	 KlzGzxepM9kNFrFGZL0j27Dg+9qs8mG02R/XxcOKyAJNrXjnvAMwvAzoVuhqMvB4o3
	 93Dl1QGSJScap0AWgNlEdIlvdBsViwiF5xJcmgeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/259] drm/qxl: Add check for drm_cvt_mode
Date: Thu, 15 Aug 2024 15:23:14 +0200
Message-ID: <20240815131905.165707301@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 7bd09a2db0f617377027a2bb0b9179e6959edff3 ]

Add check for the return value of drm_cvt_mode() and return the error if
it fails in order to avoid NULL pointer dereference.

Fixes: 1b043677d4be ("drm/qxl: add qxl_add_mode helper function")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Heng Qi <hengqi@linux.alibaba.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621071031.1987974-1-nichen@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index a6ee10cbcfdd6..677dd560c066d 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -230,6 +230,9 @@ static int qxl_add_mode(struct drm_connector *connector,
 		return 0;
 
 	mode = drm_cvt_mode(dev, width, height, 60, false, false, false);
+	if (!mode)
+		return 0;
+
 	if (preferred)
 		mode->type |= DRM_MODE_TYPE_PREFERRED;
 	mode->hdisplay = width;
-- 
2.43.0



