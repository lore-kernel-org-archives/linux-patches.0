Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0208E4C83
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD32C433D2;
	Mon, 16 Jan 2023 16:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886756;
	bh=mfN5r+JxwasUEI9WRofd/S3oGzT3yxL1/sDsOtRFc2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwAWnfa0beGxXvvz76vELX70FsoAPCplBE0IuEHmUL8dOgxx0oPkgz7CeThD1lpiK
	 8FNIsPO1gfM1JI3YC0JlAteQ9IcjrWegUujlR15wM1c+NE6V1VtFY7xSauK5CMdpw1
	 hOLICnbxFjnL7ZZI5p/r7hyN3W/BVd4jjx22Sfq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Ser <contact@emersion.fr>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Lyude Paul <lyude@redhat.com>,
	=?UTF-8?q?Jonas=20=C3=85dahl?= <jadahl@redhat.com>
Subject: [PATCH 5.4 520/658] drm/connector: send hotplug uevent on connector cleanup
Date: Mon, 16 Jan 2023 16:50:08 +0100
Message-Id: <20230116154933.318716679@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Simon Ser <contact@emersion.fr>

commit 6fdc2d490ea1369d17afd7e6eb66fecc5b7209bc upstream.

A typical DP-MST unplug removes a KMS connector. However care must
be taken to properly synchronize with user-space. The expected
sequence of events is the following:

1. The kernel notices that the DP-MST port is gone.
2. The kernel marks the connector as disconnected, then sends a
   uevent to make user-space re-scan the connector list.
3. User-space notices the connector goes from connected to disconnected,
   disables it.
4. Kernel handles the IOCTL disabling the connector. On success,
   the very last reference to the struct drm_connector is dropped and
   drm_connector_cleanup() is called.
5. The connector is removed from the list, and a uevent is sent to tell
   user-space that the connector disappeared.

The very last step was missing. As a result, user-space thought the
connector still existed and could try to disable it again. Since the
kernel no longer knows about the connector, that would end up with
EINVAL and confused user-space.

Fix this by sending a hotplug uevent from drm_connector_cleanup().

Signed-off-by: Simon Ser <contact@emersion.fr>
Cc: stable@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Jonas Ådahl <jadahl@redhat.com>
Tested-by: Jonas Ådahl <jadahl@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221017153150.60675-2-contact@emersion.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_connector.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -474,6 +474,9 @@ void drm_connector_cleanup(struct drm_co
 	mutex_destroy(&connector->mutex);
 
 	memset(connector, 0, sizeof(*connector));
+
+	if (dev->registered)
+		drm_sysfs_hotplug_event(dev);
 }
 EXPORT_SYMBOL(drm_connector_cleanup);
 


