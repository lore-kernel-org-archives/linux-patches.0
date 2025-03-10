Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51C81DE89C;
	Mon, 10 Mar 2025 17:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628132; cv=none; b=cQ5LwzSr+dJOQeKJi5tt3OKQ5X5hKDWelATCrvwouz7b85LZqirwBxBkbv3SBqFjXosz2QqOSAbcVvoGaqqAIqWKijxjoG16znGT9xmGPC20CjmIbYiJawVC083EPa1AWhjIhUnf6gGD71IzcBGELew357AYsqlbiWwWdz4YGgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628132; c=relaxed/simple;
	bh=dLb9hrYl3mhOOIA5ITWLDWQA7s+8RW+fsvSSi9QI3mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9U9VkT79l0DvD9CDNP6O/UwJbNyc/Uw+RriKGF5hg8bnL6K97NAGnehXM3QJlJv+sHEmf9fQf/cSHP6lf9cvQWKWksoZkmErAexnnWb1KcIWg8a0U4aPNdo8HudBWBErwZIaCmU+fgQFNzcSsFJJdAJRHcQpHmqeRqA+OHJmhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTleCsf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTleCsf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52785C4CEE5;
	Mon, 10 Mar 2025 17:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628132;
	bh=dLb9hrYl3mhOOIA5ITWLDWQA7s+8RW+fsvSSi9QI3mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTleCsf9FI2obNhng7lhZBXsMvaeFQXVEwP1Nny4XGPlvXdDnKgS/T8NcIMJ6yttB
	 UfNU3w8goDHe5A26orUDupaUwH5VAq29C9NC9M0E3fNR1em/lVOQVCpeW5XHfbzdqi
	 fKACuQbbm9V2jLCxsyzlX+8gyvQHYzVAEsMzx8lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 097/145] usb: typec: ucsi: Fix NULL pointer access
Date: Mon, 10 Mar 2025 18:06:31 +0100
Message-ID: <20250310170438.670744703@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

commit b13abcb7ddd8d38de769486db5bd917537b32ab1 upstream.

Resources should be released only after all threads that utilize them
have been destroyed.
This commit ensures that resources are not released prematurely by waiting
for the associated workqueue to complete before deallocating them.

Cc: stable <stable@kernel.org>
Fixes: b9aa02ca39a4 ("usb: typec: ucsi: Add polling mechanism for partner tasks like alt mode checking")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250305111739.1489003-2-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1465,11 +1465,11 @@ static int ucsi_init(struct ucsi *ucsi)
 
 err_unregister:
 	for (con = connector; con->port; con++) {
+		if (con->wq)
+			destroy_workqueue(con->wq);
 		ucsi_unregister_partner(con);
 		ucsi_unregister_altmodes(con, UCSI_RECIPIENT_CON);
 		ucsi_unregister_port_psy(con);
-		if (con->wq)
-			destroy_workqueue(con->wq);
 
 		usb_power_delivery_unregister_capabilities(con->port_sink_caps);
 		con->port_sink_caps = NULL;
@@ -1651,10 +1651,6 @@ void ucsi_unregister(struct ucsi *ucsi)
 
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
 		cancel_work_sync(&ucsi->connector[i].work);
-		ucsi_unregister_partner(&ucsi->connector[i]);
-		ucsi_unregister_altmodes(&ucsi->connector[i],
-					 UCSI_RECIPIENT_CON);
-		ucsi_unregister_port_psy(&ucsi->connector[i]);
 
 		if (ucsi->connector[i].wq) {
 			struct ucsi_work *uwork;
@@ -1670,6 +1666,11 @@ void ucsi_unregister(struct ucsi *ucsi)
 			destroy_workqueue(ucsi->connector[i].wq);
 		}
 
+		ucsi_unregister_partner(&ucsi->connector[i]);
+		ucsi_unregister_altmodes(&ucsi->connector[i],
+					 UCSI_RECIPIENT_CON);
+		ucsi_unregister_port_psy(&ucsi->connector[i]);
+
 		usb_power_delivery_unregister_capabilities(ucsi->connector[i].port_sink_caps);
 		ucsi->connector[i].port_sink_caps = NULL;
 		usb_power_delivery_unregister_capabilities(ucsi->connector[i].port_source_caps);


