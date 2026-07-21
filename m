Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA416400DE1;
	Tue, 21 Jul 2026 20:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665036; cv=none; b=aET6GqNk2LqRaA24isCGqgWzqTsR5cBAoJiAWdxwp/UlSpHXrF0QsiFmtVXop5IcZfaB4ePu290yZmefgZ0THbzOIzDVQpvmfo93dDEjCoS8VYtxOIJ6gsyt9RaEG74SQxgfNzozo0gNy1frRpc8FQv21FPNa0wcb1xHc+4Nn4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665036; c=relaxed/simple;
	bh=8DxQMIfuw6Og9BbAmNSmOcm2kcYxI//9rJVNXGX4KZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1sgBI3CFNji+nvehrNakgYiX6LPQqqcr2/Qb9ZV2C1TdQL+2fM9hxnT6LR1rKVs5WKxnIZ9SXDteiO+gYu0qrJQN28vaCexaYlfh0Ez3/yFHfKIJZ6ydOIDbS/YGyHosRvw9WbKdt1yKvSujvAm9dXZAstWr0wkVzxlHFAILc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pe5AISxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pe5AISxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAC11F000E9;
	Tue, 21 Jul 2026 20:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665034;
	bh=xg56uudmO+9IGnZES5p4ZUGZPX3Fi+kNXgRGIHvEHqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pe5AISxDUoO85rSanK9JXo/vZ8PK708YdShUWC0BrYQl/CV8lVQwC8j+dY/23y6k0
	 UMGdGhFyo/K8wr0HT2NVx0E//cFFzNt3joC6q0JsEKpjo6z4T7tbrkIGe/iTgdwYkh
	 04LicHW7L/Ou768FQlmIEbnRrjgnptmyxIIg6gTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Michael Bommarito <michael.bommarito@gmail.com>
Subject: [PATCH 6.6 0135/1266] hwrng: virtio: clamp device-reported used.len at copy_data()
Date: Tue, 21 Jul 2026 17:09:32 +0200
Message-ID: <20260721152444.828080367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit e3046eeada299f917a8ad883af4434bfb86556b1 upstream.

random_recv_done() stores the device-reported used.len directly into
vi->data_avail.  copy_data() then indexes vi->data[] using
vi->data_idx (advanced by previous copy_data() calls) and issues a
memcpy() without re-validating either value against the posted
buffer size sizeof(vi->data) (SMP_CACHE_BYTES bytes, typically 32
or 64).

A malicious or buggy virtio-rng backend can set used.len beyond
sizeof(vi->data), steering the memcpy() past the end of the inline
array into adjacent kmalloc-1k slab bytes.  hwrng_fillfn() mixes
those bytes into the guest RNG, and guest root can also observe
them directly via /dev/hwrng.

Concrete impact is inside the guest:

 - Memory-safety / hardening: any virtio-rng backend that
   over-reports used.len causes the driver to read past vi->data
   into unrelated slab contents.  hwrng_fillfn() is a kernel thread
   that runs as soon as the device is probed; no guest userspace
   interaction is required to first-trigger the OOB.

 - Cross-boundary leak (confidential-compute threat model): a
   malicious hypervisor cooperating with a malicious or compromised
   guest root userspace can use /dev/hwrng as a leak channel for
   guest-kernel heap data.  The host sets a large used.len, guest
   root reads /dev/hwrng, and the returned bytes contain guest
   kernel slab contents that were adjacent to vi->data.  In
   practice, confidential-compute guests (SEV-SNP, TDX) usually
   disable virtio-rng entirely, so this path is narrow, but the
   fix is still worth carrying because the underlying
   memory-safety bug contaminates the guest RNG on any host.

KASAN confirms the OOB on a 7.1-rc4 guest whose virtio-rng backend
has been patched to report used.len = 0x10000:

  BUG: KASAN: slab-out-of-bounds in virtio_read+0x394/0x5d0
  Read of size 64 at addr ffff88800ae0ba20 by task hwrng/52
  Call Trace:
   __asan_memcpy+0x23/0x60
   virtio_read+0x394/0x5d0
   hwrng_fillfn+0xb2/0x470
   kthread+0x2cc/0x3a0
  Allocated by task 1:
   probe_common+0xa5/0x660
   virtio_dev_probe+0x549/0xbc0
  The buggy address belongs to the object at ffff88800ae0b800
   which belongs to the cache kmalloc-1k of size 1024
  The buggy address is located 0 bytes to the right of
   allocated 544-byte region [ffff88800ae0b800, ffff88800ae0ba20)

Same class of bug as commit c04db81cd028 ("net/9p: Fix buffer
overflow in USB transport layer"), which hardened
usb9pfs_rx_complete() against unchecked device-reported length in
the USB 9p transport.

With the clamp at point of use and array_index_nospec() in place,
the same harness boots cleanly: copy_data() returns zero for the
bogus report, the device-supplied bytes after data_idx are
discarded, and the driver issues a fresh request.

Fixes: f7f510ec1957 ("virtio: An entropy device, as suggested by hpa.")
Cc: stable@vger.kernel.org
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260531142251.2792061-1-michael.bommarito@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/virtio-rng.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -7,6 +7,7 @@
 #include <asm/barrier.h>
 #include <linux/err.h>
 #include <linux/hw_random.h>
+#include <linux/nospec.h>
 #include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
@@ -66,8 +67,26 @@ static void request_entropy(struct virtr
 static unsigned int copy_data(struct virtrng_info *vi, void *buf,
 			      unsigned int size)
 {
-	size = min_t(unsigned int, size, vi->data_avail);
-	memcpy(buf, vi->data + vi->data_idx, size);
+	unsigned int idx, avail;
+
+	/*
+	 * vi->data_avail was set from the device-reported used.len and
+	 * vi->data_idx was advanced by previous copy_data() calls.  A
+	 * malicious or buggy virtio-rng backend can drive either past
+	 * sizeof(vi->data).  Clamp at point of use and harden the index
+	 * with array_index_nospec() so the memcpy() below cannot be
+	 * steered into adjacent slab memory, including under
+	 * speculation.
+	 */
+	avail = min_t(unsigned int, vi->data_avail, sizeof(vi->data));
+	if (vi->data_idx >= avail) {
+		vi->data_avail = 0;
+		request_entropy(vi);
+		return 0;
+	}
+	size = min_t(unsigned int, size, avail - vi->data_idx);
+	idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
+	memcpy(buf, vi->data + idx, size);
 	vi->data_idx += size;
 	vi->data_avail -= size;
 	if (vi->data_avail == 0)


