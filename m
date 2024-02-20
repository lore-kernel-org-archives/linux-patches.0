Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127914A4D2;
	Tue, 20 Feb 2024 21:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464890; cv=none; b=S7EHbt5O8u0hckIr7OlK9GSZOE4JbdybzD5WBF+xpR6b3QQsVPSXMCuq7g0PbKnArE15M/GQV1Q3ilWnsO6jyxmlbe5BaOlQj4NwgnC6qLCfyUq4Gb4xcY73GltJyTeGc9+DrRPQdSNmK9mcDoEPEuPO0eNHs/Pq9Ib3R8DqKL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464890; c=relaxed/simple;
	bh=6u4AwPqcukhubcL3mA9sMqNG6PDszuIiropBbY4MoZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiBlSClXByUwuc+oZSCOYFP/wWs1ygJujliYwG661MluEZPuv8e4zg7IIVq3UPSgFVmDdKav9L5x+oJqbFQqDpO5SiSPTj7LbK/Jj1G7vSB8xoHxrhaoo2i/KBb3XorGBxv41b950R0ybf37E4YZy1JZL4j7v3nstzVUU82zSgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aiJ9PgDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aiJ9PgDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E49C433C7;
	Tue, 20 Feb 2024 21:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464890;
	bh=6u4AwPqcukhubcL3mA9sMqNG6PDszuIiropBbY4MoZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aiJ9PgDrFtQX9EP2AIRT5ZTzbNcl2cRdCcR1YqvmvpITC5jdQRIt6sXfcRNUQSQ0r
	 GAWKHfYCYEBHFx1qEY2zDjvdVYfmxl/sbrQYtqO1AxS+HZgfT4ArC26JLIzmNW6MPu
	 GvIJpu/APPsyLTMtl8CBK/mwLbfuGT0BH5xqfyUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 170/309] iio: core: fix memleak in iio_device_register_sysfs
Date: Tue, 20 Feb 2024 21:55:29 +0100
Message-ID: <20240220205638.466989928@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 95a0d596bbd0552a78e13ced43f2be1038883c81 upstream.

When iio_device_register_sysfs_group() fails, we should
free iio_dev_opaque->chan_attr_group.attrs to prevent
potential memleak.

Fixes: 32f171724e5c ("iio: core: rework iio device group creation")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20231208073119.29283-1-dinghao.liu@zju.edu.cn
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1581,10 +1581,13 @@ static int iio_device_register_sysfs(str
 	ret = iio_device_register_sysfs_group(indio_dev,
 					      &iio_dev_opaque->chan_attr_group);
 	if (ret)
-		goto error_clear_attrs;
+		goto error_free_chan_attrs;
 
 	return 0;
 
+error_free_chan_attrs:
+	kfree(iio_dev_opaque->chan_attr_group.attrs);
+	iio_dev_opaque->chan_attr_group.attrs = NULL;
 error_clear_attrs:
 	iio_free_chan_devattr_list(&iio_dev_opaque->channel_attr_list);
 


