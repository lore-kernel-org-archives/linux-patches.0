Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3358243D510;
	Tue, 21 Jul 2026 22:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673781; cv=none; b=YGe9G8nFwOq/27aOewWIorkLPdiIt/a/0A+87cDTGlFT/o+nLrMzfW9/t3D5/bE7o25ti6mj70xPq0CmDNr8WjR9XzC8bq0TBiKj6bSOcANAJ6hayppvlElx3VuG+u8+68u8QqRcPjnwlik4Mu2l2hkcPedw5HGMe/g8aFwziwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673781; c=relaxed/simple;
	bh=abVeUhXAjP+WBP64i1e+eMTMzMvmrRFEg/IZ9Oqpyco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yj0zKVAzTNWGTFNltziX+nocZg5QVk942i8I8lyL/MJ184Pu9UUc+hD6XIMRhrYwbGIGzH3deZ/O3A5oL1qbVCOmFgajhWf3ezVexd7AIDnINJd40WZYrYlX4v7Ojnr/vhzX0w4MpVDhqTwZNezV4eLZnjOULEWRBXvsX7idzxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2S8ty+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2S8ty+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD081F000E9;
	Tue, 21 Jul 2026 22:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673780;
	bh=bI+quyRThrVxY7ZrCxAJ0qPB5aUmQIFPC2ZW5Nnip8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2S8ty+rGrU8RGfP+hIFPa+tQkcuwdCSfAW80omGVr0RuDSiC6bvqgr62jxc/mvzv
	 94tlEwgOSwyd6ozYiD6K2RM0SOecXX80zu/y6f8tubNRm6iMdRnAF1GrcboUTVcSu4
	 2hQWLaW25KSqsfM4T8rVWtNbkxC/XG6D5b3hpYGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/699] iio: accel: mma8452: handle I2C read error(s) in mma8452_read()
Date: Tue, 21 Jul 2026 17:20:51 +0200
Message-ID: <20260721152402.284890909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

[ Upstream commit 5bdff291d20c31b365d9ddfe9c426fbfb41da5bb ]

Currently, If i2c_smbus_read_i2c_block_data() fails but
mma8452_set_runtime_pm_state() succeeds, mma8452_read() returns 0.

As a result, the caller mma8452_read_raw() assumes the read was
successful and proceeds to use a buffer containing uninitialized
stack memory.

Add proper checking of the I2C read return value and propagate errors
to the caller.

Fixes: 96c0cb2bbfe0 ("iio: mma8452: add support for runtime power management")
Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 760ee0685034bb..b8ab2b0627a3c4 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -254,6 +254,8 @@ static int mma8452_read(struct mma8452_data *data, __be16 buf[3])
 
 	ret = i2c_smbus_read_i2c_block_data(data->client, MMA8452_OUT_X,
 					    3 * sizeof(__be16), (u8 *)buf);
+	if (ret < 0)
+		return ret;
 
 	ret = mma8452_set_runtime_pm_state(data->client, false);
 
-- 
2.53.0



