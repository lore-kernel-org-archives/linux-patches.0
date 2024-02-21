Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BCF7D413;
	Wed, 21 Feb 2024 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523389; cv=none; b=HZTa5ELpBw+0cDqjg9APbObtgLA/vJ2qtoOfIWRuTbk0ikR/VbpwPuxtGnpRDczvlLo8XY6A+8hNUs1XuKe9qEfSMRKNUagPrzpzH4b00BdgvNvYY6QrZdS6VqvOA42XaGohkcSxqtpICHXknKNK5us+Ngd1NByOFfdd7sOeUB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523389; c=relaxed/simple;
	bh=tGLdCcLhl0CI4ZPqYuC0oUxCnlXGolu/vywiDDusxU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7B94Pwsgh6yf+H+49P9vQ8iCdeZl5hIA+3hlDccyN9720+Xu6nTeQ9K3NOTAbvrtR5qck2TGrGMdsfsWeyO/h9wWeunjmRPOtd0ur3Rx6P4WDZsskJJ1H2Of/fWhJbXOZpNlQa7PA4y/83pXo+Pax5fUBBY+UgCj53puUBxmKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaoGwaNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaoGwaNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65C5C433C7;
	Wed, 21 Feb 2024 13:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523388;
	bh=tGLdCcLhl0CI4ZPqYuC0oUxCnlXGolu/vywiDDusxU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaoGwaNHkHnft/9un5DqdXqP9qfZoN+B34fOUyc7yTxwyFdjhGZg9W68BsmUaP1fW
	 9nkClBJhQ4VxW/kpZDqEDQBwAKu/isySRndeooS6kvdWarEHzYbDoyGrMVFcD7tsau
	 ephYw8mgiKFDDxvIQIT6fktlkP5/O3/0jwBk7bx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 393/476] iio: core: fix memleak in iio_device_register_sysfs
Date: Wed, 21 Feb 2024 14:07:24 +0100
Message-ID: <20240221130022.548639330@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1610,10 +1610,13 @@ static int iio_device_register_sysfs(str
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
 


