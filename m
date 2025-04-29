Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FBF24113C;
	Tue, 29 Apr 2025 17:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947242; cv=none; b=UKSR7mYaj4+oHE8gFZNViskkuC/8+qVdd3CfNDoL75A5c6Ub4V32Tpfjb0WlVxtKeXOSNydPFMh76jFCDxaHR1bPvh6fagyue/rTx7w9lEDc/XHBCoU05/EdR48J5rz+TJFbnjszeUNOugRqTGh8x8UW41F693D8rVq8nvxS/co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947242; c=relaxed/simple;
	bh=oD6illkdvW3KD55zf/rxCAWDK53duk+j8gPwu1QTD4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H9E0QrvWMlrCuzZP8LoVSG9kq/WyKvjVxKxO1eGn8OX6w39/bKkjo0R8qoCM4GvO3o44ia/SvmRPcSXiMd/q8JFujkj5dn+XiLqBjPrD88TBzwhZSMcPMrWatc8kWzCEMPHN5qoRx4c6C/B5uNy3jpuycd4NsTo+KeGi/MUr87c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpBShFia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpBShFia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA5BC4CEE3;
	Tue, 29 Apr 2025 17:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947242;
	bh=oD6illkdvW3KD55zf/rxCAWDK53duk+j8gPwu1QTD4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpBShFiaLi22eSF5xOnrm6XdL1TTlylzLH0Fhwrf9LxY5W2yhxKUgVik+j3pW3U3z
	 XLgIndVRkmtzjuG8Kx/0Tu5FVKYSizKXMJCgDmDOYE6ydztZRZXURFIl3Yiwb7Qn10
	 /LIZEQ9pXfohOkJl/xj4436fx7jl2EYm4p78Zy3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/286] iio: adc: ad7768-1: Move setting of val a bit later to avoid unnecessary return value check
Date: Tue, 29 Apr 2025 18:42:01 +0200
Message-ID: <20250429161116.872861950@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 0af1c801a15225304a6328258efbf2bee245c654 ]

The data used is all in local variables so there is no advantage
in setting *val = ret with the direct mode claim held.
Move it later to after error check.

Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250217141630.897334-13-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 8236644f5ecb ("iio: adc: ad7768-1: Fix conversion result sign")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index 4afa50e5c058a..c409b498fc313 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -369,12 +369,11 @@ static int ad7768_read_raw(struct iio_dev *indio_dev,
 			return ret;
 
 		ret = ad7768_scan_direct(indio_dev);
-		if (ret >= 0)
-			*val = ret;
 
 		iio_device_release_direct_mode(indio_dev);
 		if (ret < 0)
 			return ret;
+		*val = ret;
 
 		return IIO_VAL_INT;
 
-- 
2.39.5



