Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B49F2DCF57;
	Fri,  4 Sep 2026 05:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499752; cv=none; b=epzVyVB/1rQLi095Etx70+PaSJBqukWtBFycEjjtVy6Dy0vTnG7KxKC2BBdvG9I2bhY3VExQv1QeXTdmnMk9U9VMnxQ1ercuNjTH5BxnmdNYAzNM3qogIJbneLZG7ZFQfBSMdnUMeScfP/8RgAJH/iuklkp3JhS93YatRsxfkTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499752; c=relaxed/simple;
	bh=LSeoExRj9B4/9fEmukOJ3oh0sabY4RghKzFpsrUcfGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tyjfLk5Rg4habmmG4EfdxVMBieQafe089L1msaQSIzdZBvCyMpRpYF67BOcheWO92QENNhUrdUrCHrv8CFuww6EXBZ4kZuXJQ6Ex9ZJokIiYCreOrQzKHKLl02u4H4xRmNJKnAaZ3yqchIHOqZCtHJEXYUhBTNh4jVAZN8tMe6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVfPEnJP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVfPEnJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F741F00A3D;
	Fri,  4 Sep 2026 05:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499751;
	bh=3D3cdrubA6Xa/yONvqa9/FQwVRWTfFf6xY61BD6grqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVfPEnJPD6IzfqiNbwACOHLN2eBW76Ros9pU0E3dr2uh6L9XyX27zCbxxMUEC540k
	 HQsneENRft6iHCvVQYVchET3VWrWmsVWCL+qsSkzC32JgIj83oMzO5sA17YIUGNQK8
	 pHDtIEAVQMxwObfAlTKmmN3lerylJ3Opv6N0xk/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 7.2 527/713] PCI/sysfs: Fix read byte order in pci_read_legacy_io()
Date: Fri,  4 Sep 2026 06:58:15 +0200
Message-ID: <20260904045815.633419531@linuxfoundation.org>
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
@@ -888,12 +888,30 @@ static ssize_t pci_read_legacy_io(struct
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


