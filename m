Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F0F35C694;
	Tue, 21 Jul 2026 22:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673135; cv=none; b=Jm+FfiJfqU8i4ic4IzatK9HyL5PBsOfBu1w4hzeOMAG16+v3kMQzH2o4FeY9Gquvx5ARrzyjaoSVFCKeP90DImk/9VPdiYikeFvWEQI5FKFa+fkH1DGhLPfxp0wHcvp3E3PW8wIQMw84A3yoef1IoCYicuSmvRISk8YF7Q1y8j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673135; c=relaxed/simple;
	bh=EtI/0jwsuvCXZBvJ4pgLqKLOlSu7nBKZfpoeMmCg62w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQerkklPaxZBuC2ZVxDi48KvNSviOnaN5G72GIb2HCxmNa/uMPfuNV90ivTG0kZFxDD6RclrBKWxwtsmzv/RmMd6xKVfaCRzkKHCUjPRrp4xEHL/4JV7eDMUf/9Umo8Y0elvoA8zJEg9UVKlucp5Ni0HOeYvDROfqI1nEaRNkKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=henz9Is8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="henz9Is8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266DE1F000E9;
	Tue, 21 Jul 2026 22:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673134;
	bh=mdbPtJFkVktWyb10PhOHrYaR8yDatJYHnOiwlwgLFJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=henz9Is8d1FbfLZBFtSUdcJ8Jhd7pc6Goc2fNETxKsiz/QDqHMii9Zg4hkbgtkEvH
	 7UnAlKut0eIKuD0eSRrpJj3w/rsOIykY0rmlYMSgAlNByYDPP6svrteBwrWOUKMCd0
	 Zw2WSdQgNv8gl+DG0PNtnNpU8Q0xsg4zB6/57Pt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 049/699] iio: magnetometer: ak8975: Add missed pm_runtime_put_autosuspend() call
Date: Tue, 21 Jul 2026 17:16:48 +0200
Message-ID: <20260721152356.815954924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e94944d7364d3ddb273539492f9bd9c9a622549a upstream.

On the failure in the ak8975_read_axis() the PM runtime gets unbalanced.
Balance it by calling pm_runtime_put_autosuspend() on error path as well.

Fixes: cde4cb5dd422 ("iio: magn: ak8975: deploy runtime and system PM")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260505-magnetometer-fixes-v5-0-831b9b5550fc%40gmail.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/ak8975.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -715,6 +715,7 @@ static int ak8975_read_axis(struct iio_d
 
 exit:
 	mutex_unlock(&data->lock);
+	pm_runtime_put_autosuspend(&data->client->dev);
 	dev_err(&client->dev, "Error in reading axis\n");
 	return ret;
 }


