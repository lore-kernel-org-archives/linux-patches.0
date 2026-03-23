Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F3939768D;
	Mon, 23 Mar 2026 14:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275708; cv=none; b=V85BydhVhrYpfFvVaYp8w9gZyZfLZ0LYpe9uRxlZWcYcNHTogdH904TwQYxfSj0rkZh6NPD1hN/Nc99J53+2Yq9kbHJDqlPYHAH7ulmGlwIY+ZFdXGhDtfZhSzC9RExZlCFF4ujkkW7PHZVhJ23W0B+1izcV5jhBwfRUWTH3CBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275708; c=relaxed/simple;
	bh=JSimC3YDAhQBXVc5SoBP+gw8KisKHoRuH6AidaX2i6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhM3TN9nZimfzABYAx/ntwpWXxjNaBE3ggnKH0zWyy2TeEcuy5kNmsHP50eCQRey3o1uL83bwosEfMnlvM9U3f4q2/twjR4kC07BpVWlgJO0GUR7J2l7tsUIoCqgBSZL8lff5H/b/5/QWe4xxjONzsl+5CGFsgdpY1YChnsqk0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyOE5m9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyOE5m9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2D7C4CEF7;
	Mon, 23 Mar 2026 14:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275708;
	bh=JSimC3YDAhQBXVc5SoBP+gw8KisKHoRuH6AidaX2i6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyOE5m9pPyijGBtKyKHb5NCKBinrIeXzuY8f4PE7usNT88IWtmCV7hOWiXYXOkof5
	 nnPGI2Cp9lMYioIm37YsuHofN2oJr+4Tpwn6RzECN8Ku9wKWfSmrhBXJfCYClI/ozM
	 H+7/Yo+aagkBkDUUyfYUFOIVAIdBRw06nr8uE5iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 190/460] s390/dasd: Move quiesce state with pprc swap
Date: Mon, 23 Mar 2026 14:43:06 +0100
Message-ID: <20260323134531.217822517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit 40e9cd4ae8ec43b107ed2bff422a8fa39dcf4e4b upstream.

Quiesce and resume is a mechanism to suspend operations on DASD devices.
In the context of a controlled copy pair swap operation, the quiesce
operation is usually issued before the actual swap and a resume
afterwards.

During the swap operation, the underlying device is exchanged. Therefore,
the quiesce flag must be moved to the secondary device to ensure a
consistent quiesce state after the swap.

The secondary device itself cannot be suspended separately because there
is no separate block device representation for it.

Fixes: 413862caad6f ("s390/dasd: add copy pair swap capability")
Cc: stable@vger.kernel.org #6.1
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260310142330.4080106-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -6192,6 +6192,11 @@ static int dasd_eckd_copy_pair_swap(stru
 			dev_name(&secondary->cdev->dev), rc);
 	}
 
+	if (primary->stopped & DASD_STOPPED_QUIESCE) {
+		dasd_device_set_stop_bits(secondary, DASD_STOPPED_QUIESCE);
+		dasd_device_remove_stop_bits(primary, DASD_STOPPED_QUIESCE);
+	}
+
 	/* re-enable device */
 	dasd_device_remove_stop_bits(primary, DASD_STOPPED_PPRC);
 	dasd_device_remove_stop_bits(secondary, DASD_STOPPED_PPRC);


