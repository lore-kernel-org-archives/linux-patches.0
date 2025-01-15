Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147B6248BAF;
	Wed, 15 Jan 2025 11:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938821; cv=none; b=aA/CK7clNvAyvwc1V3AbR1dCpd/WeiHjG2QUWpkCLJbkdD8Ip//Rsl63bZILumyzPUrxVkRikFkELT6op9ZgSHDC0I5yA8f/HshCDvnTmjFaihSlJN5x+WlBf8/cFg+/b/OGKHLAlD4AUlT+wV67haBDYBceVrzGtt8OYzw+pRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938821; c=relaxed/simple;
	bh=AVBvxcJ9ZBnynltISBPXCt8n731P9NJAcjc97FNniv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xj2Jen5BXPj9xBwDApSuXTRYfl9SIQEqYlO92Zc+B0RtW8sHyvAH/tQzDrzBSdiRf262yXKQ0JUZGLIAEGfr6g3oI4aC8w4YOiZSuJILHKjrawQkQD7KPxyTf665z30lGmSbU5gBM2xB7aFxTRDYJvXKS4yv99VM2NlRI5cSeGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUMl+gJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUMl+gJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F332C4CEE2;
	Wed, 15 Jan 2025 11:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938820;
	bh=AVBvxcJ9ZBnynltISBPXCt8n731P9NJAcjc97FNniv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUMl+gJt77xY3YrdYTnFUYF6sUpDBimMa6vmj+2yygHLTDvHj3ndHgDbilji1t1nS
	 sVUX3VlWcnJ9GtxiYkGWfBII7UlVVXvewdlrZq9a2MFyc3CN31z0I3Njp0JbzWH52I
	 ynhO6Wb5DEbLT2aR+851HcMVjZrI8pxT29SGJhwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 106/129] iio: adc: rockchip_saradc: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:38:01 +0100
Message-ID: <20250115103558.580739894@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rockchip_saradc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -368,6 +368,8 @@ static irqreturn_t rockchip_saradc_trigg
 	int ret;
 	int i, j = 0;
 
+	memset(&data, 0, sizeof(data));
+
 	mutex_lock(&info->lock);
 
 	for_each_set_bit(i, i_dev->active_scan_mask, i_dev->masklength) {


