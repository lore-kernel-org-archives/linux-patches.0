Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9F21DE4CD;
	Mon, 12 May 2025 18:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072885; cv=none; b=fjphu1PistsxoTqTvXZgg+5HfGoQb2DDpm/Cl9TEVjcvay9+ybrlML+tUNufgu75JeyaBr7TyEwY9D198NXEnD5bRaOaGUdclG5A8KIeyd3paRvva+KpEAreSlLgjQnGJzMkKQAx2Vxm4joPhEr7X8sl1qcbKpQHbVXNVw0hg10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072885; c=relaxed/simple;
	bh=dBUw9+pI+HGfrpr0p7hTioRYyOZDZFiZnhtbdVU65vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axWmmwR0ZcqcT8mDHahd3xbvKmhytFngkdGAvzlqXfjXwo4zvefJ49FmV6g37iY5u03owS8ZgWRgkKaxVjuAilHHvhyVMfrW8EGKuI22O/mLatUI+HxtQgF6nsH/2rEZ/mrXTTKt3pHDeFkFaaHORjjzE68WxIM1LKXwmah3R3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzeLSpaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzeLSpaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECF3C4CEE7;
	Mon, 12 May 2025 18:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072885;
	bh=dBUw9+pI+HGfrpr0p7hTioRYyOZDZFiZnhtbdVU65vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzeLSpaq1AbGaOJRsOHXdtgdCUGWrdRn5norO4h7yd13oBCvj3iCWRY9eDJ0Gqx72
	 jSFnmVL8TD+wPYGcswmvZce9vVP3r9GePtBmwB9P45T2rZiI+XRK8oWcxiDizeKtZQ
	 fXklb3TkaLcahOzlOaDM15M9Sgcd2ISPs060b1A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Silvano Seva <s.seva@4sigma.it>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 086/184] iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_fifo
Date: Mon, 12 May 2025 19:44:47 +0200
Message-ID: <20250512172045.326060075@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Silvano Seva <s.seva@4sigma.it>

commit 159ca7f18129834b6f4c7eae67de48e96c752fc9 upstream.

Prevent st_lsm6dsx_read_fifo from falling in an infinite loop in case
pattern_len is equal to zero and the device FIFO is not empty.

Fixes: 290a6ce11d93 ("iio: imu: add support to lsm6dsx driver")
Signed-off-by: Silvano Seva <s.seva@4sigma.it>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250311085030.3593-2-s.seva@4sigma.it
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -392,6 +392,9 @@ int st_lsm6dsx_read_fifo(struct st_lsm6d
 	if (fifo_status & cpu_to_le16(ST_LSM6DSX_FIFO_EMPTY_MASK))
 		return 0;
 
+	if (!pattern_len)
+		pattern_len = ST_LSM6DSX_SAMPLE_SIZE;
+
 	fifo_len = (le16_to_cpu(fifo_status) & fifo_diff_mask) *
 		   ST_LSM6DSX_CHAN_SIZE;
 	fifo_len = (fifo_len / pattern_len) * pattern_len;


