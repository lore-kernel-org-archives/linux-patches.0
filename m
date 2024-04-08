Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31457F467;
	Mon,  8 Apr 2024 13:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582325; cv=none; b=Lfe7kHoMYQurwAlI81ovsv6xF4w5ITLkpd7Z5S/zW3gmD6/Y7g4P+Y/Up8Um682Mdd00QgbidxbiLSV8KBQDzgpcuNF8Rti4F3d1DmYDrKARJquaAMdi1g2yue75UxYAbuI2HaOA534agBi7cE3CDdk8exkt/vy/BOXcFg3oVFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582325; c=relaxed/simple;
	bh=n32YBjL6va4hhJ7YKzqnFHbLhqGX1UjtnwED1fgWyuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wmq1RFQ6kxidzYcmZ+fIiDejIfvdxXah9ljOqKXK23XT6maWWosJa+1+RaOnODh6anm9BPPY8haw/Q4aCRVNrzRX0VKYcadAQF8nVYrLVK6KBmjgpQyY6z7LlVRjEvjl6pXSjv1t2XCaAxshUVYHHakir81NbfDb7MeDmkDnDvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9xSc69+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9xSc69+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38723C433F1;
	Mon,  8 Apr 2024 13:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582325;
	bh=n32YBjL6va4hhJ7YKzqnFHbLhqGX1UjtnwED1fgWyuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9xSc69+OjdZ9RBeAlzJ6W7tigloZbK5RecvAhwLkTo6/eIqtnHeJwvY3sY2ooNi3
	 q/YmTfxagllG2D47ql0p4sUklGR2n4BkheDQ8N+rBz6TKu/T6iZs/EyyuUSv59LoAA
	 C+2euGmz2ejUAN652Twf4cqqYwZyNGaN1Uh53foU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.15 121/690] Drivers: hv: vmbus: Calculate ring buffer size for more efficient use of memory
Date: Mon,  8 Apr 2024 14:49:47 +0200
Message-ID: <20240408125403.953233638@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


