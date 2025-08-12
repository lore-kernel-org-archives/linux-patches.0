Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564A82F6573;
	Tue, 12 Aug 2025 18:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025142; cv=none; b=iseDRwDRPOm8b/DCAPx6GvMv9+dGm6uB32o0EXZbuQr3cQRdkD8b4pT1rwjGtpIlBYcgJqzAnNlptOfqLbAM/hYfa3jDwofjg8sANLDVZnDWSWJGQckUS7Z/ot/i2lMtgL4NEGHDyPE88lZyISBVIJDvneyFSf7qEdVolDn0t6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025142; c=relaxed/simple;
	bh=rtWUbJPl/O+moSQbDX3QRLq18Q801z3zEamqiWTrLHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfnySOsOS4PvKY+1y08D3dYfusSYji7SN3uyfigBaat+p1uey0Ze574MoP7Fob/e0mKM0TpUqF6UP/Dx2hV6QDxguCJyzUzDBHne/HLyV2v/95FqKZ79ix3rTKKvroQbFoSo43pDjh9ApCxUR3RVVDNUswK/BTNilZirHIHVdgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yBk9Prh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yBk9Prh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8F5C4CEF0;
	Tue, 12 Aug 2025 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025142;
	bh=rtWUbJPl/O+moSQbDX3QRLq18Q801z3zEamqiWTrLHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yBk9PrhjIVxT/SydGE5pI44HGyHS+dllYl/aQuZf9j7ZPLPvCZOYiCiTguHMZAG7
	 XJb20rnQ/XJBo6nNI4v/LGYc9+w8+keBBFCGqxdQ03mzXglEdSBNiDtVYmcynH7pVj
	 JGc4i2uwXJ4ecLJzFUPwLAWP6w1HBz5AgLV+vDW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.16 581/627] selftests/perf_events: Add a mmap() correctness test
Date: Tue, 12 Aug 2025 19:34:36 +0200
Message-ID: <20250812173453.973734518@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 084d2ac4030c5919e85bba1f4af26e33491469cb upstream.

Exercise various mmap(), munmap() and mremap() invocations, which might
cause a perf buffer mapping to be split or truncated.

To avoid hard coding the perf event and having dependencies on
architectures and configuration options, scan through event types in sysfs
and try to open them. On success, try to mmap() and if that succeeds try to
mmap() the AUX buffer.

In case that no AUX buffer supporting event is found, only test the base
buffer mapping. If no mappable event is found or permissions are not
sufficient, skip the tests.

Reserve a PROT_NONE region for both rb and aux tests to allow testing the
case where mremap unmaps beyond the end of a mapped VMA to prevent it from
unmapping unrelated mappings.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Co-developed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/perf_events/.gitignore |    1 
 tools/testing/selftests/perf_events/Makefile   |    2 
 tools/testing/selftests/perf_events/mmap.c     |  236 +++++++++++++++++++++++++
 3 files changed, 238 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/perf_events/mmap.c

--- a/tools/testing/selftests/perf_events/.gitignore
+++ b/tools/testing/selftests/perf_events/.gitignore
@@ -2,3 +2,4 @@
 sigtrap_threads
 remove_on_exec
 watermark_signal
+mmap
--- a/tools/testing/selftests/perf_events/Makefile
+++ b/tools/testing/selftests/perf_events/Makefile
@@ -2,5 +2,5 @@
 CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 LDFLAGS += -lpthread
 
-TEST_GEN_PROGS := sigtrap_threads remove_on_exec watermark_signal
+TEST_GEN_PROGS := sigtrap_threads remove_on_exec watermark_signal mmap
 include ../lib.mk
