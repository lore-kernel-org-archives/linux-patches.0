Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883B427CB12;
	Wed, 23 Apr 2025 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420960; cv=none; b=BStvFiK/baz2ADhm2nZ7UF4MPGmO16KM/Mmz2ZFV8YBdYKW5upm8Qw6EN2IWPOedmr1+fp9N36qT7Pknx9j12gng+Xu3bvXDV2HI1erkGSYKq6L/CZUGREpDS1QYcv6CNFwXjcT4stGYk2UgMgrk5jKkfD5LjvIGYLHji08uM10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420960; c=relaxed/simple;
	bh=YHAqohmTYkpP98Y57k6hqv7EmNFaUw2RBPDxUBcdU2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZ/s2BpbrV7o891PaixwLuYS2f8DfbRMOV+EQUbjJVxUN74G4E8em4TrFYYCj/nKKdUqfaPkbC2nnc4UotYjcrdbjGLIMwN7V7ju7blcR7KplUNS5aXDQ8YIMN92GdksXX6AcjDq1HyCy8hWrvMOKAC35EeQe+0W6QwCyHTOT7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gTD/+AR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gTD/+AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136FDC4CEE3;
	Wed, 23 Apr 2025 15:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420960;
	bh=YHAqohmTYkpP98Y57k6hqv7EmNFaUw2RBPDxUBcdU2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gTD/+ARkrJNLrxR89vkXUF2Y3Ri7jDdtn1ZGrzr8SxZB97RwfQ59WrT4oaSqLw3k
	 S5NXchr3iGMsOmpPxeq+FQ5XnZRdUr7p7e+SFSyy18WRfIs0Vgh6i1pX9Mdk1hxV82
	 gtXyVe44cfMfoFpeKOAmmnC1c1eIBTDAlNIpNFFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 096/291] media: i2c: ccs: Set the devices runtime PM status correctly in probe
Date: Wed, 23 Apr 2025 16:41:25 +0200
Message-ID: <20250423142628.279425259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 80704d14f1bd3628f578510e0a88b66824990ef6 upstream.

Set the device's runtime PM status to suspended in probe error paths where
it was previously set to active.

Fixes: 9447082ae666 ("[media] smiapp: Implement power-on and power-off sequences without runtime PM")
Cc: stable@vger.kernel.org # for >= v5.15
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3642,6 +3642,7 @@ static int ccs_probe(struct i2c_client *
 out_disable_runtime_pm:
 	pm_runtime_put_noidle(&client->dev);
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 
 out_media_entity_cleanup:
 	media_entity_cleanup(&sensor->src->sd.entity);


