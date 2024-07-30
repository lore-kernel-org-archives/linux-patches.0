Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53DB8BE8;
	Tue, 30 Jul 2024 16:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357194; cv=none; b=InGjrzBGx99V1hjIvEXG+sfxp5YDWxbL7fj80eT/UzSGP/woO6ZphdFbbEXK2cbhQxYWjFdkAYTDhUteH0v9vkglN+7/DlXUOSPadmTBxZwvbIt+Ka+bfcZjQ0gVDqBPASB6scDtaggJb3ZTMPR+chYkc8xJ10kdGqx3gItL4K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357194; c=relaxed/simple;
	bh=C7uXrt9uCLEubTlnWAQr/ssICyqRW+G6oonkDzsqDT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXOyB/ihSZfwhMFMESy/J3N9e54l7ScIdBp2vQR5Evvw5eC95j7wHSBYo0XTA+aPUBnC3QYcgKZ7c6C+bViQBCAseETeEigwyF6h33xI4J3VnSRwywxH5Xf24g+xRBh3WMtBrbrmlMAjdWF+CAwrIveAZ+L4iDwsK0GcIO0dOvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbtGyMQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbtGyMQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8BFC4AF0A;
	Tue, 30 Jul 2024 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357193;
	bh=C7uXrt9uCLEubTlnWAQr/ssICyqRW+G6oonkDzsqDT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbtGyMQharPSyWCDbsXNDKxjO2iSfqogY2OzQTtzPIN51fPXVMjuBAvdHJ+r44UYf
	 Ue7TA+b1AMKRyUKkB25cooRV8XzCWtMg8ovc9ES5CQsR722EM3z2KCI5ROZW9xh6u/
	 +2uzC7nyf0mrwuBXDUQ/SW9oN8UXsLmvA4QdQNHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/568] drm/qxl: Add check for drm_cvt_mode
Date: Tue, 30 Jul 2024 17:45:35 +0200
Message-ID: <20240730151648.794309458@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 404b0483bb7cb..8ee614be9adf3 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -236,6 +236,9 @@ static int qxl_add_mode(struct drm_connector *connector,
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



