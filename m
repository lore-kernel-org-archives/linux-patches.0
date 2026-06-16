Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079F2355F5F;
	Tue, 16 Jun 2026 17:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631017; cv=none; b=RdfFFG3R+/4BPkDf81C6Zkx54Z9MSET6PMZf+L+qAUdrNSKBI1/7Lbxvr3C3HyxAyhm/4KHwZ0kMKdhgoZo9PT2FZhDap2CR5VibYv83xDOrxXcBRkOeZZobjiy2+cQIXvosa2x2BHRpwmr6qOqUHybUXJ40J5En9CFVe92M+Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631017; c=relaxed/simple;
	bh=MC0sudR9Bx4yf0t7bPZwF+21bR/q9Q6y7oVBFmbIIjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ipcZERsiCmHT5PAxFWjKoun6PyZLCcvojDShjlpw2l+bCpSTdLT5HD6MsnROms/hi+aDftekEFwTWvg03KPufGoAz50JtxzA7tf3BPhzM1vYxvs8S8/2TADcrWZ+AsieDOKXj1lqTj2xLNzkp1W/aVM1Q44a0QQImw3KegF7/C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW84jy0T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW84jy0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A631F000E9;
	Tue, 16 Jun 2026 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631016;
	bh=v0hcNhSOOJ5W/8POYL7jlcsFM2gu9LetXaGNfiLhM/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PW84jy0Ti8NMPnEsJerko8R0Q2uNm1cVxhGQNAG6HHhGeZhbu9xxuPXajkeP3ESrj
	 N6ZpRYTVS2m+vsKwVuhD49WwJAycvJlnNvm1AZf5+vpx2l3EBFELmzMJLIBFosHccG
	 4hZ2kPB5/qg/qR202VKsJTo8x0G9eGGGPKx9HRIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Maxwell Doose <m32285159@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 107/522] iio: adc: viperboard: Fix error handling in vprbrd_iio_read_raw
Date: Tue, 16 Jun 2026 20:24:14 +0530
Message-ID: <20260616145130.947838117@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit 422b5bbf333f75fb486855ad0eedc23cf21f3277 upstream.

The driver proceeds to the reception phase even if the preceding
transmission fails.

This uses a goto error label for an early bail out and ensures the mutex is
properly unlocked in case of failure.

Fixes: ffd8a6e7a778 ("iio: adc: Add viperboard adc driver")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Maxwell Doose <m32285159@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/viperboard_adc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/viperboard_adc.c
+++ b/drivers/iio/adc/viperboard_adc.c
@@ -70,8 +70,10 @@ static int vprbrd_iio_read_raw(struct ii
 			VPRBRD_USB_TYPE_OUT, 0x0000, 0x0000, admsg,
 			sizeof(struct vprbrd_adc_msg), VPRBRD_USB_TIMEOUT_MS);
 		if (ret != sizeof(struct vprbrd_adc_msg)) {
-			dev_err(&iio_dev->dev, "usb send error on adc read\n");
+			mutex_unlock(&vb->lock);
 			error = -EREMOTEIO;
+			dev_err(&iio_dev->dev, "usb send error on adc read\n");
+			goto error;
 		}
 
 		ret = usb_control_msg(vb->usb_dev,


