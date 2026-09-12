Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAB5242D65;
	Sat, 12 Sep 2026 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227019; cv=none; b=eyNbK6so5C9/W0MKfjN2OvxEk4zJzdCwP9Y3KeOSx9yk2u7y/fi5OY7VCuR5ox9e1gTK3SjQz2/BTmnP0boHo3xPa/J4jT4rRCutNWKEpr5Jlt+eC+1Wdu3kYj/VCbaoX9L8UXaFmBo696VDB9zxbYoJehT922poe54GJLBOWns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227019; c=relaxed/simple;
	bh=HR+rJCEDRObBmKGVhYLaysQT6AMMoXo7gV3HICZDb8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3MqAWLx+yr7E7siafEp1Aq6Rho0cdmYyMubbY6mNTBlK+md4BtWRHYuabSeRK+H/75o8v2hhRGLrartKqyRjg4EqWoG0LjL830hg8mOEOm55vnxndGmxa+XwSxhCx2wNJQ0ANfgvH/HwIbSQ40zoxsWNYaQT58rXajiu0L/XkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgRte3Ns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgRte3Ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB511F000FF;
	Sat, 12 Sep 2026 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227018;
	bh=DacsHehfYtCiM1WHkTotHplM/QdNGC/i6DhdvKHgsfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgRte3Nsof5iDVWpIR0WxTzk6OGni6EX1w173Vu/9rU0cgUBflMRh7agu5W8yccYf
	 YLpereBsITjwqC3m4GAXTcH9+DF6MXo4SaRfHe4Qw81H7+gCFYqa1+x6ioRKDxmXzY
	 NYFgD04FadCBIzDqSp3+pZBdkPZ52YEOqAKA90l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 6.1 0094/1191] alpha/PCI: Fix I/O port accessor argument order in pci_legacy_write()
Date: Sat, 12 Sep 2026 08:47:02 +0200
Message-ID: <20260912065550.290606206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


