Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848AC33A6EB;
	Fri,  9 Oct 2026 14:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556172; cv=none; b=iJ+iO0Zu5YJWrydcnwP+fLsp63tBismRvAzWfPYOOnioxbAlJ4XnvgJKtMYlTV0KsCjegYHc0L1uIBKcAr/RktLkfA6+F9uR2DXN4mIh+gfwTxQdbxB6j/6e3w9ENeLPr37sMBpsTf/W0IRMjKwQvwu3cvSruB9RG+FhzPgKjAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556172; c=relaxed/simple;
	bh=A4nNwKxu9xP8lW3ZfkvgIunUpespwp1LOMwUk9EmtN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnrwP4IdX5rX+lSHCTmOuwEJ6+rkw+fMoOiWMJnDg8Sd4FckQZkf72OHrbTZp3JXWQxBQODTsIusBUutpSSvskP+44blGUYUrq6BP9HqCtYvCO6q79cK6pI7OwZUavf7PdFMWMG4VkLaGPTsaObeZBqKy95JjO8piOzZRMUh4W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0EtPmtn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0EtPmtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14BB1F000FF;
	Fri,  9 Oct 2026 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556170;
	bh=ICs5W5MNjDsU6r8sM3bOXB8ImMc6yIWHYQViwZI9bZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0EtPmtnGcXQRZfvYydL/1WDb9br6Ut3Eq1lhkqjL45pBKTVwh6qyci4X+p7njCzm
	 FZ718S/S3ZL5LpQQrgmgCjYKQoXrqEJ2UNhbEiw5Q34GHg9Pu3G/cFyrPrlI1lYcXa
	 tPH6Cf/zQ0LCrJYPUUw35/RYyaxrmOrllA5cFSu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 185/403] usb: typec: ucsi: glink: fix use-after-free of ucsi on remove
Date: Fri,  9 Oct 2026 16:09:06 +0200
Message-ID: <20261009140956.449384751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 63b269ec537dc0fd26d0bd64872c26860d108c9d upstream.

The pmic_glink client is released by the devres cleanup, which runs
after pmic_glink_ucsi_remove() has returned, so its notification
callbacks can queue work until then. Work that runs after
ucsi_unregister() has been called touches freed state: it dereferences
the connector array that ucsi_unregister() freed, or registers and
unregisters the instance a second time.

Disable both work items with disable_work_sync() before unregistering,
and unregister only if the instance is still registered.

This issue was found by an in-house static analysis tool.

Fixes: 62b5412b1f4a ("usb: typec: ucsi: add PMIC Glink UCSI driver")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:gpt-5.6
Link: https://lore.kernel.org/r/20260227190430.889-1-nathan.c.rebello@gmail.com
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260908060216.616045-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -302,6 +302,10 @@ static void pmic_glink_ucsi_destroy(void
 {
 	struct pmic_glink_ucsi *ucsi = data;
 
+	/* Drain the work items before ucsi_destroy() frees the ucsi instance */
+	cancel_work_sync(&ucsi->notify_work);
+	cancel_work_sync(&ucsi->register_work);
+
 	/* Protect to make sure we're not in a middle of a transaction from a glink callback */
 	mutex_lock(&ucsi->lock);
 	ucsi_destroy(ucsi->ucsi);
@@ -403,8 +407,15 @@ static void pmic_glink_ucsi_remove(struc
 {
 	struct pmic_glink_ucsi *ucsi = dev_get_drvdata(&adev->dev);
 
-	/* Unregister first to stop having read & writes */
-	ucsi_unregister(ucsi->ucsi);
+	/* Callbacks can queue work until devres releases the client */
+	disable_work_sync(&ucsi->notify_work);
+	disable_work_sync(&ucsi->register_work);
+
+	/* register_work may have unregistered the instance already */
+	if (ucsi->ucsi_registered) {
+		ucsi->ucsi_registered = false;
+		ucsi_unregister(ucsi->ucsi);
+	}
 }
 
 static const struct auxiliary_device_id pmic_glink_ucsi_id_table[] = {


