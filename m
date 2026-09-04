Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A01C2F9DA1;
	Fri,  4 Sep 2026 05:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501015; cv=none; b=E1/trzjTucJphqu6usy3EEgpvF8Np/t2Jgk6ofu1jCWTMfwHm2zsNKTcK7dvpmPp1GML34J/cT1dBYSTNTJQqmZI/YHF10IvROJutHm/JncoQZFAc91QGXUAuhfh3r5qQ+mRSChmgbBk4bnWDRSvogrGWHnPmC1Czy+rrHF+ZFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501015; c=relaxed/simple;
	bh=FE75n9zjYLGFQUELJyd2B6fQLCWgS5fcTXscoyPG0DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TQM97d5neK5X7IsM4PmpWaOs5X2FaDgzm8/suABONdvmJx/jxqqENZ0wkdMqWAvHXRUgT1AsZoCk6lVQSMEx5xb4KNqCTKsHBiy7wp/z5LOxZvS0/2op1zQRL/GKnU/irp+kTSUStWp+GT90DAdGGJ76g/N610L2gA8rRkg2jiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvbHHB4A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvbHHB4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EE11F00A3D;
	Fri,  4 Sep 2026 05:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501014;
	bh=4CRDQa3x//dlQ3GsWojFZvN0MVP//ObqP/ODPvULXVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvbHHB4AaRM8eIY3BJ+Em22iHWela7Evvn1+f4XkwoODOk4fd/pHRWYH6vPgYNAAf
	 p+4oXN6gk6EnLKF7iGalYXvzW8JWZUEcZXTW5t2M3bcFB6lMLUSoz2YDLaKZDVtmkV
	 y4jAeLoEqkX1A5Zly8U7So2p8PKD9MUHyzsI2rxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 6.18 217/552] alpha/PCI: Fix I/O port accessor argument order in pci_legacy_write()
Date: Fri,  4 Sep 2026 06:56:14 +0200
Message-ID: <20260904045754.414678766@linuxfoundation.org>
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


