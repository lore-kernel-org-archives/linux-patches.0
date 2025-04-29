Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8CD227E95;
	Tue, 29 Apr 2025 17:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948656; cv=none; b=Uc/JPH+IVm9jm/RRiczWOMZFDWhgvS57b2DQOpWktLSNnweqhwBTICPJRR2JOddSdc70RlZiiXJFue6YKy0RKolCdeCGRkOwoLyRTTO4CbMZCsqnq3BBXgp5WZSXGEtjrUCo/SgufpZBos5h1NrmSfnqFhQRzP+tqMpkzkRkldg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948656; c=relaxed/simple;
	bh=hto9YNN0akj7HdX4mC123h92KHFtO9k69x45zZVqAy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKt/WyLZ/AWEVIEH6tGkc9XWZGIigHD/sH1jtd9JzzqLR/NWBDWWc9NiT6SHXVut99lXh5E1hz8N0CbLX1xrWMzM97blA53uWyUAqIGEh52GHnKH5Rp2G+cApR1+CkWEKsY08KS1NeJBN/NxFbtoUW2Okpa+vbYyxB2IH+pMv2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glN+pdmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glN+pdmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D89AC4CEF3;
	Tue, 29 Apr 2025 17:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948656;
	bh=hto9YNN0akj7HdX4mC123h92KHFtO9k69x45zZVqAy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glN+pdmdJx7reMhCeVQswMXRIjOhl7+I7XdJWwRwRE4dMnJXG8kxPxVpK1CM3HqhC
	 SMLQh6YRzlXJg10lS0TaP0Qm69mfM7CyWu815Hlv1Cuq4tfTa/YVRXnieNn+zomrDO
	 wxT+2daaVlOoVpD5X5kOFxvZOkfJrehBH+f7EU80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 073/373] media: i2c: ccs: Set the devices runtime PM status correctly in probe
Date: Tue, 29 Apr 2025 18:39:10 +0200
Message-ID: <20250429161126.148038102@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3645,6 +3645,7 @@ static int ccs_probe(struct i2c_client *
 out_disable_runtime_pm:
 	pm_runtime_put_noidle(&client->dev);
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 
 out_media_entity_cleanup:
 	media_entity_cleanup(&sensor->src->sd.entity);


