Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9708C18FC91;
	Tue, 12 Aug 2025 18:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022148; cv=none; b=su2T5EnOQ7JytX/Y6O98LBnWOq/1JC18nLymciWyYtyDhp0RTXYozjPaxUSTBkMOI068oyjt0O2dAM3uoIOefHdawDtmyWU4yN+DesdHow5MmtJbGAYiox6+5ol4WkJofZNQG5bCKAmDh0Fn88qRP4fy/rwdCW/hlN04BfEn/Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022148; c=relaxed/simple;
	bh=bJBTfyDhzyW4FpBoagvAoxRnIvRIYTa7Con22ehus6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NL4z8q/hhsSfx/Yocdc2oK1cjmM07nudAM270OXa/qCIrQulOpJuVv7hKdQxnd8aHQBN70gPb5RbQfilQLzh+qJeDsfs1fObH4xoemBxCL8rtagCPO/oGlcUy87vcObvssvjrtnxfhj8kky9anmA3CLmv9BbZz/v0yo5zGtEbdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJi4bgLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJi4bgLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63D0C4CEF9;
	Tue, 12 Aug 2025 18:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022148;
	bh=bJBTfyDhzyW4FpBoagvAoxRnIvRIYTa7Con22ehus6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJi4bgLeobLdevo2fGKUreaRgvQUH5Q1tekhtUnrxKZnd5MV5skhTRVUZ+59QWK86
	 pfeKa6rW/CeNkmAysmPPgBSGMMEVxPD2Ckal7mESUsuCU4z00zoN4f+4Z4lXu/0sTg
	 l5VtNGgRZb6Q/SMbDt/ybsT7r1iEymoGpwdwH0js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/369] usb: typec: ucsi: yoga-c630: fix error and remove paths
Date: Tue, 12 Aug 2025 19:25:33 +0200
Message-ID: <20250812173016.115565834@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 40e5da4fd2a4..080b6369a88c 100644
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



