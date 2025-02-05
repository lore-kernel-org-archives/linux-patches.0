Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA161C6BE;
	Wed,  5 Feb 2025 14:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766720; cv=none; b=kthjnbHnbUg0EonUpjiKuQqcz0RnvZK0LJcKDUWfreb8I8sUgeY4XAGCioauILzrdVo2YIV0LXK5D32FL93z+CsLftjzubBK6HOLbaPPi/N0FOgCWRr9n7vhP1NKUeK3fgltkld/jPSdWFQhY12j9pk4ifTCjf/iF8tu8w+z2Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766720; c=relaxed/simple;
	bh=M0E3M2C6RH/guAGc5XCPjNBXe/+5sT/Ianfv6aoxVno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eve9z5Uhmz8kx1nP+LH5Cio0aUMRbTi67DeLBIxKKUztd4DXekIYsEcXZ5x/+hnzQwx4V64yeJIXtgqSrX3IHHgNKQt1SNFP4GhoiJhDnylYA+j79czlm+Nh1QfhPpSt+c4UjfC7Gm1c2Gtz/q8lbo7LXpEP++e8bB+men3UMpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlz9o53H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlz9o53H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D8AC4CED1;
	Wed,  5 Feb 2025 14:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766720;
	bh=M0E3M2C6RH/guAGc5XCPjNBXe/+5sT/Ianfv6aoxVno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlz9o53HcD+Wqq8ugwDZ9CZI900MuN8qrZDnEFO55LssjAJ3Ui7+AMenkaX3hcHbf
	 HKNelI2FBAo9X6d6AMp9uz3P/+9LDuaRg5t8hfbPCIqJdgSPzomRA6E24Zd00om52v
	 ftFXMBaYM3ThRJlU7ka3iYNwkuDdO4TRrkedQzv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 390/393] media: imx-jpeg: Fix potential error pointer dereference in detach_pm()
Date: Wed,  5 Feb 2025 14:45:09 +0100
Message-ID: <20250205134435.217145426@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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
@@ -2674,11 +2674,12 @@ static void mxc_jpeg_detach_pm_domains(s
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


