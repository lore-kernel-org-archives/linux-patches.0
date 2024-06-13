Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE921442EF;
	Thu, 13 Jun 2024 11:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279313; cv=none; b=tfH2TJg49qOL1w0ELaZT0NN4AdNDCSC4dEuVdWbWDBBPrd7AfD7A3NrgrRel49BP9js+KBtyXE+ceCG/n7jVzcYc82jISrLUKGECtfW1fP9sXELzKmZJHZx7IsJbdMNdbe1OSYy9g+FgIh1/NEHSTCREgFHJQtp4+Yxqo9JRkPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279313; c=relaxed/simple;
	bh=cKOpXRewWpQRAU4shTGZBZZ/CCeACaYJzvAXlRe54uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TlQcfy26lzBa906XHbegLsyiPZyeilO2PZAdvZT5EE1AhNnJdn1vDOVpYzETJEZgs21dI6FZtNkJyFnPVYJkN7uJ7Q8M7Sun/Kq6Wif4Ohu0UvG4968EVA1X332KBVscUBV58jUxP8v8z0uvP0vBrjXPSSbOtBnzmdTfGZAMuMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9On4FU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9On4FU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B225C32786;
	Thu, 13 Jun 2024 11:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279313;
	bh=cKOpXRewWpQRAU4shTGZBZZ/CCeACaYJzvAXlRe54uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9On4FU2evwETyKejXeetgH/K55IhdNI5kV56LU3xZuwyc5PoPSJdhjgmqEasNQT1
	 EGrNbY5rPX56BjUnRfVUpXhXhwaiDNwdsbcwz8jKKpaRIvbvKJ+ITosCj4zNnn26nP
	 LRlPhKOo4qz/MNPAgyvW0wuJaONIMkO87x08Xh+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.9 034/157] media: mgb4: Fix double debugfs remove
Date: Thu, 13 Jun 2024 13:32:39 +0200
Message-ID: <20240613113228.736588882@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Tůma <martin.tuma@digiteqautomotive.com>

commit 825fc49497957310e421454fe3fb8b8d8d8e2dd2 upstream.

Fixes an error where debugfs_remove_recursive() is called first on a parent
directory and then again on a child which causes a kernel panic.

Signed-off-by: Martin Tůma <martin.tuma@digiteqautomotive.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 0ab13674a9bd ("media: pci: mgb4: Added Digiteq Automotive MGB4 driver")
Cc: <stable@vger.kernel.org>
[hverkuil: added Fixes/Cc tags]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/mgb4/mgb4_core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/pci/mgb4/mgb4_core.c
+++ b/drivers/media/pci/mgb4/mgb4_core.c
@@ -642,9 +642,6 @@ static void mgb4_remove(struct pci_dev *
 	struct mgb4_dev *mgbdev = pci_get_drvdata(pdev);
 	int i;
 
-#ifdef CONFIG_DEBUG_FS
-	debugfs_remove_recursive(mgbdev->debugfs);
-#endif
 #if IS_REACHABLE(CONFIG_HWMON)
 	hwmon_device_unregister(mgbdev->hwmon_dev);
 #endif
@@ -659,6 +656,10 @@ static void mgb4_remove(struct pci_dev *
 		if (mgbdev->vin[i])
 			mgb4_vin_free(mgbdev->vin[i]);
 
+#ifdef CONFIG_DEBUG_FS
+	debugfs_remove_recursive(mgbdev->debugfs);
+#endif
+
 	device_remove_groups(&mgbdev->pdev->dev, mgb4_pci_groups);
 	free_spi(mgbdev);
 	free_i2c(mgbdev);


