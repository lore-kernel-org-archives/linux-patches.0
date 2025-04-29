Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9724215060;
	Tue, 29 Apr 2025 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945628; cv=none; b=PofBlNBsTasJvTmrvxNJo1PhOmY289gGQoQne0gT0aY1q98TsOVIyxgpCNOhQO4C3J+aZL1Zlb7IbiDf6SjR8jDaH+CiaasabOQDMLJTh8gl33rDcelYDgaQ+BBmlg9kZJwmGjBOJHbpEi5h5IDo/nUYE79nsPau00yDfJDmReQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945628; c=relaxed/simple;
	bh=VXKViB5YazvydlJ4PnsizOffhgOy2jyK0C+XDnniNLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axv/Tm6F8XmQ+muCJv16EF7b2laDLkMmDp5rjcliQayPhIQKDbQOp+MXqK7FFQr0ZHNP0LaPjoqDemhOJv7P4RuSrClW/fLNRbQrypLZReBGIIpxhV6m3NAD6GdrIxv9dsW/3xPnrJ4aF8fH6dsoRnaNvm4CiYkMpZ0+RQJ3txw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJpKMsTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJpKMsTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D65FC4CEE3;
	Tue, 29 Apr 2025 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945628;
	bh=VXKViB5YazvydlJ4PnsizOffhgOy2jyK0C+XDnniNLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJpKMsTYLRk5ryMhQK9uGyiqsGboxW+ngeOtuxTrX8bloL2RJNjg5C9Ra/zxpRM5p
	 o0Juoke4YWvflh3XBzN7HtqdrJt2L1NoP33R3MHYC3mQxDvDRE8HKqh8r+v5rbCMg0
	 b4W8XZuAZZxI+mW/kjU2o+rIGNPmXEG/88dkay90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandra Merla <cmerla@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.4 176/179] s390/virtio_ccw: Dont allocate/assign airqs for non-existing queues
Date: Tue, 29 Apr 2025 18:41:57 +0200
Message-ID: <20250429161056.514995859@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit 2ccd42b959aaf490333dbd3b9b102eaf295c036a upstream.

If we finds a vq without a name in our input array in
virtio_ccw_find_vqs(), we treat it as "non-existing" and set the vq pointer
to NULL; we will not call virtio_ccw_setup_vq() to allocate/setup a vq.

Consequently, we create only a queue if it actually exists (name != NULL)
and assign an incremental queue index to each such existing queue.

However, in virtio_ccw_register_adapter_ind()->get_airq_indicator() we
will not ignore these "non-existing queues", but instead assign an airq
indicator to them.

Besides never releasing them in virtio_ccw_drop_indicators() (because
there is no virtqueue), the bigger issue seems to be that there will be a
disagreement between the device and the Linux guest about the airq
indicator to be used for notifying a queue, because the indicator bit
for adapter I/O interrupt is derived from the queue index.

The virtio spec states under "Setting Up Two-Stage Queue Indicators":

	... indicator contains the guest address of an area wherein the
	indicators for the devices are contained, starting at bit_nr, one
	bit per virtqueue of the device.

And further in "Notification via Adapter I/O Interrupts":

	For notifying the driver of virtqueue buffers, the device sets the
	bit in the guest-provided indicator area at the corresponding
	offset.

For example, QEMU uses in virtio_ccw_notify() the queue index (passed as
"vector") to select the relevant indicator bit. If a queue does not exist,
it does not have a corresponding indicator bit assigned, because it
effectively doesn't have a queue index.

Using a virtio-balloon-ccw device under QEMU with free-page-hinting
disabled ("free-page-hint=off") but free-page-reporting enabled
("free-page-reporting=on") will result in free page reporting
not working as expected: in the virtio_balloon driver, we'll be stuck
forever in virtballoon_free_page_report()->wait_event(), because the
waitqueue will not be woken up as the notification from the device is
lost: it would use the wrong indicator bit.

Free page reporting stops working and we get splats (when configured to
detect hung wqs) like:

 INFO: task kworker/1:3:463 blocked for more than 61 seconds.
       Not tainted 6.14.0 #4
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:kworker/1:3 [...]
 Workqueue: events page_reporting_process
 Call Trace:
  [<000002f404e6dfb2>] __schedule+0x402/0x1640
  [<000002f404e6f22e>] schedule+0x3e/0xe0
  [<000002f3846a88fa>] virtballoon_free_page_report+0xaa/0x110 [virtio_balloon]
  [<000002f40435c8a4>] page_reporting_process+0x2e4/0x740
  [<000002f403fd3ee2>] process_one_work+0x1c2/0x400
  [<000002f403fd4b96>] worker_thread+0x296/0x420
  [<000002f403fe10b4>] kthread+0x124/0x290
  [<000002f403f4e0dc>] __ret_from_fork+0x3c/0x60
  [<000002f404e77272>] ret_from_fork+0xa/0x38

There was recently a discussion [1] whether the "holes" should be
treated differently again, effectively assigning also non-existing
queues a queue index: that should also fix the issue, but requires other
workarounds to not break existing setups.

Let's fix it without affecting existing setups for now by properly ignoring
the non-existing queues, so the indicator bits will match the queue
indexes.

[1] https://lore.kernel.org/all/cover.1720611677.git.mst@redhat.com/

Fixes: a229989d975e ("virtio: don't allocate vqs when names[i] = NULL")
Reported-by: Chandra Merla <cmerla@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20250402203621.940090-1-david@redhat.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/virtio/virtio_ccw.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -261,11 +261,17 @@ static struct airq_info *new_airq_info(i
 static unsigned long get_airq_indicator(struct virtqueue *vqs[], int nvqs,
 					u64 *first, void **airq_info)
 {
-	int i, j;
+	int i, j, queue_idx, highest_queue_idx = -1;
 	struct airq_info *info;
 	unsigned long indicator_addr = 0;
 	unsigned long bit, flags;
 
+	/* Array entries without an actual queue pointer must be ignored. */
+	for (i = 0; i < nvqs; i++) {
+		if (vqs[i])
+			highest_queue_idx++;
+	}
+
 	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
 		mutex_lock(&airq_areas_lock);
 		if (!airq_areas[i])
@@ -275,7 +281,7 @@ static unsigned long get_airq_indicator(
 		if (!info)
 			return 0;
 		write_lock_irqsave(&info->lock, flags);
-		bit = airq_iv_alloc(info->aiv, nvqs);
+		bit = airq_iv_alloc(info->aiv, highest_queue_idx + 1);
 		if (bit == -1UL) {
 			/* Not enough vacancies. */
 			write_unlock_irqrestore(&info->lock, flags);
@@ -284,8 +290,10 @@ static unsigned long get_airq_indicator(
 		*first = bit;
 		*airq_info = info;
 		indicator_addr = (unsigned long)info->aiv->vector;
-		for (j = 0; j < nvqs; j++) {
-			airq_iv_set_ptr(info->aiv, bit + j,
+		for (j = 0, queue_idx = 0; j < nvqs; j++) {
+			if (!vqs[j])
+				continue;
+			airq_iv_set_ptr(info->aiv, bit + queue_idx++,
 					(unsigned long)vqs[j]);
 		}
 		write_unlock_irqrestore(&info->lock, flags);


