Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8521247887F;
	Sat, 12 Sep 2026 13:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220124; cv=none; b=dIVM5LaLWKStkCMOeh69QuH7xQonKa8JTvnZCmFs7rBY7JA+GzLp2MOhZn8Mz2Br1bqTofiZ2Imu7InPXINoFdZnODkwtfWBVabRASyde8FLKzaKHVnOtlCaWEbM0vWoY1zW5XRhZ6A/K6bZNDFIvks6aXLcdshWHzEP5PBX08o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220124; c=relaxed/simple;
	bh=rEDj4x0C6gC9Pv+3ov8C9CAHCO0xtgGXAC+MO90BTBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JxQCqSHeKZ5K4N91B2tdoDQHjZggbaXJX6RWTNga9Za54uMjGSqH3gwXBVc09Jq5cqvVZ6o6G3pfLAPq8IxqWiVRLH1jhs7sHyOwL1scVkjhBPVKMT24Eoa1ILkRjuj/J8k69soOpbemuo8D+MuyGSFKNZPIfQnDNJaRtnWE124=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTEUm4JD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTEUm4JD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3265A1F000FF;
	Sat, 12 Sep 2026 13:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220123;
	bh=DeUkKZ4oV4Z5D0aNxMTLKvrN8dF5Q0NHhaYrlzxfIHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTEUm4JDdcHnxIU7BVEVWjHFnXi+PNFzfjXjkcfKd4krmUjTTKwNR7nlAEbMrS+Ae
	 TF0iXCdPOKzSf1oqxfImhGJtngtAJv+w+vEEz6FSWSJfuO+FeYYH01aHm+t2I4HqaI
	 cCbOBZRL2XE9ox4hr329mUyhyhn89h1jaq3PNWOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 6.6 0111/1424] alpha/PCI: Fix I/O port accessor argument order in pci_legacy_write()
Date: Sat, 12 Sep 2026 08:42:23 +0200
Message-ID: <20260912065609.792040545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

commit 651fb94aaf245430590216d497fb8b02dd73d5f9 upstream.

pci_legacy_write() in arch/alpha/kernel/pci-sysfs.c passes its arguments to
outb(), outw() and outl() in the wrong order:

  outb(port, val);

The Alpha I/O accessors in arch/alpha/include/asm/io.h take the value first
and the port second:

  extern void outb(u8 b, unsigned long port);

So the port number is written as data to the I/O address taken from the
user-supplied value, and the intended write to the requested port never
happens.

The arguments have been reversed since the file was added, and the function
returns the access size regardless, so the caller sees success while the
requested port is left untouched.

Fixes: 10a0ef39fbd1 ("PCI/alpha: pci sysfs resources")
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Acked-by: Magnus Lindholm <linmag7@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260706175423.98305-1-kwilczynski@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/pci-sysfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/alpha/kernel/pci-sysfs.c
+++ b/arch/alpha/kernel/pci-sysfs.c
@@ -364,17 +364,17 @@ int pci_legacy_write(struct pci_bus *bus
 
 	switch(size) {
 	case 1:
-		outb(port, val);
+		outb(val, port);
 		return 1;
 	case 2:
 		if (port & 1)
 			return -EINVAL;
-		outw(port, val);
+		outw(val, port);
 		return 2;
 	case 4:
 		if (port & 3)
 			return -EINVAL;
-		outl(port, val);
+		outl(val, port);
 		return 4;
 	}
 	return -EINVAL;


