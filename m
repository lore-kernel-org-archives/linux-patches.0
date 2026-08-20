Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB24F2874E6;
	Thu, 20 Aug 2026 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238440; cv=none; b=mHy2zuVOky+xDUkL9pm98MVyxff5lxHTEW/XCn5a7TbNss9nM7+A/+DhXG3vJG2DNjZZqP33Oujf6EVpg/z78ldGxGT5j4l0bpA+NJz12WH92Jit87691OyaUCXBljLi9tXhfG6v81H4CERSR84AYPkY3lqw/xkS77aaZqU8bko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238440; c=relaxed/simple;
	bh=s2W5nOeQmC6uuh+WF8QpRb2pYvQXo6yr7IzeNCDmye0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PibbO9/3p9J7iBfc98fT1LCdUhsPhxehWouztSihqBZIwQJLCOGd41oKVJLmQPc1j0WYtRrPc+QHdrTSPOVcXazJmO1B5PpuWUJd3DvRsmRHNC6ETPUL0kJJteLjLb2b5Vkn+raetrMbC9TVueE7lIsjqghRL6EEg+DSnw2l0Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7r9kkJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7r9kkJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EA31F000E9;
	Thu, 20 Aug 2026 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238438;
	bh=DNxQRzT7iImIuyF16dXdxdolWOFLnAgRXtJSUuZjtds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7r9kkJ1j89DgBMkgGWv0p3QHHrnhBXvxObvLUgPcQlUWGNdjXXcRaZ7PiOHe9sIH
	 uuAyqt8niB2JCIxTFNr4wYUqmJB+/is/pdLAHvSXIQ7WmLEsP0LPx5FprCNJhxCZAb
	 6TtNlQChYBrSZ8iupC+0BPmNAuL9EB1N7Mpmdq9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 7.1 099/228] s390/vfio_ccw: Ensure first IDAW remains constant
Date: Thu, 20 Aug 2026 16:54:01 +0200
Message-ID: <20260820145247.660784741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

commit 565bef268d75bf7df665bce6923a88cd0eb74592 upstream.

The first IDAW in a list does not need to be on a 2K/4K boundary
like all others, and so is read separately to accurately calculate
the size of the buffer needed to read the full IDAL.

Verify that the address found in the first IDAW is unchanged between
reads, to ensure a consistent set of IDAWs being worked with.

Fixes: 01aa26c672c0 ("s390/cio: Combine direct and indirect CCW paths")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_cp.c |   16 ++++++++++++++++
 drivers/s390/cio/vfio_ccw_cp.h |    2 ++
 2 files changed, 18 insertions(+)

--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -530,6 +530,7 @@ static dma64_t *get_guest_idal(struct cc
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	dma64_t *idaws;
 	dma32_t *idaws_f1;
+	u64 first_idaw;
 	int idal_len = idaw_nr * sizeof(*idaws);
 	int idaw_size = idal_is_2k(cp) ? PAGE_SIZE / 2 : PAGE_SIZE;
 	int idaw_mask = ~(idaw_size - 1);
@@ -546,6 +547,18 @@ static dma64_t *get_guest_idal(struct cc
 			kfree(idaws);
 			return ERR_PTR(ret);
 		}
+
+		idaws_f1 = (dma32_t *)idaws;
+		if (cp->orb.cmd.c64)
+			first_idaw = dma64_to_u64(idaws[0]);
+		else
+			first_idaw = dma32_to_u32(idaws_f1[0]);
+
+		/* Unexpected mismatch from earlier read */
+		if (first_idaw != cp->guest_iova) {
+			kfree(idaws);
+			return ERR_PTR(-EINVAL);
+		}
 	} else {
 		/* Fabricate an IDAL based off CCW data address */
 		if (cp->orb.cmd.c64) {
@@ -611,6 +624,9 @@ static int ccw_count_idaws(struct ccw1 *
 		iova = dma32_to_u32(ccw->cda);
 	}
 
+	/* Save the read address for later */
+	cp->guest_iova = iova;
+
 	/* Format-1 IDAWs operate on 2K each */
 	if (!cp->orb.cmd.c64)
 		return idal_2k_nr_words((void *)iova, bytes);
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -35,6 +35,7 @@
  * @initialized: whether this instance is actually initialized
  * @guest_cp: copy of guest channel program
  * @ccwchain_count: number of channel program segments (linked by TIC)
+ * @guest_iova: first data address of a guest channel program
  *
  * @ccwchain_list is the head of a ccwchain list, that contents the
  * translated result of the guest channel program that pointed out by
@@ -46,6 +47,7 @@ struct channel_program {
 	bool initialized;
 	struct ccw1 *guest_cp;
 	unsigned int ccwchain_count;
+	u64 guest_iova;
 };
 
 int cp_init(struct channel_program *cp, union orb *orb);


