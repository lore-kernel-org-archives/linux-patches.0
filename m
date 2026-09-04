Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3564E426D37;
	Fri,  4 Sep 2026 06:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502686; cv=none; b=Up1qpfhrabBAgZE4jPfkkX9+wv1FNM4kxGuZTs8qPrnBp0XtbWx4OOIYTGnHRZ7xHkHsG8sNDb56C9TFfFDWCy8HzNkCOP1K21QZfNP9gpomes9m/MLKBLOpGlz9HdaLYXR8NMD/SrvMIA9jLEzGmurTq1SYZ+P05UuRCWWc/T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502686; c=relaxed/simple;
	bh=x9Cy9cd6VlFzgShu1QrvS/6Imxa6uVVjRwpqiemBrx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qS7T6n+0HUMPzW0Y/0REgVl2BbpTuh/XqIxzeUMk5sA9Yw00FEZqGq+3YqjMSNgWk3XbNxpWXtvXCxOoTYtUPBI2iaXLdO7ea6aRE1gVR6UDUy0nf/9nw5mKrFXQMMoxs5sfqCQrOn1jgVUY9jQcHFMdz8rl27a3FogPguawMbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuWRTsMB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuWRTsMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C511F00A3D;
	Fri,  4 Sep 2026 06:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502684;
	bh=JuKGDFr17A9poCJsmP+3IZyH1dblpYFdux+/Q7H9s/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuWRTsMB6aG8gU8z/MYjUnrpwlk/GuAzegBZz9cc57fhi0kB1r6s1c3SVgYOp3tpc
	 uXqLGEaA48I7Bu6CCIKGSqBD6tdZydazl+R5+mneLmuzNbW4kTIsOwt4Q9oCEqzGYj
	 FJhT1zwW7JBqYwAdPtiOKr/z6Ez8JYBMgDPtwPAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.12 294/403] PCI/sysfs: Fix read byte order in pci_read_legacy_io()
Date: Fri,  4 Sep 2026 07:01:37 +0200
Message-ID: <20260904045741.533236092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -882,12 +882,30 @@ static ssize_t pci_read_legacy_io(struct
 				  loff_t off, size_t count)
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


