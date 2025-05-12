Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9664A32;
	Mon, 12 May 2025 18:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073437; cv=none; b=NSmpIamvr2vxWQaWO/VAXATXujKCJmouBa7KP2d/BuePk0M8PV1b4arQW3jPvftlWcmgu5rSw4UujDY9Ej7WudYhl2SBKN5ezXN+GqAX1XabVVTjj43ObZWnysmlqFoWHpNPb7qxqHMYLYtswVjjupN4FIk/uAr9DJwHBU8TLLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073437; c=relaxed/simple;
	bh=5BAnoWANb+MCaQDiOigt1VfIN3V6660jL+OywbSd15I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvySTdhIJvZNvk7zCiDfKAi2m9APbxGqF3DGQgevH7Zl0GX+36/pdk6JliJmgFsO6CNbvyhxTvKkAXGkwFz9zHwz8gA2zI3WO8NROR5HXHqam0SzlHl1McJQxxWDPwIQi00ZT0OWQOP/vlnOqLjFG0vBU0EMbDNIbhFC6iuB4wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IW2lnUmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IW2lnUmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9AEC4CEE7;
	Mon, 12 May 2025 18:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073437;
	bh=5BAnoWANb+MCaQDiOigt1VfIN3V6660jL+OywbSd15I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IW2lnUmSRH2egGQ8iAK02glO9p1xJrrPSa9ICwiyHein8z88cxR9y35oc3Tb55fGs
	 B3WBD+bsGLW/CubxDJpiOx3ceEuG52zeEGiPGXi5xaGv7EAwtJRKzaX/vDhsrkqst4
	 XGkJkgj8/tNkNEe3wFdz2X7EG3XI1vy3EzTQPV1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.6 074/113] usb: typec: ucsi: displayport: Fix NULL pointer access
Date: Mon, 12 May 2025 19:46:03 +0200
Message-ID: <20250512172030.688150299@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 312d79669e71283d05c05cc49a1a31e59e3d9e0e upstream.

This patch ensures that the UCSI driver waits for all pending tasks in the
ucsi_displayport_work workqueue to finish executing before proceeding with
the partner removal.

Cc: stable <stable@kernel.org>
Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250424084429.3220757-3-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -296,6 +296,8 @@ void ucsi_displayport_remove_partner(str
 	if (!dp)
 		return;
 
+	cancel_work_sync(&dp->work);
+
 	dp->data.conf = 0;
 	dp->data.status = 0;
 	dp->initialized = false;


