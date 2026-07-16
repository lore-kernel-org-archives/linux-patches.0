Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39F83BED2D;
	Thu, 16 Jul 2026 13:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209085; cv=none; b=TGJUCnWSz8PIVVrwIHmU5in+3gCyOxGdqrqiAVR5rS2b08DCZLWt1IKAbji9HHeGOcOjnQqlEaX4kvG0OdEgPNZUm7IkXcESGkxn0Di4Np3uuvSMTReMmf4gfz7y7luLgGnuVKZ0+tHN43VCLNn+GnX7Vtp3QMiBC/1V0JDwfB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209085; c=relaxed/simple;
	bh=yxt7N5MJWR50MCS6SDgaLuyAEdcpUnYW9emZ0eSz7A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=linzeptrfXDoL66o5wxbFHAd5i1M6MXnqcmydHfhjMeIT5rYBDW+XoNi52758nvNxWx2J5xfKCbZLBEeXOMKGxCOBlQuX2n1Q3teCdmW0CFzKw4rJezuUo1T2xSGnnNGQalNCcjtgXC5G5ZY+U9bS5SaQH0Y+cZGECgHquzAhl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twoK5RC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twoK5RC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF3A1F000E9;
	Thu, 16 Jul 2026 13:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209084;
	bh=yBv4wwNqPrt4jJQtHmcf26bI/OOp3m3MkSCbVoO8Jnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twoK5RC8+vqZ3Hpf5NxVMzEGFjGGUTjcARFgf9Toio8e+Xzeql3peWcNd0qB1/AXo
	 OZRLysoYn4WeRjo1jQdbav8WeSK6fgPP3XLUk5SqZsI+8OXFzQ713xMcy3FLOq5rj5
	 rAF3FVjVEVrlRsc2I+YA2wl68gmxdjZ0ma2xLtvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Angelo Dureghello <adureghello@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 051/518] iio: dac: ad3552r-hs: fix uninitialized data ni ad3552r_hs_write_data_source()
Date: Thu, 16 Jul 2026 15:25:19 +0200
Message-ID: <20260716133048.903528822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit eaaa7eef181892ef7ba56c6295b81f0ae4492c13 upstream.

If the *ppos value is non-zero then the simple_write_to_buffer() function
won't initialized the start of the buf[] buffer.  Non-zero values for
*ppos won't work here generally, so just test for them and return -ENOSPC
at the start of the function.

Fixes: b1c5d68ea66e ("iio: dac: ad3552r-hs: add support for internal ramp")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Angelo Dureghello <adureghello@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad3552r-hs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad3552r-hs.c
+++ b/drivers/iio/dac/ad3552r-hs.c
@@ -549,7 +549,7 @@ static ssize_t ad3552r_hs_write_data_sou
 
 	guard(mutex)(&st->lock);
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -ENOSPC;
 
 	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf,


