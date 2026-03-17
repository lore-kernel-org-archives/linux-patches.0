Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996142FFDEA;
	Tue, 17 Mar 2026 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766965; cv=none; b=U0N412p2pk6GG4rHQ32YdryKChIEwrQ7lRsMS7yBhtxiaoOfRoYgBfXIstRHOSqLlyw2YebhGWa5FdfaS0QdLy0OyqKzDMiiUpi6HlGBhVtMTIoyVeP/CSoRgBvwAFPOfDoJfhhzYJW28lnCjeZZJMCahZHJZ4rfN8fC1o0860A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766965; c=relaxed/simple;
	bh=VqCfk3xc55naKq87WAQ3YyKBeNDBS2YghXx4Ar5kypc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/DqX/JwuSg+UoPXjlf8fsImPtwfpFrWZdipzSUbSrbjhbM7kX88SSK6BcnaKZ341BcxRezQ6cRBG1ViX6SvxYQPmEs3mUOOBq1n5ZIL4ObQcDVI+h+gq/ybDdJbyYFHMTDqISH7LFse+KQ7qS4yL7+HLbJ1ypuhVgbsBUG1jWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srUUOtd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srUUOtd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001BEC4CEF7;
	Tue, 17 Mar 2026 17:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766965;
	bh=VqCfk3xc55naKq87WAQ3YyKBeNDBS2YghXx4Ar5kypc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srUUOtd+LfOq6+DyUyyaMBxZKhwgauko2dY2jXrx6GGWSwfIIiMf4RZueEU4R9TGp
	 gjLfph5FDOr/yiFMdCqUXNNZVjt9Gqnlue5RPtd/e7iHMbvJlVcrFvd2pIQ329qgnB
	 +uV3urrpMx5LjC3nTu+c1czPUnIKMXk7CMBNDKfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasin Lee <yasin.lee.x@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 362/378] iio: proximity: hx9023s: fix assignment order for __counted_by
Date: Tue, 17 Mar 2026 17:35:19 +0100
Message-ID: <20260317163020.298078152@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasin Lee <yasin.lee.x@gmail.com>

commit 585b90c0161ab77416fe3acdbdc55b978e33e16c upstream.

Initialize fw_size before copying firmware data into the flexible
array member to match the __counted_by() annotation. This fixes the
incorrect assignment order that triggers runtime safety checks.

Fixes: e9ed97be4fcc ("iio: proximity: hx9023s: Added firmware file parsing functionality")
Signed-off-by: Yasin Lee <yasin.lee.x@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/hx9023s.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/proximity/hx9023s.c
+++ b/drivers/iio/proximity/hx9023s.c
@@ -1034,9 +1034,8 @@ static int hx9023s_send_cfg(const struct
 	if (!bin)
 		return -ENOMEM;
 
-	memcpy(bin->data, fw->data, fw->size);
-
 	bin->fw_size = fw->size;
+	memcpy(bin->data, fw->data, bin->fw_size);
 	bin->fw_ver = bin->data[FW_VER_OFFSET];
 	bin->reg_count = get_unaligned_le16(bin->data + FW_REG_CNT_OFFSET);
 


