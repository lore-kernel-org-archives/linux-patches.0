Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522D03A1A3F;
	Sat, 17 Oct 2026 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258622; cv=none; b=k+nFUijTBtw80erRvO+8T2O3R9A2Ar29hokzfwi3O+FfRZa1TWVlOfqyEldgp43DtXleclwUOrGpFkP7FAXybNfQp1rMys6oxWjczscQ+R/52wvh+GSnV5j8YZlIjNQa4nAWEQBt9NgblzyoMN7vR4NJ8C+HVa9qlTTO4MjMQag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258622; c=relaxed/simple;
	bh=akjqtVXVKDdkl5eSRRq0dY/lDPGtgWVJy/CcQeL73sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYVnGb20404thznB0b56G5f/SOD4bK4TH3Zip3mwUrGUQCBmUts6YNWjcqhNepXrU2/llOx9Rwcx0ySQhl3HJ76mRlqGCcQRe7V2whWun9vE49qGkGdxVYI00GdU8FDcslpNT7jeBvwcqHA1zWdCRKmdx2/fhqFxI3iGfbz/0ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7JJ2cJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7JJ2cJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FDE1F000C4;
	Sat, 17 Oct 2026 17:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258620;
	bh=XUQJeMXu5fXlu/XjsYiBMLG5rvjk5lU+gm5P1yhYQuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7JJ2cJJI5I1f8NpLuZUY1+OtLAfFyMFFHfcUtrnpzNVEUxyeMe5dxW0VM7DTs35+
	 sldrWevNvfcRvcHw2/NN9S1wOVQRUzTMNqWwJ9SYRv8zWbFvrCe4FVSQNuHtBHYwfY
	 jGpC3x5q4Vti1bDC/4Kpsbo33AN6q8TRUxYtLQ9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0946/1674] HID: Intel-ish-hid: Ishtp: Fix sensor reads after ACPI S3 suspend
Date: Sat, 17 Oct 2026 17:53:38 +0200
Message-ID: <20261017160455.415629568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Even Xu <even.xu@intel.com>

[ Upstream commit bdab6c94bb24758081625e619330b04cfd56570a ]

After legacy suspend/resume via ACPI S3, sensor read operation fails
with timeout. Also, it will cause delay in resume operation as there
will be retries on failure.

This is caused by commit f645a90e8ff7 ("HID: intel-ish-hid:
ishtp-hid-client: use helper functions for connection"), which used
helper functions to simplify connect, reset and disconnect process.
Also avoid freeing and allocating client buffers again during reconnect
process.

But there is a case, when ISH firmware resets after ACPI S3 suspend,
ishtp bus driver frees client buffers. Since there is no realloc again
during reconnect, there are no client buffers available to send connection
requests to the firmware. Without successful connection to the firmware,
subsequent sensor reads will timeout.

To address this issue, ishtp bus driver does not free client buffers on
warm reset after S3 resume. Simply add the buffers from the read list
to free list of buffers.

Fixes: f645a90e8ff7 ("HID: intel-ish-hid: ishtp-hid-client: use helper functions for connection")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218442
Signed-off-by: Even Xu <even.xu@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 56f7db581ee7 ("HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp/bus.c    | 2 ++
 drivers/hid/intel-ish-hid/ishtp/client.c | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index 4d97d043aae4b..465c419a1854d 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -730,6 +730,8 @@ void ishtp_bus_remove_all_clients(struct ishtp_device *ishtp_dev,
 	spin_lock_irqsave(&ishtp_dev->cl_list_lock, flags);
 	list_for_each_entry(cl, &ishtp_dev->cl_list, link) {
 		cl->state = ISHTP_CL_DISCONNECTED;
+		if (warm_reset && cl->device->reference_count)
+			continue;
 
 		/*
 		 * Wake any pending process. The waiter would check dev->state
diff --git a/drivers/hid/intel-ish-hid/ishtp/client.c b/drivers/hid/intel-ish-hid/ishtp/client.c
index 2d92fc129ce4d..af2562b8efcec 100644
--- a/drivers/hid/intel-ish-hid/ishtp/client.c
+++ b/drivers/hid/intel-ish-hid/ishtp/client.c
@@ -49,7 +49,9 @@ static void ishtp_read_list_flush(struct ishtp_cl *cl)
 	list_for_each_entry_safe(rb, next, &cl->dev->read_list.list, list)
 		if (rb->cl && ishtp_cl_cmp_id(cl, rb->cl)) {
 			list_del(&rb->list);
-			ishtp_io_rb_free(rb);
+			spin_lock(&cl->free_list_spinlock);
+			list_add_tail(&rb->list, &cl->free_rb_list.list);
+			spin_unlock(&cl->free_list_spinlock);
 		}
 	spin_unlock_irqrestore(&cl->dev->read_list_spinlock, flags);
 }
-- 
2.53.0



