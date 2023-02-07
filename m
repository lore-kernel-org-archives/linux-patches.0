Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60652C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D16CC433EF;
	Tue,  7 Feb 2023 13:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775169;
	bh=EgTfjRlPyeWxVC28WpWmcHYUzRvZoc1zyJZ/O57LTqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxiwRVxJTYDhzNA4mfuZgoynVD+xwkSIiYJplwTjh894vtNNbxpsKzJ2qWbPmfYTi
	 5doBcjgw/DazhzbxtleGE64tTBIWdN/KOR1F46RNt3H5Qn2RYwLOy8R6l5Pl7qRLav
	 WccWoYfzkwJrgfI4ssWW6h8OR+/ObaMrXxPxcNh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 160/208] usb: typec: ucsi: Dont attempt to resume the ports before they exist
Date: Tue,  7 Feb 2023 13:56:54 +0100
Message-Id: <20230207125641.680021040@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit f82060da749c611ed427523b6d1605d87338aac1 upstream.

This will fix null pointer dereference that was caused by
the driver attempting to resume ports that were not yet
registered.

Fixes: e0dced9c7d47 ("usb: typec: ucsi: Resume in separate work")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216697
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230131141518.78215-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1269,6 +1269,9 @@ err_unregister:
 		con->port = NULL;
 	}
 
+	kfree(ucsi->connector);
+	ucsi->connector = NULL;
+
 err_reset:
 	memset(&ucsi->cap, 0, sizeof(ucsi->cap));
 	ucsi_reset_ppm(ucsi);
@@ -1300,7 +1303,8 @@ static void ucsi_resume_work(struct work
 
 int ucsi_resume(struct ucsi *ucsi)
 {
-	queue_work(system_long_wq, &ucsi->resume_work);
+	if (ucsi->connector)
+		queue_work(system_long_wq, &ucsi->resume_work);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ucsi_resume);
@@ -1420,6 +1424,9 @@ void ucsi_unregister(struct ucsi *ucsi)
 	/* Disable notifications */
 	ucsi->ops->async_write(ucsi, UCSI_CONTROL, &cmd, sizeof(cmd));
 
+	if (!ucsi->connector)
+		return;
+
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
 		cancel_work_sync(&ucsi->connector[i].work);
 		ucsi_unregister_partner(&ucsi->connector[i]);


