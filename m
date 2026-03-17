Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F313F54D1;
	Tue, 17 Mar 2026 17:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766995; cv=none; b=H7387Qc4cRhBWmczUGyUI66i5QxbYJmg7NRCrBhihdoOXk9Q3FdZvIpwKw0LfX4DqEbBGqLX0JmV3uLjmDJ/NW/hrNp/CQ804zk9z+6IROxUqc2sa1M6vr0jNaJ4GRf6kiSj4Art+6Pwa0j+03gJos5cfjhjCLKIZpo2jegCgz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766995; c=relaxed/simple;
	bh=QoBbXxHjKcQevNBLXZf4kbIXmqV/eY8DfWl1LDorbe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SS5jfzaSquBKA61ZtDpaL1dGe+yZyYzrgQITLg98jtldrhceh7lgxgMTmL1m6bj8vNf5YnTAhFj8KQ3BEUcbTC2YgZcq00jeCgcKAdkCulacQ0B8uWHm8OXWFM6frS3lhUFm/NeIaI9v/jaVdCG9k1tx4jquIhBtkXgojSNBpsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKEJ4ZC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKEJ4ZC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFE5C19424;
	Tue, 17 Mar 2026 17:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766995;
	bh=QoBbXxHjKcQevNBLXZf4kbIXmqV/eY8DfWl1LDorbe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKEJ4ZC4AHU/NW/9dGJmw7Dwuhy3LoUGVhSxqwW+2b/YlEYT6GPgPPZDZtIWeObAW
	 +KJtyG25/GSFhOloo9wZUCQeWqPjO0nk3mTXf0SeapjNYQP54PKy3c+3SoM/lPJuWh
	 LaMPyiVdlJ642jqrZiynvkvmm+e1GX3GUeTU/fKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.19 369/378] i3c: mipi-i3c-hci: Fix race in DMA ring dequeue
Date: Tue, 17 Mar 2026 17:35:26 +0100
Message-ID: <20260317163020.553539513@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 1dca8aee80eea76d2aae21265de5dd64f6ba0f09 upstream.

The HCI DMA dequeue path (hci_dma_dequeue_xfer()) may be invoked for
multiple transfers that timeout around the same time.  However, the
function is not serialized and can race with itself.

When a timeout occurs, hci_dma_dequeue_xfer() stops the ring, processes
incomplete transfers, and then restarts the ring.  If another timeout
triggers a parallel call into the same function, the two instances may
interfere with each other - stopping or restarting the ring at unexpected
times.

Add a mutex so that hci_dma_dequeue_xfer() is serialized with respect to
itself.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c |    1 +
 drivers/i3c/master/mipi-i3c-hci/dma.c  |    2 ++
 drivers/i3c/master/mipi-i3c-hci/hci.h  |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -632,6 +632,7 @@ static int i3c_hci_init(struct i3c_hci *
 		return ret;
 
 	spin_lock_init(&hci->lock);
+	mutex_init(&hci->control_mutex);
 
 	/*
 	 * Now let's reset the hardware.
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -486,6 +486,8 @@ static bool hci_dma_dequeue_xfer(struct
 	unsigned int i;
 	bool did_unqueue = false;
 
+	guard(mutex)(&hci->control_mutex);
+
 	/* stop the ring */
 	rh_reg_write(RING_CONTROL, RING_CTRL_ABORT);
 	if (wait_for_completion_timeout(&rh->op_done, HZ) == 0) {
--- a/drivers/i3c/master/mipi-i3c-hci/hci.h
+++ b/drivers/i3c/master/mipi-i3c-hci/hci.h
@@ -46,6 +46,7 @@ struct i3c_hci {
 	void *io_data;
 	const struct hci_cmd_ops *cmd;
 	spinlock_t lock;
+	struct mutex control_mutex;
 	atomic_t next_cmd_tid;
 	u32 caps;
 	unsigned int quirks;


