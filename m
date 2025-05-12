Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8430E1C32FF;
	Mon, 12 May 2025 17:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072060; cv=none; b=DTSUGwo/zbX6U8+zWTag73dEUjcAlbrgneLINxjr//9lFRWUq5A/xYaX8FvyfNGNzl0mkLa7z2tjDP/L/b1b0mVdDzkPjD+2cndfKJZxE6jWI8hKZyfyAnFzWm+7krscmWMyHkvTVrrqe1lJx6QCmF1qpjZV1e6fIWlVzGYAKzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072060; c=relaxed/simple;
	bh=P0at67NPwEsje03a4qrImfsKNNEARAncWbsykliqSiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVaXTs0Vo+RhNFAKTe0RgBOgmqIOPTJCIhsMQc93TpQowyrWrF0C+2IQqFRK/ACkNcXt856i1BDtQSmM/X4WuLJZvJJWorwLTw1w8kSvZL9w4fDCfIJ95j/QCRdLSuIGjUaAf+9K4CsVTBHvKOZbgFk+11DCHmKxS6LEvAvyAeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GWKqMnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GWKqMnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13083C4CEE7;
	Mon, 12 May 2025 17:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072060;
	bh=P0at67NPwEsje03a4qrImfsKNNEARAncWbsykliqSiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GWKqMnKDLXpyOmbE8I3bd0n8OewuEv6NDEMI0f7rD4l3aOqVOZoRXKCbo1rzI0OF
	 kw8dm40Oe61N16rMNWpde79/XP7LRFVdq6lm2KsyO5czXQ7ysLrKo8WWgVhSckPXpF
	 yXlDQkbFwhlQNxDu5n5FdexVly2BHq9rPuXd/zm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Silvano Seva <s.seva@4sigma.it>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.14 098/197] iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_tagged_fifo
Date: Mon, 12 May 2025 19:39:08 +0200
Message-ID: <20250512172048.373455226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Silvano Seva <s.seva@4sigma.it>

commit 8114ef86e2058e2554111b793596f17bee23fa15 upstream.

Prevent st_lsm6dsx_read_tagged_fifo from falling in an infinite loop in
case pattern_len is equal to zero and the device FIFO is not empty.

Fixes: 801a6e0af0c6 ("iio: imu: st_lsm6dsx: add support to LSM6DSO")
Signed-off-by: Silvano Seva <s.seva@4sigma.it>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250311085030.3593-4-s.seva@4sigma.it
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -626,6 +626,9 @@ int st_lsm6dsx_read_tagged_fifo(struct s
 	if (!fifo_len)
 		return 0;
 
+	if (!pattern_len)
+		pattern_len = ST_LSM6DSX_TAGGED_SAMPLE_SIZE;
+
 	for (read_len = 0; read_len < fifo_len; read_len += pattern_len) {
 		err = st_lsm6dsx_read_block(hw,
 					    ST_LSM6DSX_REG_FIFO_OUT_TAG_ADDR,


