Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A8CC129;
	Mon,  1 Apr 2024 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988611; cv=none; b=BEzgiznRmtBKwnvZDuA0kFblm1LvHQlgQffWdfDC4WMjKQWNpHJbuSP6bR03sZc7XwlNELU4ee4I10LnPWVy4KeCpKFgzp4exriL0rIFVR0t2zimH6Q1WGf/jZdhLsz6tcDNkq3E4HvM/4EdeCaYrfiEO9l4YZxw0NTESsESquM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988611; c=relaxed/simple;
	bh=fxZO+DUP9CNOt1P3SXK51o8801szoLSBhMHAyLJrF/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaTv08cg0lrVtc/iHXC7MkfKpyr2rG/KTpf/XCbLuC4fqAL/581CxkeOqOjuRdqLe94ODHVE68w3AlJ2w3U0qU8MGs4n02O96OuYwv/DJEkXxFY8/4g0kEieStvavXmPZNf9RhYmrnlnxt2FhbHR0yr7Gxo88voWyBRB/SO62YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfOISs8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfOISs8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88514C433C7;
	Mon,  1 Apr 2024 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988611;
	bh=fxZO+DUP9CNOt1P3SXK51o8801szoLSBhMHAyLJrF/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfOISs8m/qDAiZ7bqDk3UVKkJUShgRiOjLj2Qnxe9WnWSsoR6W/3Kq0MAB87VZ5g4
	 L4gtJiSaVKYxRcZ4FhBV0x6mTG6uNnIfeejk/g7eu3DWi3N6R5SYR7GK8kYYpyS7jp
	 6JOtFWC0Rp7/gYNnSIF0qm9qNELQlgkJynZ6TlzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.7 237/432] Drivers: hv: vmbus: Calculate ring buffer size for more efficient use of memory
Date: Mon,  1 Apr 2024 17:43:44 +0200
Message-ID: <20240401152600.207398486@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

commit b8209544296edbd1af186e2ea9c648642c37b18c upstream.

The VMBUS_RING_SIZE macro adds space for a ring buffer header to the
requested ring buffer size.  The header size is always 1 page, and so
its size varies based on the PAGE_SIZE for which the kernel is built.
If the requested ring buffer size is a large power-of-2 size and the header
size is small, the resulting size is inefficient in its use of memory.
For example, a 512 Kbyte ring buffer with a 4 Kbyte page size results in
a 516 Kbyte allocation, which is rounded to up 1 Mbyte by the memory
allocator, and wastes 508 Kbytes of memory.

In such situations, the exact size of the ring buffer isn't that important,
and it's OK to allocate the 4 Kbyte header at the beginning of the 512
Kbytes, leaving the ring buffer itself with just 508 Kbytes. The memory
allocation can be 512 Kbytes instead of 1 Mbyte and nothing is wasted.

Update VMBUS_RING_SIZE to implement this approach for "large" ring buffer
sizes.  "Large" is somewhat arbitrarily defined as 8 times the size of
the ring buffer header (which is of size PAGE_SIZE).  For example, for
4 Kbyte PAGE_SIZE, ring buffers of 32 Kbytes and larger use the first
4 Kbytes as the ring buffer header.  For 64 Kbyte PAGE_SIZE, ring buffers
of 512 Kbytes and larger use the first 64 Kbytes as the ring buffer
header.  In both cases, smaller sizes add space for the header so
the ring size isn't reduced too much by using part of the space for
the header.  For example, with a 64 Kbyte page size, we don't want
a 128 Kbyte ring buffer to be reduced to 64 Kbytes by allocating half
of the space for the header.  In such a case, the memory allocation
is less efficient, but it's the best that can be done.

While the new algorithm slightly changes the amount of space allocated
for ring buffers by drivers that use VMBUS_RING_SIZE, the devices aren't
known to be sensitive to small changes in ring buffer size, so there
shouldn't be any effect.

Fixes: c1135c7fd0e9 ("Drivers: hv: vmbus: Introduce types of GPADL")
Fixes: 6941f67ad37d ("hv_netvsc: Calculate correct ring size when PAGE_SIZE is not 4 Kbytes")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218502
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Tested-by: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
Link: https://lore.kernel.org/r/20240229004533.313662-1-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240229004533.313662-1-mhklinux@outlook.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hyperv.h |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -164,8 +164,28 @@ struct hv_ring_buffer {
 	u8 buffer[];
 } __packed;
 
+
+/*
+ * If the requested ring buffer size is at least 8 times the size of the
+ * header, steal space from the ring buffer for the header. Otherwise, add
+ * space for the header so that is doesn't take too much of the ring buffer
+ * space.
+ *
+ * The factor of 8 is somewhat arbitrary. The goal is to prevent adding a
+ * relatively small header (4 Kbytes on x86) to a large-ish power-of-2 ring
+ * buffer size (such as 128 Kbytes) and so end up making a nearly twice as
+ * large allocation that will be almost half wasted. As a contrasting example,
+ * on ARM64 with 64 Kbyte page size, we don't want to take 64 Kbytes for the
+ * header from a 128 Kbyte allocation, leaving only 64 Kbytes for the ring.
+ * In this latter case, we must add 64 Kbytes for the header and not worry
+ * about what's wasted.
+ */
+#define VMBUS_HEADER_ADJ(payload_sz) \
+	((payload_sz) >=  8 * sizeof(struct hv_ring_buffer) ? \
+	0 : sizeof(struct hv_ring_buffer))
+
 /* Calculate the proper size of a ringbuffer, it must be page-aligned */
-#define VMBUS_RING_SIZE(payload_sz) PAGE_ALIGN(sizeof(struct hv_ring_buffer) + \
+#define VMBUS_RING_SIZE(payload_sz) PAGE_ALIGN(VMBUS_HEADER_ADJ(payload_sz) + \
 					       (payload_sz))
 
 struct hv_ring_buffer_info {


