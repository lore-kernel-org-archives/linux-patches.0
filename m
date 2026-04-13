Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD40B24DCF6;
	Mon, 13 Apr 2026 16:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097558; cv=none; b=qyG9YhBd9DXZJeLxVZD8OAujtpi7Y/vJcLjwwSyoXqhITW9sK0Brju6jDN5Vzbca/OnNyX2bVMpYXa9Zrbt7uzYEKp2f7oPT+cxBrR1OgSIfmZpF3mVixw0+mIBtD2Nna61LkZSKW+9ng8FxpjlZDYzh50epSv0YUe6zQPRrOmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097558; c=relaxed/simple;
	bh=cKWsxhbWKsRMPjh+xN7HtmMKOnbC4Xgd9+/zRjomJAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0m0Oos6sWc4MCrh/t4l5tPL8NNA3ldDg2prO9F506icnU8v+DZHn3Tk0QJCYwL4qdjbembSUSNaY5XNU7YenLNRXYjByVPyWPCMlWdswUOkRFArNodT+IO7JOd+1lY2Dde5Cj8ROwixVfLtI6IJiovSXkN4sgZqK8HHkMkE4EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIa2SkbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIa2SkbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CBDC2BCAF;
	Mon, 13 Apr 2026 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097558;
	bh=cKWsxhbWKsRMPjh+xN7HtmMKOnbC4Xgd9+/zRjomJAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIa2SkbKjT/TgSmESvkR77OupcnMGcJ7TDPYOEdyIQGnWMWhthKKadR7SPQERUpTy
	 C3opP+qnyL8FrpOzktiuQrsht79HgPxeAZYgm1LPDIiY30S1WZg591hCyGgAJwFYjX
	 4uVt6ObO3cJ+N3JPABNSCDx5tlrLgU7kjE8sCg6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Tomasz Duszynski <tduszyns@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 183/570] iio: chemical: sps30_serial: fix buffer size in sps30_serial_read_meas()
Date: Mon, 13 Apr 2026 17:55:14 +0200
Message-ID: <20260413155837.312318306@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit c3914ce1963c4db25e186112c90fa5d2361e9e0a upstream.

sizeof(num) evaluates to sizeof(size_t) which is 8 bytes on 64-bit,
but the buffer elements are only 4 bytes. The same function already
uses sizeof(*meas) on line 312, making the mismatch evident. Use
sizeof(*meas) consistently.

Fixes: b2e171f5a5c6 ("iio: sps30: add support for serial interface")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Acked-by: Tomasz Duszynski <tduszyns@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/sps30_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/sps30_serial.c
+++ b/drivers/iio/chemical/sps30_serial.c
@@ -303,7 +303,7 @@ static int sps30_serial_read_meas(struct
 	if (msleep_interruptible(1000))
 		return -EINTR;
 
-	ret = sps30_serial_command(state, SPS30_SERIAL_READ_MEAS, NULL, 0, meas, num * sizeof(num));
+	ret = sps30_serial_command(state, SPS30_SERIAL_READ_MEAS, NULL, 0, meas, num * sizeof(*meas));
 	if (ret < 0)
 		return ret;
 	/* if measurements aren't ready sensor returns empty frame */


