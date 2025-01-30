Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70A61E522;
	Thu, 30 Jan 2025 14:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247244; cv=none; b=e/rkKCnQ4shUp4AkYrNKaATLpgSxXWqYAUPriLjAkr+yH+IOBHPHCBCPsYQRnDXtuuRkMnUysKPteW7EfekyBvVi8tCd8r3fiOtGMpEqoMxAYHl+2UJu3m//6g45x6T0Fdc+sYnrJjJuiD4OLRUPKLpNSK6RnqR71jHjNUHqSyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247244; c=relaxed/simple;
	bh=8BwEabZwXBKMCuW/SF38zjG//MT3+uedWEenFBKYzKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qY8yh9nmYmx/pbbOtiQemQc/Biq88KSxVdLds0T0zsLaJTqO1zKQrrhkKi7n11XXJGRUkxgb6Uj4135RmxPJefy8+F7rvfuSb3UDHJPV3Y0FRL9bvOSaGDq86JC8WTCGJZ/qCFOh4o8Nmr04SKjCd1P27gParWkj+jTYu6Tkuqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pukIVRx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pukIVRx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8F2C4CED2;
	Thu, 30 Jan 2025 14:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247244;
	bh=8BwEabZwXBKMCuW/SF38zjG//MT3+uedWEenFBKYzKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pukIVRx+MLyMwBgpZ6cdwze1+x1bHRYF066RtFijrCLjVeX3akyfGHCr1EM9IaQA2
	 mNPn8kbhR+8fERIHsFus9Qfu9Zah31GLAhCyS+7ka5fzlnzJ7iy/3q0G13e74v+weT
	 RfCZbdguPHIhid/fA134PXR8V6vFeB9BtlK8qORM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Bin Lan <lanbincn@qq.com>
Subject: [PATCH 5.10 102/133] iio: adc: rockchip_saradc: fix information leak in triggered buffer
Date: Thu, 30 Jan 2025 15:01:31 +0100
Message-ID: <20250130140146.643583189@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 38724591364e1e3b278b4053f102b49ea06ee17c upstream.

The 'data' local struct is used to push data to user space from a
triggered buffer, but it does not set values for inactive channels, as
it only uses iio_for_each_active_channel() to assign new values.

Initialize the struct to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: 4e130dc7b413 ("iio: adc: rockchip_saradc: Add support iio buffers")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-4-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Bin Lan <lanbincn@qq.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rockchip_saradc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -254,6 +254,8 @@ static irqreturn_t rockchip_saradc_trigg
 	int ret;
 	int i, j = 0;
 
+	memset(&data, 0, sizeof(data));
+
 	mutex_lock(&i_dev->mlock);
 
 	for_each_set_bit(i, i_dev->active_scan_mask, i_dev->masklength) {


