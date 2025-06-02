Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACCF22D4CE;
	Mon,  2 Jun 2025 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875228; cv=none; b=GfTMtph/9tZietZyGHwiu0BrGj6Bqa/RBaJ91rcYhiHNRM+aRaSjmpqUdG59wtl7tDicFbj047KGhjAbgGTytdnUH3TPjaTCMPFSs5BPoJskZJzkEHg/Yoh8TqbxrVgSiQ1v7pVFgWRDxMjGVwauQjkpJPYx0Z7DeEwqG4I1LiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875228; c=relaxed/simple;
	bh=ikLzMD5kWrleW5d2tXon24MqHa4pmX+jorWDxbKCcdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGJAyjHTx8bwUK2KmjqWI3Lo+r0cm+KEIxBAAz2rSG14Zgk4GA7Tc/jEOr6mXHmzgoWF1FfCUrrwFwlUXGR+hcZcs+BCOINurzpQ9IC82ImAaDtq51J1+1GnBC2OqYabeQUpBYcQzMRRZ4aSapXjrP+RHqu8waqX7eCvy3cdslQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmLVEMko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmLVEMko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD70C4CEEB;
	Mon,  2 Jun 2025 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875228;
	bh=ikLzMD5kWrleW5d2tXon24MqHa4pmX+jorWDxbKCcdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmLVEMkor29uiSN7iKSugyUnuoRy2cbbG5mwavBJNgpiNEmVEnhAlx7EwAplQWxTe
	 Bgu2KOtSldVZyOSOZF8KMLsIHZcu+SA49C/kenccMbWBL6NalnpDYAAKZhuHeyiIYQ
	 J/LWJSe6o7f/EmsoFNejJzp8dEqMM3BgFTs3f6Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Silvano Seva <s.seva@4sigma.it>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 061/270] iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_fifo
Date: Mon,  2 Jun 2025 15:45:46 +0200
Message-ID: <20250602134309.684389931@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -369,6 +369,9 @@ int st_lsm6dsx_read_fifo(struct st_lsm6d
 	if (fifo_status & cpu_to_le16(ST_LSM6DSX_FIFO_EMPTY_MASK))
 		return 0;
 
+	if (!pattern_len)
+		pattern_len = ST_LSM6DSX_SAMPLE_SIZE;
+
 	fifo_len = (le16_to_cpu(fifo_status) & fifo_diff_mask) *
 		   ST_LSM6DSX_CHAN_SIZE;
 	fifo_len = (fifo_len / pattern_len) * pattern_len;