--- /dev/null
+++ b/tools/testing/selftests/perf_events/mmap.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE
+
+#include <dirent.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+
+#include <linux/perf_event.h>
+
+#include "../kselftest_harness.h"
+
+#define RB_SIZE		0x3000
+#define AUX_SIZE	0x10000
+#define AUX_OFFS	0x4000
+
+#define HOLE_SIZE	0x1000
+
+/* Reserve space for rb, aux with space for shrink-beyond-vma testing. */
+#define REGION_SIZE	(2 * RB_SIZE + 2 * AUX_SIZE)
+#define REGION_AUX_OFFS (2 * RB_SIZE)
+
+#define MAP_BASE	1
+#define MAP_AUX		2
+
+#define EVENT_SRC_DIR	"/sys/bus/event_source/devices"
+
+FIXTURE(perf_mmap)
+{
+	int		fd;
+	void		*ptr;
+	void		*region;
+};
+
+FIXTURE_VARIANT(perf_mmap)
+{
+	bool		aux;
+	unsigned long	ptr_size;
+};
+
+FIXTURE_VARIANT_ADD(perf_mmap, rb)
+{
+	.aux = false,
+	.ptr_size = RB_SIZE,
+};
+
+FIXTURE_VARIANT_ADD(perf_mmap, aux)
+{
+	.aux = true,
+	.ptr_size = AUX_SIZE,
+};
+
+static bool read_event_type(struct dirent *dent, __u32 *type)
+{
+	char typefn[512];
+	FILE *fp;
+	int res;
+
+	snprintf(typefn, sizeof(typefn), "%s/%s/type", EVENT_SRC_DIR, dent->d_name);
+	fp = fopen(typefn, "r");
+	if (!fp)
+		return false;
+
+	res = fscanf(fp, "%u", type);
+	fclose(fp);
+	return res > 0;
+}
+
+FIXTURE_SETUP(perf_mmap)
+{
+	struct perf_event_attr attr = {
+		.size		= sizeof(attr),
+		.disabled	= 1,
+		.exclude_kernel	= 1,
+		.exclude_hv	= 1,
+	};
+	struct perf_event_attr attr_ok = {};
+	unsigned int eacces = 0, map = 0;
+	struct perf_event_mmap_page *rb;
+	struct dirent *dent;
+	void *aux, *region;
+	DIR *dir;
+
+	self->ptr = NULL;
+
+	dir = opendir(EVENT_SRC_DIR);
+	if (!dir)
+		SKIP(return, "perf not available.");
+
+	region = mmap(NULL, REGION_SIZE, PROT_NONE, MAP_ANON | MAP_PRIVATE, -1, 0);
+	ASSERT_NE(region, MAP_FAILED);
+	self->region = region;
+
+	// Try to find a suitable event on this system
+	while ((dent = readdir(dir))) {
+		int fd;
+
+		if (!read_event_type(dent, &attr.type))
+			continue;
+
+		fd = syscall(SYS_perf_event_open, &attr, 0, -1, -1, 0);
+		if (fd < 0) {
+			if (errno == EACCES)
+				eacces++;
+			continue;
+		}
+
+		// Check whether the event supports mmap()
+		rb = mmap(region, RB_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED, fd, 0);
+		if (rb == MAP_FAILED) {
+			close(fd);
+			continue;
+		}
+
+		if (!map) {
+			// Save the event in case that no AUX capable event is found
+			attr_ok = attr;
+			map = MAP_BASE;
+		}
+
+		if (!variant->aux)
+			continue;
+
+		rb->aux_offset = AUX_OFFS;
+		rb->aux_size = AUX_SIZE;
+
+		// Check whether it supports a AUX buffer
+		aux = mmap(region + REGION_AUX_OFFS, AUX_SIZE, PROT_READ | PROT_WRITE,
+			   MAP_SHARED | MAP_FIXED, fd, AUX_OFFS);
+		if (aux == MAP_FAILED) {
+			munmap(rb, RB_SIZE);
+			close(fd);
+			continue;
+		}
+
+		attr_ok = attr;
+		map = MAP_AUX;
+		munmap(aux, AUX_SIZE);
+		munmap(rb, RB_SIZE);
+		close(fd);
+		break;
+	}
+	closedir(dir);
+
+	if (!map) {
+		if (!eacces)
+			SKIP(return, "No mappable perf event found.");
+		else
+			SKIP(return, "No permissions for perf_event_open()");
+	}
+
+	self->fd = syscall(SYS_perf_event_open, &attr_ok, 0, -1, -1, 0);
+	ASSERT_NE(self->fd, -1);
+
+	rb = mmap(region, RB_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED, self->fd, 0);
+	ASSERT_NE(rb, MAP_FAILED);
+
+	if (!variant->aux) {
+		self->ptr = rb;
+		return;
+	}
+
+	if (map != MAP_AUX)
+		SKIP(return, "No AUX event found.");
+
+	rb->aux_offset = AUX_OFFS;
+	rb->aux_size = AUX_SIZE;
+	aux = mmap(region + REGION_AUX_OFFS, AUX_SIZE, PROT_READ | PROT_WRITE,
+		   MAP_SHARED | MAP_FIXED, self->fd, AUX_OFFS);
+	ASSERT_NE(aux, MAP_FAILED);
+	self->ptr = aux;
+}
+
+FIXTURE_TEARDOWN(perf_mmap)
+{
+	ASSERT_EQ(munmap(self->region, REGION_SIZE), 0);
+	if (self->fd != -1)
+		ASSERT_EQ(close(self->fd), 0);
+}
+
+TEST_F(perf_mmap, remap)
+{
+	void *tmp, *ptr = self->ptr;
+	unsigned long size = variant->ptr_size;
+
+	// Test the invalid remaps
+	ASSERT_EQ(mremap(ptr, size, HOLE_SIZE, MREMAP_MAYMOVE), MAP_FAILED);
+	ASSERT_EQ(mremap(ptr + HOLE_SIZE, size, HOLE_SIZE, MREMAP_MAYMOVE), MAP_FAILED);
+	ASSERT_EQ(mremap(ptr + size - HOLE_SIZE, HOLE_SIZE, size, MREMAP_MAYMOVE), MAP_FAILED);
+	// Shrink the end of the mapping such that we only unmap past end of the VMA,
+	// which should succeed and poke a hole into the PROT_NONE region
+	ASSERT_NE(mremap(ptr + size - HOLE_SIZE, size, HOLE_SIZE, MREMAP_MAYMOVE), MAP_FAILED);
+
+	// Remap the whole buffer to a new address
+	tmp = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(tmp, MAP_FAILED);
+
+	// Try splitting offset 1 hole size into VMA, this should fail
+	ASSERT_EQ(mremap(ptr + HOLE_SIZE, size - HOLE_SIZE, size - HOLE_SIZE,
+			 MREMAP_MAYMOVE | MREMAP_FIXED, tmp), MAP_FAILED);
+	// Remapping the whole thing should succeed fine
+	ptr = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tmp);
+	ASSERT_EQ(ptr, tmp);
+	ASSERT_EQ(munmap(tmp, size), 0);
+}
+
+TEST_F(perf_mmap, unmap)
+{
+	unsigned long size = variant->ptr_size;
+
+	// Try to poke holes into the mappings
+	ASSERT_NE(munmap(self->ptr, HOLE_SIZE), 0);
+	ASSERT_NE(munmap(self->ptr + HOLE_SIZE, HOLE_SIZE), 0);
+	ASSERT_NE(munmap(self->ptr + size - HOLE_SIZE, HOLE_SIZE), 0);
+}
+
+TEST_F(perf_mmap, map)
+{
+	unsigned long size = variant->ptr_size;
+
+	// Try to poke holes into the mappings by mapping anonymous memory over it
+	ASSERT_EQ(mmap(self->ptr, HOLE_SIZE, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0), MAP_FAILED);
+	ASSERT_EQ(mmap(self->ptr + HOLE_SIZE, HOLE_SIZE, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0), MAP_FAILED);
+	ASSERT_EQ(mmap(self->ptr + size - HOLE_SIZE, HOLE_SIZE, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0), MAP_FAILED);
+}
+
+TEST_HARNESS_MAIN


