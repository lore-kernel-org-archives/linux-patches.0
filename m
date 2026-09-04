Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D2D4CCDC7;
	Fri,  4 Sep 2026 05:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500539; cv=none; b=eHl32QfxSMumgIhT/W6/XJi/qqoW3KL1372ZQiZjwp/zdkdJioMqkyonHhcoPxsNBTMpT4X3vGxLNYIVhhd+cVmPSZUQn+/33+uaX0lnbZ7l9TIkTk2RCrATK7xC6ZZuVS5vE+RZIuaqdraL07UHCoeVGOoF/U4Qj+pKZ23r97w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500539; c=relaxed/simple;
	bh=CUNPZJKR8zvr8rSmZnv6kusiFKqVx0SWWNFkMIgrx5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCYZsuqT+WAslBHK8F21D44gC1wObDZkNVqssoHS5+exhhT3O/8A8eKr934Uc82pF/kGfx/Yt3WMDOD0VtBTrNIxnDrlKxgySfXfwNKlpZb4lmQqIAo4rbok1WdsTpynQ/3i+2/axsL066Z7J0+OVOjCssG6IfGAMMEg+EkaoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nH66cQfG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nH66cQfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77FB1F00A3D;
	Fri,  4 Sep 2026 05:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500538;
	bh=1Tvc8Ksz3nWOgmCfzNIsOruyOKSqmS3USnNp6HC84DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nH66cQfGvr9XWg/luoBYxtSDT9MDmXC5QfUXwlxX6cK0QF4LEsRK8ZdB/bXWGLKN3
	 HjoVoRqr1QwLeQUVlv4WZbG99/ZsPxRMWsg5NDvjkVxP2A2X/BjAnebHJA4TJSeWzD
	 pCSR/QLIDL2lUArQkYnRoWkJ2Nvok1TPzJEKFmDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.18 092/552] PCI/sysfs: Fix out-of-bounds read in pci_write_legacy_io()
Date: Fri,  4 Sep 2026 06:54:09 +0200
Message-ID: <20260904045749.965729678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -931,12 +931,24 @@ static ssize_t pci_write_legacy_io(struc
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


