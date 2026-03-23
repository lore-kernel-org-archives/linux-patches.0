Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49413AE6F8;
	Mon, 23 Mar 2026 16:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282702; cv=none; b=CNSerp6ioaGfMIKG06blUUoDQu9gxdzSnbyV6a3gIDhC2sbC4gedxCApzgY97qOcO4GNsM3tcm93XT7BgZkBbWNI1wHCYBVyjiZBOtD2S1Ht4kdSujQGWb2TeJN7i5Q920BDgqPkincInw0YH7IUtr9vEoV85ekBPDMHahLiRI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282702; c=relaxed/simple;
	bh=+vpKsziXl851F0Nuapp6Gjy16BsjTmER/dBSCd1PDqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5y4nBtKxvLbHe8FDmq7+vrkrMuZg+ZairiTKBmble/Vkj4utDgpgN6T0a7PTscJc8UogAor4/sSQz2ouSsWp76feR7zShP1Aze6IwjfTyiAO1xhuc5nOqfZ7Joy4jq3ODa1TfAm/lqaJRET7TOE1m3n5j76HNQT42JDQJ7ZlH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+LhVLpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+LhVLpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7573EC4CEF7;
	Mon, 23 Mar 2026 16:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282701;
	bh=+vpKsziXl851F0Nuapp6Gjy16BsjTmER/dBSCd1PDqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+LhVLpP7X7bMaNJgxNWKsoltcIwdrbuND9cXvAiBX31iXnkv6XauHLzGCpWw/g8K
	 TBuXXx+QieJ9E76ePqPzYSAKq0RvYKsK9eOZQ32KUj9yx9yKqd7S0HnExYnce4eoHW
	 PBDiq5sh0WY/ZhgNmUC/Q1H+TVcFeozd3bNEBf+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 254/481] s390/dasd: Move quiesce state with pprc swap
Date: Mon, 23 Mar 2026 14:43:56 +0100
Message-ID: <20260323134531.345525143@linuxfoundation.org>
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
@@ -6233,6 +6233,11 @@ static int dasd_eckd_copy_pair_swap(stru
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


