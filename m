Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEE81AA1F4;
	Fri,  4 Sep 2026 05:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498743; cv=none; b=WB6RZylgtZQCCfxVOSyh7gh0Fa1gpaqbQhN/BOF7n/emEPmfvVCfeRzg9xY+FwZatK+W0fy/XHHR/alwO3yGrbCdoqRW1WNpHsIJ4QnQ0AWQOCNSNUA65OQBGZ5bQfLqaIbFhmZDQdnSDeAKumWWc2JIeXcFyqUPbHf7unOAC1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498743; c=relaxed/simple;
	bh=r4aeQoj9xl2VWXsZ48+ps1bgAmOz0laZusl0ujJtOKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nk7Q3gdzqk2Rql475p5wFb0J6qnIbW59AUGQhfiRAQQrzbgntLtjL4Mh5eyRDxt5hzSQ074qoKYBj9mQX7vtfoC2mF7JVGQWAvG622JFGSa8VrxVgwgsDVCSAHa8fHeoIL9PcxqjL7r1U3pKvDtz1adyyiSbzaVosYXRp+QenSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyPBpHNE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyPBpHNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64841F00A3D;
	Fri,  4 Sep 2026 05:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498742;
	bh=0tX/TejKp2oPtw7yV+9kSPnYsu4fN6Y8uyN9SK5yR6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LyPBpHNESVbvzy11HxgZlq2hzmM8TCxh7ekFy7ZqHWdrKVHYdka61VP9GRbfb3TUK
	 nnRh+nVWL6n0OUq0H2sHAIjiAkwcj/4ONbKp3GtC6fasTm1HxCsYhtTV7Ywd/pV9gM
	 pBAbfLygWXojVc7gOW5p3t/sWlLIjvOs3ixVIUfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 7.2 128/713] PCI/sysfs: Fix out-of-bounds read in pci_write_legacy_io()
Date: Fri,  4 Sep 2026 06:51:36 +0200
Message-ID: <20260904045806.702116419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

commit dc76258d0132df1d831a5a29758bd448ca9c566e upstream.

pci_write_legacy_io() loads 4 bytes from the kernfs write buffer
regardless of how many bytes userspace wrote:

  if (count != 1 && count != 2 && count != 4)
          return -EINVAL;

  return pci_legacy_write(bus, off, *(u32 *)buf, count);

kernfs_fop_write_iter() allocates the buffer with kmalloc(len + 1),
so a 1-byte write to the legacy_io sysfs file allocates 2 bytes and
the unconditional u32 load reads up to 2 bytes past the end of the
allocation, which KASAN reports as a slab-out-of-bounds read.
Similarly, a 2-byte write overreads by 1 byte.

Thus, read only the number of bytes requested using get_unaligned_le16()
and get_unaligned_le32() for the 2 and 4 byte cases, interpreting the
buffer as little-endian to match the byte ordering of PCI I/O port
space.

The PowerPC implementation previously compensated for the generic
code's native-endian 32-bit load by shifting the value into place
for the 1 and 2 byte cases.  The shifts were only correct on
big-endian kernels.

On little-endian PowerPC (POWER8 and later), they extracted the wrong
bytes, so a 1-byte write wrote an out-of-bounds byte instead of the
requested value.  On big-endian, the native load also caused out_le16()
and out_le32() to reverse the user's bytes on the wire for 2 and 4 byte
writes.  The little-endian helpers resolve both issues, so the shifts
are removed.

No changes are needed for the Alpha platform.

The legacy_io file is root-only and exists only on Alpha and PowerPC,
the two architectures that define HAVE_PCI_LEGACY.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260616163131.2763281-1-kwilczynski@kernel.org
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/pci-common.c |    9 ++-------
 drivers/pci/pci-sysfs.c          |   18 +++++++++++++++---
 2 files changed, 17 insertions(+), 10 deletions(-)

--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -626,19 +626,14 @@ int pci_legacy_write(struct pci_bus *bus
 		return -ENXIO;
 	addr = hose->io_base_virt + port;
 
-	/* WARNING: The generic code is idiotic. It gets passed a pointer
-	 * to what can be a 1, 2 or 4 byte quantity and always reads that
-	 * as a u32, which means that we have to correct the location of
-	 * the data read within those 32 bits for size 1 and 2
-	 */
 	switch(size) {
 	case 1:
-		out_8(addr, val >> 24);
+		out_8(addr, val);
 		return 1;
 	case 2:
 		if (port & 1)
 			return -EINVAL;
-		out_le16(addr, val >> 16);
+		out_le16(addr, val);
 		return 2;
 	case 4:
 		if (port & 3)
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -913,12 +913,24 @@ static ssize_t pci_write_legacy_io(struc
 				   char *buf, loff_t off, size_t count)
 {
 	struct pci_bus *bus = to_pci_bus(kobj_to_dev(kobj));
+	u32 val;
 
-	/* Only support 1, 2 or 4 byte accesses */
-	if (count != 1 && count != 2 && count != 4)
+	/* Only support 1, 2 or 4 byte accesses. */
+	switch (count) {
+	case 1:
+		val = *(u8 *)buf;
+		break;
+	case 2:
+		val = get_unaligned_le16(buf);
+		break;
+	case 4:
+		val = get_unaligned_le32(buf);
+		break;
+	default:
 		return -EINVAL;
+	}
 
-	return pci_legacy_write(bus, off, *(u32 *)buf, count);
+	return pci_legacy_write(bus, off, val, count);
 }
 
 /**


