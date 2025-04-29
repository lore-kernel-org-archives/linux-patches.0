Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E560582C60;
	Tue, 29 Apr 2025 17:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946149; cv=none; b=hTP6Cl5/gOYHjbOuBxWxMHuV+mvQ9CQ9WqFS6UHwYH154mwpAsHJ9f1OHYxTixA1UTEDd+Ov21mjEro+NIPWzc8gkgS15B/ut7a7wB5H1QN25f9sYZbIYGu2PxBlPkO2s1pb1Qmhejy7G17ctljzeA9onEsryJ/8A3H+KBMwLas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946149; c=relaxed/simple;
	bh=a/OyIXTUuEMXr9SIdeywt6hVL+UlUdh5myPtHAio6/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlK8a9WIFdtGBQrUTbe+va4Q096KBxyR8Do06KkFJuZiH1IPLM9TOKt2QDclpZ60MzJFOU4DrDheIb8w5UtimsiZ26UufR+eXqUsX9Z/uPshb9xKzOZrPvNoHNuvaeYlwIshNJ1Hntm5a34Ow6TBwWwnliYY+ZyTlS3lZJUpggE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXrHl/oJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXrHl/oJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D35BC4CEE3;
	Tue, 29 Apr 2025 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946148;
	bh=a/OyIXTUuEMXr9SIdeywt6hVL+UlUdh5myPtHAio6/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXrHl/oJ+l07o2IHKhCZXpgvZCubeUpO2FkTJkDDpu5oMVkJDlH/k80aaYokrPO+q
	 vaaL9XhhoUxCVWzfoZMwqB6U2AK/czhN/5wwWzzl4ujzLQUsLpvxUx40v0IeksSn7C
	 pB2YCvUkmI97JhbOgtIXbMSzKSx8UMNH6NLThN0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.14 171/311] usb: typec: class: Invalidate USB device pointers on partner unregistration
Date: Tue, 29 Apr 2025 18:40:08 +0200
Message-ID: <20250429161128.038251891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 66e1a887273c6b89f09bc11a40d0a71d5a081a8e upstream.

To avoid using invalid USB device pointers after a Type-C partner
disconnects, this patch clears the pointers upon partner unregistration.
This ensures a clean state for future connections.

Cc: stable@vger.kernel.org
Fixes: 59de2a56d127 ("usb: typec: Link enumerated USB devices with Type-C partner")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250321143728.4092417-3-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1086,10 +1086,14 @@ void typec_unregister_partner(struct typ
 	port = to_typec_port(partner->dev.parent);
 
 	mutex_lock(&port->partner_link_lock);
-	if (port->usb2_dev)
+	if (port->usb2_dev) {
 		typec_partner_unlink_device(partner, port->usb2_dev);
-	if (port->usb3_dev)
+		port->usb2_dev = NULL;
+	}
+	if (port->usb3_dev) {
 		typec_partner_unlink_device(partner, port->usb3_dev);
+		port->usb3_dev = NULL;
+	}
 
 	device_unregister(&partner->dev);
 	mutex_unlock(&port->partner_link_lock);


