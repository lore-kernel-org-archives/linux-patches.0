Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258C1151CDD;
	Tue, 20 Feb 2024 21:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463085; cv=none; b=F4mQyrDUw3iHRLIuH2X3JirDB7omJbnze4BvwMyX3JxWKlPDZp0OL1zqglaEZfexXMDzljj7PabfhlMos0fB/t5brijxcP4gWXQjgbKoZRHUumNKpeYXuVVIHgGiOxjDbr0JI5ThlcvGxYNUqlGuZWDwsf5cYF282jya9pE57R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463085; c=relaxed/simple;
	bh=Th2y/2gnK8/j1D84DdIcQO7CZ19hMqosc3aupLPgb44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMKW98tDYLP4X2eRp5ep4Al2XaYyHdZBij8EpCNnBUlpvwvyyf3eDlYiru+s8CMUQrMNV7Fb920WWqvdyuNIAP7b1qhmf4BrE4ZhSGCq5VBG4sz8SF+gCyKCEcEEJY5XkZmnkyg9YrA1p5lpXIRwiCWpQF6bQaHACwvwCx64O5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zfqi8Zu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zfqi8Zu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8545DC433F1;
	Tue, 20 Feb 2024 21:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463085;
	bh=Th2y/2gnK8/j1D84DdIcQO7CZ19hMqosc3aupLPgb44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zfqi8Zu3ZIBLI0iFDBb2Fx+y12qmLMCKVcXAAUdsoXrFTEGll1qaeGfKO6WuuygcA
	 G+vrRWrv0V3EGDWKkOa8B+ylWRQ+SvjLTAktTNuQGa3yaGjcG5j17TZr01pUvFIKoD
	 fh1x406fahXN28IHvBlbqQ4AXdU4g18s0XEjRp+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 103/197] iio: core: fix memleak in iio_device_register_sysfs
Date: Tue, 20 Feb 2024 21:51:02 +0100
Message-ID: <20240220204844.166123682@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1601,10 +1601,13 @@ static int iio_device_register_sysfs(str
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
 


