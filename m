Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE27934DCED;
	Tue, 26 Aug 2025 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218395; cv=none; b=jmt4MKfk+mqUm6Es5x47rBwVCXC/S0JTGT5j1RA9rWJxcDuU5jmCgEpf3ez3UJm88rFX5H1KMf1WKRcos4oLSc9DXgGiNyIP7YTIXd6MrIrrRZL8RPFrkaPY5MBaAy4y5xeI5/zSDSa1Yy4OeL8SeDkGm0NZPy5apxWjJ9BlOeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218395; c=relaxed/simple;
	bh=n7ArLlq84bq4N8GgURqqXMJcfeKe9G9f9lvhwldM+Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPJmNlTbijpcf+MTMLIiXSFZ7vmrrcDFpOPLGLkUCAKm7PnzLKve2VjZxaQ6UPaWVSAcSLztFhFLGyvpth3FTYe+OiabeNuYycznzu5NdzsTOshqrgMayrgnWPqpEQrfEtgj85uKejOXckvXwdYOLN8cyRcI3zB/bzsbodjdcds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijO5kIdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijO5kIdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83459C4CEF1;
	Tue, 26 Aug 2025 14:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218394;
	bh=n7ArLlq84bq4N8GgURqqXMJcfeKe9G9f9lvhwldM+Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijO5kIdMLqgwOK3UJ/4IiEBkej8tPb+S+2EAxxcDrSp0HklVzRWo76i72uzjdBW+l
	 0nzJ0ztp1B++4Rd5N1TdqSjAWv0YOTKfwktI24ii3dyBwyzxffM9/yQsIwjSQbizaC
	 hedRMVcQPxhsLeoWHvHHsfVYc6Tdzoy19Y7Ac61I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 475/523] platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()
Date: Tue, 26 Aug 2025 13:11:25 +0200
Message-ID: <20250826110936.161659241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit e2374953461947eee49f69b3e3204ff080ef31b1 ]

The blocking notifier is registered in cros_ec_register(); however, it
isn't unregistered in cros_ec_unregister().

Fix it.

Fixes: 42cd0ab476e2 ("platform/chrome: cros_ec: Query EC protocol version if EC transitions between RO/RW")
Cc: stable@vger.kernel.org
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250722120513.234031-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -292,6 +292,9 @@ EXPORT_SYMBOL(cros_ec_register);
  */
 void cros_ec_unregister(struct cros_ec_device *ec_dev)
 {
+	if (ec_dev->mkbp_event_supported)
+		blocking_notifier_chain_unregister(&ec_dev->event_notifier,
+						   &ec_dev->notifier_ready);
 	platform_device_unregister(ec_dev->pd);
 	platform_device_unregister(ec_dev->ec);
 	mutex_destroy(&ec_dev->lock);


