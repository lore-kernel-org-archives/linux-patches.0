Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2526C8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF51C433EF;
	Tue, 28 Mar 2023 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015853;
	bh=K8t67b16RduZcT58uCm49L3jtQMJIYiIG6ht8UGyt+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbMhVgRXRhwS9mRrpFdQQk1Vm/ErS+HgNqCNrFa066nz4wdCze2SOETPjRg+qCIDC
	 fa4vkCIIMpOFls66OH3gX3AAHL2TGUFHUMSWOJMrWX6ro/BtB3ODavuRyJSv9kTWxa
	 38tyQXazDtOEnjiBSebbopnxMIpJkcCsV/Y6dx7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 182/224] usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()
Date: Tue, 28 Mar 2023 16:42:58 +0200
Message-Id: <20230328142624.970389086@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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
@@ -1205,7 +1205,7 @@ out_unlock:
 static int ucsi_init(struct ucsi *ucsi)
 {
 	struct ucsi_connector *con;
-	u64 command;
+	u64 command, ntfy;
 	int ret;
 	int i;
 
@@ -1217,8 +1217,8 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Enable basic notifications */
-	ucsi->ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
+	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_reset;
@@ -1250,12 +1250,13 @@ static int ucsi_init(struct ucsi *ucsi)
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


