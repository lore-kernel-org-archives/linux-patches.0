Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C6A3AE198;
	Fri,  4 Sep 2026 05:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499124; cv=none; b=vE+NNaXFA9sh4A/n9H3UGtl1jodUwYimczmBkSscfliKX3vpd4zmsJlvKlMNKSW0X/G1QF3bkgNOaNuce4nhuCX022FqZk8MVNIxjVfnhD1ecjk4LNFO1V05jj4yJ5dQXqn+4/MNu6FPJczWaWB3qTKdKLYLQS5eVvLCWM+oNAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499124; c=relaxed/simple;
	bh=U6YCnOXF/bhParmaqAzuN1aXKao967d0JF2GSJxAdmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GFwGdljSq7Jd8ERhZWWWAHl6JxENz8EQsnde3u+yNMROlXOFZMG9OLc1w1Uf0JmZ3AU+RnBX3xeRdTNEkvjNnPl92vmACTHqubZFbDWi6lvrJg7yDDBqKzQmDvaxNJEurWrW4eqEHDCVG4O44tk0zLsgEDxy9phUOO6+qblVfwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kADI4RVf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kADI4RVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECC41F00A3E;
	Fri,  4 Sep 2026 05:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499123;
	bh=MQwE06u5BICF1fZ63a0xvAUwyHJYpSfNtIahvrLvI8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kADI4RVfkki4om7G66teHXi+KbWm4qczgCgipgQLtZTL1ErXm3nfO/5wkWlAHU4Mw
	 8Fww6JcH4LX33d/qiTWWWxiHjiV0cXwAbGZLdeeexUaJldp1mi4M0U8H6hSqU5S0d1
	 eJb1018uVZPqLr4p/SpBOawyl5HzCL5nLwM1ECjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 7.2 304/713] alpha/PCI: Fix I/O port accessor argument order in pci_legacy_write()
Date: Fri,  4 Sep 2026 06:54:32 +0200
Message-ID: <20260904045810.653867409@linuxfoundation.org>
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
@@ -224,17 +224,17 @@ int pci_legacy_write(struct pci_bus *bus
 
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


