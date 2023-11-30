Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD24154F8F;
	Thu, 30 Nov 2023 16:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S49sYArA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66827C433C9;
	Thu, 30 Nov 2023 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361771;
	bh=qKfp1a9eXUsN4BvJ5smXDuQdX/krJ46cUrsBTzI4BbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S49sYArAtnRiZ7LqLoQYz87EpMA5ZbOD4Vxy+Wgrooguy2cRgoZwTbxcXRUPje8cI
	 bP99CyAEulXr+b42Uv52VyI7qcEJZgNpfVM1BhxnbGfCmVVWixtI3juzNaKBDdHO3E
	 IIYltNVRI9Ak6gfs4cJ4Jw9yjz9gYxHKIRj2j+xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/82] media: camss: Convert to platform remove callback returning void
Date: Thu, 30 Nov 2023 16:22:11 +0000
Message-ID: <20231130162137.230254848@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 428bbf4be4018aefa26e4d6531779fa8925ecaaf ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: f69791c39745 ("media: qcom: camss: Fix genpd cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index f7fa84f623282..04e65edbfb870 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1723,7 +1723,7 @@ void camss_delete(struct camss *camss)
  *
  * Always returns 0.
  */
-static int camss_remove(struct platform_device *pdev)
+static void camss_remove(struct platform_device *pdev)
 {
 	struct camss *camss = platform_get_drvdata(pdev);
 
@@ -1733,8 +1733,6 @@ static int camss_remove(struct platform_device *pdev)
 
 	if (atomic_read(&camss->ref_count) == 0)
 		camss_delete(camss);
-
-	return 0;
 }
 
 static const struct of_device_id camss_dt_match[] = {
@@ -1796,7 +1794,7 @@ static const struct dev_pm_ops camss_pm_ops = {
 
 static struct platform_driver qcom_camss_driver = {
 	.probe = camss_probe,
-	.remove = camss_remove,
+	.remove_new = camss_remove,
 	.driver = {
 		.name = "qcom-camss",
 		.of_match_table = camss_dt_match,
-- 
2.42.0



