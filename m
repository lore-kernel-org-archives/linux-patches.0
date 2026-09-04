Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DF018D636;
	Fri,  4 Sep 2026 05:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501542; cv=none; b=ooTsV57nD/OlHnYZJVEEfTIvHC5IFWB/JGQbfbxONwCGTtwErBWv0Sb+b+5txvCpDy44bV04OojliUhJmrOLQbTkEsGPcm1NswkPyUXb4gb/3z7VZI1F+h0aCjdxKH2be/2yEtdVj+IKaayuDAuX+v+5ATCS26ZmfuG/8Ud2cFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501542; c=relaxed/simple;
	bh=8glW3PpjqExESwuCcgCRGaPEjsyS3HlTP/XBFfr4rqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YMuGpV04SXpRI/M3optXlrp+aFZ+Y6D4/N57yLZzaA2weQTNYc8AHJLpNRkizW4FDf16phafJ0uJrgIbMXoNIxrpLArl6sqVJACfLUuTSoWYSjLuNFp9vVC5Wo19pSVA6AF8pcunIUA9dcc3bgV11L3DSz1gHcX5Dve3YVfGAWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1vktKbu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1vktKbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9727E1F00A3D;
	Fri,  4 Sep 2026 05:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501541;
	bh=OyH/N1IZ4Zc74JAqoomlqwzxZADQAg6OvkYWeU7Ze8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1vktKbuZOysSj5jo8AUUIR/es+AeWDYRNAFM5iblysiAt2AF81l/q+qN5HBEV5Jl
	 ckagVHTRyNRZQyXLhai71Sa9htLYMU9bIDzwAiHqM5AQfDP7AZeLpGxL1Pgx+HL+HD
	 vF7GpQripSKuj0yatz2nUMNuxQGCWKC5CPYypt9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.18 392/552] PCI/sysfs: Fix read byte order in pci_read_legacy_io()
Date: Fri,  4 Sep 2026 06:59:09 +0200
Message-ID: <20260904045759.107316360@linuxfoundation.org>
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

commit 5b95212de6dcd7e0275cea7f894fe7226c7d9f29 upstream.

pci_read_legacy_io() passes the sysfs buffer directly to pci_legacy_read():

  return pci_legacy_read(bus, off, (u32 *)buf, count);

The PowerPC implementation stores the result as a native-endian integer:

  *((u16 *)val) = in_le16(addr);

On big-endian PowerPC this stores the bytes in the wrong order, so
a 2-byte read of a device register returns different bytes than two
1-byte reads at the same addresses.  The same applies to 4-byte
reads.  On little-endian the native byte order already matches PCI
I/O port byte order, so the conversion is a no-op.

Thus, let pci_legacy_read() store into a local u32 variable, then
copy the I/O port value to the sysfs buffer using put_unaligned_le16()
and put_unaligned_le32() for the 2 and 4 byte cases, converting from
the native integer to little-endian byte order matching PCI I/O port
space.

No changes are needed for the Alpha platform.

The legacy_io file is root-only and exists only on Alpha and PowerPC,
the two architectures that define HAVE_PCI_LEGACY.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260616163131.2763281-2-kwilczynski@kernel.org
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-sysfs.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -906,12 +906,30 @@ static ssize_t pci_read_legacy_io(struct
 				  char *buf, loff_t off, size_t count)
 {
 	struct pci_bus *bus = to_pci_bus(kobj_to_dev(kobj));
+	u32 val = 0;
+	int ret;
 
 	/* Only support 1, 2 or 4 byte accesses */
 	if (count != 1 && count != 2 && count != 4)
 		return -EINVAL;
 
-	return pci_legacy_read(bus, off, (u32 *)buf, count);
+	ret = pci_legacy_read(bus, off, &val, count);
+	if (ret < 0)
+		return ret;
+
+	switch (count) {
+	case 1:
+		buf[0] = *(u8 *)&val;
+		break;
+	case 2:
+		put_unaligned_le16(*(u16 *)&val, buf);
+		break;
+	case 4:
+		put_unaligned_le32(val, buf);
+		break;
+	}
+
+	return ret;
 }
 
 /**


