Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869A28837;
	Mon, 28 Oct 2024 06:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098363; cv=none; b=sGMzG9T0p0EF+Bo7WjJtizS5UfDULC/wnL+/Vk2uy0aWNGEiS7AarZhfNU/y4MhvTNOJdRd0DMonLb6BiXd/T/ANo04ytdoRtnEY2PM15Ax0cSh+l8fEp1ZczHEQ4wCs+qHELIQ8okeat1zD7h+HB1raHYhX9A1om2qhZQa/b/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098363; c=relaxed/simple;
	bh=mA33uTefXfbmyP3/FV6HThqcF5LQ55IVIv+WyM9cvA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvp+ddhZNqCmLosC736KfhkUYXul7RMYDD1P5ImbYRtT5TzrsMz266w5grjCKZBi5zSfTKGjI5p0OURHGsNvhokYHz1qywGpUcX7N1Th1LzTYA7vzcMPAYl/TW9ZmyuSpn1qFzFUmNt2bbgyOAGwYFiNM8SubRam0V+OEIyagcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lppiZmOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lppiZmOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2559BC4CEC3;
	Mon, 28 Oct 2024 06:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098363;
	bh=mA33uTefXfbmyP3/FV6HThqcF5LQ55IVIv+WyM9cvA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lppiZmOkg4PCd9UCTaO3qZvhnCc6x4xZKlvFEWFOPvBDXPWW+nMvP7Gy4SMwvpTRJ
	 YUpAiSJCvcc6URuDy7dbJZRvmRrJatomCDQOeNOWpt6OF+HbK4b1nVib67kSJD/PHL
	 YNNZwbSRuvBSWoMUzPgY0GxTRtKjOhtbaoTWbVhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 193/261] powercap: dtpm_devfreq: Fix error check against dev_pm_qos_add_request()
Date: Mon, 28 Oct 2024 07:25:35 +0100
Message-ID: <20241028062316.866023167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 5209d1b654f1db80509040cc694c7814a1b547e3 ]

The caller of the function dev_pm_qos_add_request() checks again a non
zero value but dev_pm_qos_add_request() can return '1' if the request
already exists. Therefore, the setup function fails while the QoS
request actually did not failed.

Fix that by changing the check against a negative value like all the
other callers of the function.

Fixes: e44655617317 ("powercap/drivers/dtpm: Add dtpm devfreq with energy model support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20241018021205.46460-1-yuancan@huawei.com
[ rjw: Subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/dtpm_devfreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/powercap/dtpm_devfreq.c b/drivers/powercap/dtpm_devfreq.c
index f40bce8176df2..d1dff6ccab120 100644
--- a/drivers/powercap/dtpm_devfreq.c
+++ b/drivers/powercap/dtpm_devfreq.c
@@ -178,7 +178,7 @@ static int __dtpm_devfreq_setup(struct devfreq *devfreq, struct dtpm *parent)
 	ret = dev_pm_qos_add_request(dev, &dtpm_devfreq->qos_req,
 				     DEV_PM_QOS_MAX_FREQUENCY,
 				     PM_QOS_MAX_FREQUENCY_DEFAULT_VALUE);
-	if (ret) {
+	if (ret < 0) {
 		pr_err("Failed to add QoS request: %d\n", ret);
 		goto out_dtpm_unregister;
 	}
-- 
2.43.0



