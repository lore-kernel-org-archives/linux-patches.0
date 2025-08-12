Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4532F5E;
	Tue, 12 Aug 2025 18:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023501; cv=none; b=uAuYoxMYf/UxDXeP4JXIX84GYtgTHTyY3T2bdCnmexA42BZANxZT+uV1OjifpkzsBBj9/y7YdMrkEojHXE829qyocgqmfZB6E5DOgzYaatdDs4BS1ZJqVjOo24pXjIaZ0yHexX5aclNO2v5eQwqtftx6nkfVBQuTSx9zOuR/ypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023501; c=relaxed/simple;
	bh=Ked4EExaBuwfZDXSuVXUv6A2o5rAhMACz6fDebWYPSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCXFxnEQlQPu4rru0oluqu0QM4w+NPJaq3Gu+5/QEKF2ik3i+cxJegaYBbNRLk4SF4e4d/MXAxTKe6nopuN8U2fWhwfVZS5OETWmW+7ifYFpucP44/EyiRwLOWxVPN9n/6xlypLmKE5wJ9Vs9psMdrkmjGfTdrPKUtIjkeyN+LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjr/k8NG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjr/k8NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACEDC4CEF0;
	Tue, 12 Aug 2025 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023501;
	bh=Ked4EExaBuwfZDXSuVXUv6A2o5rAhMACz6fDebWYPSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjr/k8NGFtC0puTQQl3XWC5jOTonRGy+Axm9R/wmMoe6kORRUivck207D7mnL25iy
	 L8XxXO0VEwAdDJ5NLgkvYHhq6l/zZD+WEcKy7u4moZNFIeLVwsFjHeyHrg7rUZ4kMi
	 308nE7ns0ZzNMao212JM+3jotsdhbDxmAhc7rdXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 065/627] usb: typec: ucsi: yoga-c630: fix error and remove paths
Date: Tue, 12 Aug 2025 19:26:00 +0200
Message-ID: <20250812173421.794690419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 168c3896f32e78e7b87f6aa9e85af36e47a9f96c ]

Fix memory leak and call ucsi_destroy() from the driver's remove
function and probe's error path in order to remove debugfs files and
free the memory. Also call yoga_c630_ec_unregister_notify() in the
probe's error path.

Fixes: 2ea6d07efe53 ("usb: typec: ucsi: add Lenovo Yoga C630 glue driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250621-c630-ucsi-v1-1-a86de5e11361@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_yoga_c630.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_yoga_c630.c b/drivers/usb/typec/ucsi/ucsi_yoga_c630.c
index d33e3f2dd1d8..47e8dd5b255b 100644
--- a/drivers/usb/typec/ucsi/ucsi_yoga_c630.c
+++ b/drivers/usb/typec/ucsi/ucsi_yoga_c630.c
@@ -133,17 +133,30 @@ static int yoga_c630_ucsi_probe(struct auxiliary_device *adev,
 
 	ret = yoga_c630_ec_register_notify(ec, &uec->nb);
 	if (ret)
-		return ret;
+		goto err_destroy;
+
+	ret = ucsi_register(uec->ucsi);
+	if (ret)
+		goto err_unregister;
+
+	return 0;
 
-	return ucsi_register(uec->ucsi);
+err_unregister:
+	yoga_c630_ec_unregister_notify(uec->ec, &uec->nb);
+
+err_destroy:
+	ucsi_destroy(uec->ucsi);
+
+	return ret;
 }
 
 static void yoga_c630_ucsi_remove(struct auxiliary_device *adev)
 {
 	struct yoga_c630_ucsi *uec = auxiliary_get_drvdata(adev);
 
-	yoga_c630_ec_unregister_notify(uec->ec, &uec->nb);
 	ucsi_unregister(uec->ucsi);
+	yoga_c630_ec_unregister_notify(uec->ec, &uec->nb);
+	ucsi_destroy(uec->ucsi);
 }
 
 static const struct auxiliary_device_id yoga_c630_ucsi_id_table[] = {
-- 
2.39.5



