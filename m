Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCDF1C57BF;
	Tue, 27 Aug 2024 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772445; cv=none; b=aWviDdqNnT3aIgLcyw43lbCHKo4KbZLh+HSnw5PJoos92XcnWKHfs4+wT8kZgcVBzJ2nx8s8+v97IvF29gL3FQVcVHZD3QUnb7921ptjTOlux+zRr5KGXQNRLIkOil67KV3jQfr4qwLP2jL6maNTzS07XKvhO5hFOL9nVfmDvmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772445; c=relaxed/simple;
	bh=sSJaAXNXn0X7KddNAvknljEQZDhwP3OUyfe5uDsWjIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lyPVpZdX9q625j3hj/TO1hh/O/Lrx8AdmjP5QmFZbxS43Uwb/4ov2rVaVhCHfKSeS21vpOSFufOXg6ZGKyNU30BsNgcHVF/qP/aQNnK+B+tmZT52LQoIaCQ7VkXUwCm4iF4ImMzmApCSGNS9wD2gfJ4+aCfCkuk541tr2inxvaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMZTwG12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMZTwG12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B05C61068;
	Tue, 27 Aug 2024 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772445;
	bh=sSJaAXNXn0X7KddNAvknljEQZDhwP3OUyfe5uDsWjIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMZTwG12WMGBmvt6Fuw8BsBYGAVurDri05RIYAQSnGDDnLteAYWAW9E1kWpClS73m
	 55sr0Y3WSC0ziMcu7R9EBXWUO6s7GOuuLMVFBWjlC6IK9eKAolja4UvKMxTvI5Hqo4
	 FO6I6en8R4TyrlaIn8OC/J+btF53pB2WMy0StBZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/321] platform/surface: aggregator: Fix warning when controller is destroyed in probe
Date: Tue, 27 Aug 2024 16:38:46 +0200
Message-ID: <20240827143846.531939166@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit bc923d594db21bee0ead128eb4bb78f7e77467a4 ]

There is a small window in ssam_serial_hub_probe() where the controller
is initialized but has not been started yet. Specifically, between
ssam_controller_init() and ssam_controller_start(). Any failure in this
window, for example caused by a failure of serdev_device_open(),
currently results in an incorrect warning being emitted.

In particular, any failure in this window results in the controller
being destroyed via ssam_controller_destroy(). This function checks the
state of the controller and, in an attempt to validate that the
controller has been cleanly shut down before we try and deallocate any
resources, emits a warning if that state is not SSAM_CONTROLLER_STOPPED.

However, since we have only just initialized the controller and have not
yet started it, its state is SSAM_CONTROLLER_INITIALIZED. Note that this
is the only point at which the controller has this state, as it will
change after we start the controller with ssam_controller_start() and
never revert back. Further, at this point no communication has taken
place and the sender and receiver threads have not been started yet (and
we may not even have an open serdev device either).

Therefore, it is perfectly safe to call ssam_controller_destroy() with a
state of SSAM_CONTROLLER_INITIALIZED. This, however, means that the
warning currently being emitted is incorrect. Fix it by extending the
check.

Fixes: c167b9c7e3d6 ("platform/surface: Add Surface Aggregator subsystem")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20240811124645.246016-1-luzmaximilian@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/aggregator/controller.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/surface/aggregator/controller.c b/drivers/platform/surface/aggregator/controller.c
index 30cea324ff95f..a6a8f4b1836a6 100644
--- a/drivers/platform/surface/aggregator/controller.c
+++ b/drivers/platform/surface/aggregator/controller.c
@@ -1354,7 +1354,8 @@ void ssam_controller_destroy(struct ssam_controller *ctrl)
 	if (ctrl->state == SSAM_CONTROLLER_UNINITIALIZED)
 		return;
 
-	WARN_ON(ctrl->state != SSAM_CONTROLLER_STOPPED);
+	WARN_ON(ctrl->state != SSAM_CONTROLLER_STOPPED &&
+		ctrl->state != SSAM_CONTROLLER_INITIALIZED);
 
 	/*
 	 * Note: New events could still have been received after the previous
-- 
2.43.0



