Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BCD168B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyRVClGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09552C433C8;
	Mon, 23 Oct 2023 11:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061740;
	bh=+2D8GMhpgkumZbqdLvZnhyH8hiUSPCubL8ZOx2/4GYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyRVClGzjL757wIdCSgYnEby9M49Cy+XBSdirKBsDk+aU7vO+Moq3aeNSxXxwEPsU
	 trDP2MnVNxpHcJDatXvgPslGpsBpqN2wK5rRRGlvERGsFWoDo/99Fr8N4dILPAguCG
	 ZRSfQ5PU7UVEXGCKxw8U0xOInyevK1Pi8cRQx/nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/202] drm/connector: Add support for out-of-band hotplug notification (v3)
Date: Mon, 23 Oct 2023 12:57:35 +0200
Message-ID: <20231023104830.857709106@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 72ad49682dde3d9de5708b8699dc8e0b44962322 ]

Add a new drm_connector_oob_hotplug_event() function and
oob_hotplug_event drm_connector_funcs member.

On some hardware a hotplug event notification may come from outside the
display driver / device. An example of this is some USB Type-C setups
where the hardware muxes the DisplayPort data and aux-lines but does
not pass the altmode HPD status bit to the GPU's DP HPD pin.

In cases like this the new drm_connector_oob_hotplug_event() function can
be used to report these out-of-band events.

Changes in v2:
- Make drm_connector_oob_hotplug_event() take a fwnode as argument and
  have it call drm_connector_find_by_fwnode() internally. This allows
  making drm_connector_find_by_fwnode() a drm-internal function and
  avoids code outside the drm subsystem potentially holding on the
  a drm_connector reference for a longer period.

Changes in v3:
- Drop the data argument to the drm_connector_oob_hotplug_event
  function since it is not used atm. This can be re-added later when
  a use for it actually arises.

Tested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://lore.kernel.org/r/20210817215201.795062-5-hdegoede@redhat.com
Stable-dep-of: 89434b069e46 ("usb: typec: altmodes/displayport: Signal hpd low when exiting mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_connector.c | 27 +++++++++++++++++++++++++++
 include/drm/drm_connector.h     |  9 +++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index fc06f73acd3c9..c4ed4f1b369c1 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -2514,6 +2514,33 @@ struct drm_connector *drm_connector_find_by_fwnode(struct fwnode_handle *fwnode)
 	return found;
 }
 
+/**
+ * drm_connector_oob_hotplug_event - Report out-of-band hotplug event to connector
+ * @connector: connector to report the event on
+ *
+ * On some hardware a hotplug event notification may come from outside the display
+ * driver / device. An example of this is some USB Type-C setups where the hardware
+ * muxes the DisplayPort data and aux-lines but does not pass the altmode HPD
+ * status bit to the GPU's DP HPD pin.
+ *
+ * This function can be used to report these out-of-band events after obtaining
+ * a drm_connector reference through calling drm_connector_find_by_fwnode().
+ */
+void drm_connector_oob_hotplug_event(struct fwnode_handle *connector_fwnode)
+{
+	struct drm_connector *connector;
+
+	connector = drm_connector_find_by_fwnode(connector_fwnode);
+	if (IS_ERR(connector))
+		return;
+
+	if (connector->funcs->oob_hotplug_event)
+		connector->funcs->oob_hotplug_event(connector);
+
+	drm_connector_put(connector);
+}
+EXPORT_SYMBOL(drm_connector_oob_hotplug_event);
+
 
 /**
  * DOC: Tile group
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index d6c7554f1d405..03d39532c7080 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -1030,6 +1030,14 @@ struct drm_connector_funcs {
 	 */
 	void (*atomic_print_state)(struct drm_printer *p,
 				   const struct drm_connector_state *state);
+
+	/**
+	 * @oob_hotplug_event:
+	 *
+	 * This will get called when a hotplug-event for a drm-connector
+	 * has been received from a source outside the display driver / device.
+	 */
+	void (*oob_hotplug_event)(struct drm_connector *connector);
 };
 
 /**
@@ -1612,6 +1620,7 @@ drm_connector_is_unregistered(struct drm_connector *connector)
 		DRM_CONNECTOR_UNREGISTERED;
 }
 
+void drm_connector_oob_hotplug_event(struct fwnode_handle *connector_fwnode);
 const char *drm_get_connector_type_name(unsigned int connector_type);
 const char *drm_get_connector_status_name(enum drm_connector_status status);
 const char *drm_get_subpixel_order_name(enum subpixel_order order);
-- 
2.40.1



