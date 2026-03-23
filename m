Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696A13B0ACB;
	Mon, 23 Mar 2026 16:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282737; cv=none; b=Yn0teHGJgoHnc9Qb1GLyfo3eYm9bSpcH4wtNJFIiuGzuzxte20mMy15M/RNk4DsiT5HA/+ov+BGVzoc+nw0tlmPvToChdK4iSs1sip/uaGc6W3gpkyilusuKi4wjwOYrqLGgndQdzPXFooamSU5ArTGK10Hra29ADzYqSrxgvYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282737; c=relaxed/simple;
	bh=VEXKhO5p+ScVUy5cthqCTzvynI6UiazImKhQEoFk5XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHz3qqsPP8JDGGtAS7BZ4eN1Jsyc4WImxh/dh6+XKRs2AVO8Oy/lk3c7T2pjP+addoJRDF6Ka3fd9xCOk//EO8dgkcPt/Efx8TGQZWfKp6fiRVsxGi0cT1Ly/6+LFMR55BlnEBfBk3rNbrGRAG4A9HsWb4w0ED4t4eYTsl9Q1s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsSgikG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsSgikG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED241C2BCB0;
	Mon, 23 Mar 2026 16:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282737;
	bh=VEXKhO5p+ScVUy5cthqCTzvynI6UiazImKhQEoFk5XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsSgikG7WjTodFms7Idtjg8W5gVH/Tui4gb1WFB69G2/WzmC4XP5hLtSlgZDDMs+q
	 0nw1U4fMzjkctJqD33KaGpD6JiRxhSISE19nOOQ78aahHM4DHGzb3Ws4nfxLTcNIW+
	 BbNNsvO7u9GMdJw9u+oESdS1we5fQfJpoChU7oWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Tomasz Duszynski <tduszyns@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 266/481] iio: chemical: sps30_serial: fix buffer size in sps30_serial_read_meas()
Date: Mon, 23 Mar 2026 14:44:08 +0100
Message-ID: <20260323134531.623034393@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


