Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182636FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF96C433EF;
	Mon,  3 Apr 2023 14:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532078;
	bh=7ZLqVzlEr7pzg5uhbRwxwwPiQrohEYhGkZAaRG98K8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D42RGmIuhrSRBlpgxiZGg39cVProqUhi/EMfPlaWiQBMg6ZCf/l4qLDcxRriRGLNp
	 3NhkQD0pUJ/nFX1e9NjN1v9w9x6TfYBO5pnhe41ZRmJjwH6SQQQBa/U0VGE9D1UTLx
	 1EX3nN0y0zHKrH2vREwvbYCaclXejuOqBR9Oxox8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 087/173] usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()
Date: Mon,  3 Apr 2023 16:08:22 +0200
Message-Id: <20230403140417.251956634@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit f87fb985452ab2083967103ac00bfd68fb182764 upstream.

When ucsi_init() fails, ucsi->connector is NULL, yet in case of
ucsi_acpi we may still get events which cause the ucs_acpi code to call
ucsi_connector_change(), which then derefs the NULL ucsi->connector
pointer.

Fix this by not setting ucsi->ntfy inside ucsi_init() until ucsi_init()
has succeeded, so that ucsi_connector_change() ignores the events
because UCSI_ENABLE_NTFY_CONNECTOR_CHANGE is not set in the ntfy mask.

Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217106
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230308154244.722337-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1152,7 +1152,7 @@ out_unlock:
 static int ucsi_init(struct ucsi *ucsi)
 {
 	struct ucsi_connector *con;
-	u64 command;
+	u64 command, ntfy;
 	int ret;
 	int i;
 
@@ -1164,8 +1164,8 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Enable basic notifications */
-	ucsi->ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
+	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_reset;
@@ -1197,12 +1197,13 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Enable all notifications */
-	ucsi->ntfy = UCSI_ENABLE_NTFY_ALL;
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ntfy = UCSI_ENABLE_NTFY_ALL;
+	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_unregister;
 
+	ucsi->ntfy = ntfy;
 	return 0;
 
 err_unregister:


