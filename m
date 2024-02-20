Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAE91509AC;
	Tue, 20 Feb 2024 21:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463799; cv=none; b=fwLWVjriuu23adoTMfzZe8mMz+QFybkuENfx6AxV6bDtg/2zxEYrWwYR40GHbkSWLlAOAsZ3jVXJ5rN09dZvloMvg1LMJIKH2qZxOcTRIKNCz9kd4/+jwOZ+1Qv4FADDnZT2Hxbb+nQAp0KqcsW1g452/kNO+D+5n2mfGodruW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463799; c=relaxed/simple;
	bh=XGxBttiSt+pPCrYx/aXUPnNg35Q6Gc2zag7kqLaiK0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHewn+YE5zI37Js3gicCWp+5Ol0qksYtJiEpEonAZzLNTPr76Q1VO0PaDWkIOMMDZXG7tuQtdD3d6CT9GrZJGTSsWUjucZk+dUYYgK+FwzE+M7L4/VZ4qe27511fK3rlLupfDcaqJ19GvrVbTAGeYeVULZAgEHLyppuOI2ujSm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOV+rnvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOV+rnvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D3AC433C7;
	Tue, 20 Feb 2024 21:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463799;
	bh=XGxBttiSt+pPCrYx/aXUPnNg35Q6Gc2zag7kqLaiK0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOV+rnvzs+5TRuPnCw+e9Eki7/LYvWglSkECn0H/f49ipsiYNfxfLUYD208wXXZUm
	 SFWVZWfKqqSwGYbWThk5QIzqIcX5gOKC/nssfhqk10oU6a0ux6HMOCi/6m9brGMqKI
	 qxNWSI0mdERU2IhNxL2VfsCJaf95cICZuEocZQI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 157/331] iio: core: fix memleak in iio_device_register_sysfs
Date: Tue, 20 Feb 2024 21:54:33 +0100
Message-ID: <20240220205642.458128152@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1577,10 +1577,13 @@ static int iio_device_register_sysfs(str
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
 


