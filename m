Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEAC250C09;
	Thu,  3 Apr 2025 15:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693776; cv=none; b=cXy/sKMcLHtl3tZwbr3yPQt4dX+HdD0JlCw9Epo+Y9z8BSO3tL4LvZnER9T9rWTDiU1wipyCUobWQDZTBWLRbmEbiIpDP2huYs9exu23jgY22nXNxIq/soTYzjCHs72wVE9KTsfwG3fYcEc0gqLdqXFk/FvwhchSgbaDmURL3R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693776; c=relaxed/simple;
	bh=HqzhFAgOmxuVIW7KuqSlvkzi/kFxYvVUYxwF74zN3SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjHfA5F87sKNAlK3vhPUkpcQEKUrqm76jvW+bVI9cyZ30pVQDgoT4j7Bhr/BnYqdTD0c9phr9/ZZIiy5e7flwLsr0ynV5d85mkKCJ15L17zZw5oAk+oqIhPF8B9GK9hKYGuvfle8Ab+rNgAvCSaV/dh+hbz6GNiBMQUte9poHVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skXitZ8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skXitZ8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AD0C4CEE3;
	Thu,  3 Apr 2025 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693774;
	bh=HqzhFAgOmxuVIW7KuqSlvkzi/kFxYvVUYxwF74zN3SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skXitZ8XG165TWChM/f1wut4kGsoU3/RlJhHKcgszozvLmMiWOXpWLd3QRzLMNuts
	 RCu4DZE3Cd8NzxIOYlPBi4MP0W5x/vbexOxxQJ+QtkxU5iNJ7WVBnMgO1Udk7OUmPA
	 DqQE6Igyq9tF+uH68XCueMyBCvnJjY0HGN/itKDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 20/22] usb: typec: ucsi: Fix NULL pointer access
Date: Thu,  3 Apr 2025 16:20:15 +0100
Message-ID: <20250403151621.508122640@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1313,11 +1313,11 @@ static int ucsi_init(struct ucsi *ucsi)
 
 err_unregister:
 	for (con = connector; con->port; con++) {
+		if (con->wq)
+			destroy_workqueue(con->wq);
 		ucsi_unregister_partner(con);
 		ucsi_unregister_altmodes(con, UCSI_RECIPIENT_CON);
 		ucsi_unregister_port_psy(con);
-		if (con->wq)
-			destroy_workqueue(con->wq);
 		typec_unregister_port(con->port);
 		con->port = NULL;
 	}
@@ -1479,10 +1479,6 @@ void ucsi_unregister(struct ucsi *ucsi)
 
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
 		cancel_work_sync(&ucsi->connector[i].work);
-		ucsi_unregister_partner(&ucsi->connector[i]);
-		ucsi_unregister_altmodes(&ucsi->connector[i],
-					 UCSI_RECIPIENT_CON);
-		ucsi_unregister_port_psy(&ucsi->connector[i]);
 
 		if (ucsi->connector[i].wq) {
 			struct ucsi_work *uwork;
@@ -1497,6 +1493,11 @@ void ucsi_unregister(struct ucsi *ucsi)
 			mutex_unlock(&ucsi->connector[i].lock);
 			destroy_workqueue(ucsi->connector[i].wq);
 		}
+
+		ucsi_unregister_partner(&ucsi->connector[i]);
+		ucsi_unregister_altmodes(&ucsi->connector[i],
+					 UCSI_RECIPIENT_CON);
+		ucsi_unregister_port_psy(&ucsi->connector[i]);
 		typec_unregister_port(ucsi->connector[i].port);
 	}
 


