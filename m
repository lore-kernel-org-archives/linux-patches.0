Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51D3611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEAFC4339B;
	Sun, 28 May 2023 19:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302601;
	bh=lmhsUYHYcurU8VICbyaQ8xb9bQ9uleMxwfjXVYCnCpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzplkH/9qE6oUuZKPBk31GhMZoOOsGxWjcCgWK33hmuWjQFpnA/+T2JSfbr7gS1qt
	 NEs16zWKDGlKp4LHGCdcJBA5yhjjJThqP86oB0TXhP25xaIowva0FLDZwt9U4I4+Yl
	 qVmgQpfOF8lie+IqjBbconk4IY2POGzP9z5i1/dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 042/119] drm/radeon: reintroduce radeon_dp_work_func content
Date: Sun, 28 May 2023 20:10:42 +0100
Message-Id: <20230528190836.787090458@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit a34fc1bcd2c4d8b09dcfc0b95ac65bca1e579bd7 upstream.

Put back the radeon_dp_work_func logic.  It seems that
handling DP RX interrupts is necessary to make some
panels work.  This was removed with the MST support,
but it regresses some systems so add it back.  While
we are here, add the proper mutex locking.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2567
Fixes: 01ad1d9c2888 ("drm/radeon: Drop legacy MST support")
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -100,6 +100,16 @@ static void radeon_hotplug_work_func(str
 
 static void radeon_dp_work_func(struct work_struct *work)
 {
+	struct radeon_device *rdev = container_of(work, struct radeon_device,
+						  dp_work);
+	struct drm_device *dev = rdev->ddev;
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	struct drm_connector *connector;
+
+	mutex_lock(&mode_config->mutex);
+	list_for_each_entry(connector, &mode_config->connector_list, head)
+		radeon_connector_hotplug(connector);
+	mutex_unlock(&mode_config->mutex);
 }
 
 /**


