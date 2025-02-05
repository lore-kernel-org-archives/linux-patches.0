Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E19B35946;
	Wed,  5 Feb 2025 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768623; cv=none; b=V5gtx+4DbqGsWwe048H0TaPgJZ9X99SYki9YS+hhPwFX8HqBXKS2nl3wFq75Lyh5JKmwHbc9vLkcooCoygncmctoEK/X+7//STIyX79BLxCAchgvjFL4NJO5muQ0Ua/RqJnxEVHEdrg3ftXkUsWP1b4Yz6T7Zm/QlEuYsENUt0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768623; c=relaxed/simple;
	bh=Wb8wmgj+UJu8P9qWUIY1F4iwVQPe74jlgo80+Di9tcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzUL8n+w8lSUIbq8YFZIrq33/bilEgZphj8zcpxjPfNCzntToz3OHhrlbo897gXJ3w6GuME/Ya2LXUDGJAAw0HZx9XcTnRh2RBKcOBH8hXn0SGDQVACNJKm3RC4YGmXxyI8smsmF4FiUrShZxVGfYY3B3+Fr4ALjNJNAGVEMxB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgV5GCdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgV5GCdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B004C4CED1;
	Wed,  5 Feb 2025 15:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768622;
	bh=Wb8wmgj+UJu8P9qWUIY1F4iwVQPe74jlgo80+Di9tcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgV5GCdGbWYJNtYWIFeJY6NN6b0Vw1QmppX7Omi5t8STJe5KAtnZZTBGxaO4rg22P
	 vyzHbW2m5bgXXdFt7UmGHamCUEdaeOV2ti81qoNMqp/44bco+ffY3rLJjPNemm/ZAb
	 5DBYOJpaYRPUmyUQyKfbnFB4gse94AtiYnFQrXpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 610/623] media: imx-jpeg: Fix potential error pointer dereference in detach_pm()
Date: Wed,  5 Feb 2025 14:45:52 +0100
Message-ID: <20250205134519.554913302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 1378ffec30367233152b7dbf4fa6a25ee98585d1 upstream.

The proble is on the first line:

	if (jpeg->pd_dev[i] && !pm_runtime_suspended(jpeg->pd_dev[i]))

If jpeg->pd_dev[i] is an error pointer, then passing it to
pm_runtime_suspended() will lead to an Oops.  The other conditions
check for both error pointers and NULL, but it would be more clear to
use the IS_ERR_OR_NULL() check for that.

Fixes: fd0af4cd35da ("media: imx-jpeg: Ensure power suppliers be suspended before detach them")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -2677,11 +2677,12 @@ static void mxc_jpeg_detach_pm_domains(s
 	int i;
 
 	for (i = 0; i < jpeg->num_domains; i++) {
-		if (jpeg->pd_dev[i] && !pm_runtime_suspended(jpeg->pd_dev[i]))
+		if (!IS_ERR_OR_NULL(jpeg->pd_dev[i]) &&
+		    !pm_runtime_suspended(jpeg->pd_dev[i]))
 			pm_runtime_force_suspend(jpeg->pd_dev[i]);
-		if (jpeg->pd_link[i] && !IS_ERR(jpeg->pd_link[i]))
+		if (!IS_ERR_OR_NULL(jpeg->pd_link[i]))
 			device_link_del(jpeg->pd_link[i]);
-		if (jpeg->pd_dev[i] && !IS_ERR(jpeg->pd_dev[i]))
+		if (!IS_ERR_OR_NULL(jpeg->pd_dev[i]))
 			dev_pm_domain_detach(jpeg->pd_dev[i], true);
 		jpeg->pd_dev[i] = NULL;
 		jpeg->pd_link[i] = NULL;


