Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8192737E0;
	Mon, 23 Mar 2026 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278540; cv=none; b=RSeBc+eSb3btpKTKKR9w1BqZsXjEecyruCdu8dvBpm4wioESmezNhHYrpeZIAeFB8sGlgnR5rOWi7mVlvW3C071bMgymaBSAUKZprQ+SrA1k634NNJAJ3h2qtmmaxiY2OAnkuOZaD1pWWLUmuJQ/vNeHccwlIjh0N5/QVk+X6Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278540; c=relaxed/simple;
	bh=nlcAXiV/zEwVhPM/bis2bY3O1W1kb2O4oAP9UJCwfxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QExbFqztrXervNk3z5xmIdwfNEJnbYjXXuyj3ND0EpB++WKP5nw76y/TEaIrhv8weOBjzcYkfm35imjZf0kpO+afeoUSkvbuaFRuMK77eqJe1WV5KER/clXqmGGcMCgM9QS/O3uMgF19NndnbMjNCjhmlUzLyHk+93cA7+1H+n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRiJvHSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRiJvHSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102F8C4CEF7;
	Mon, 23 Mar 2026 15:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278540;
	bh=nlcAXiV/zEwVhPM/bis2bY3O1W1kb2O4oAP9UJCwfxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRiJvHSfRC4EAMxHN0LeYSOvTBBMgJX4m9NrqMKO/+hbzkmWdecVeAIButuqe4YOj
	 fIUg7SkRmY4kllVAZAfXC8O91W+PRa3BFaUWYYL4fX2DybAo0XB5XfVPAj2Cd8nEhU
	 OvUxCNEXvebjnk+Z2aVJlMmGT8vFYpmloxkTujC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 341/567] s390/dasd: Move quiesce state with pprc swap
Date: Mon, 23 Mar 2026 14:44:21 +0100
Message-ID: <20260323134542.270360885@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6232,6 +6232,11 @@ static int dasd_eckd_copy_pair_swap(stru
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


