Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0611CEE8E;
	Tue,  8 Oct 2024 12:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390633; cv=none; b=OBDyoO0OuDVjy7d18XaHNBjHRv/Zu41W6Pg9lJtqIO0c4TMgPuiczrvuBKeZqt2QbJiRdDQ6iScK7ZxKofy/ARisCPoVgxeslVC2053qpyYkPlANaaVr0ZCbE3PA6f+TskYxKd+1bbNBqnuB+b7q3NBeDBZ/ilvBB8+mCeg48NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390633; c=relaxed/simple;
	bh=SfmeqCPGZgXIknJg8Rzv41FVueGy+2mSLfN7nfbk7g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLDpEg2eDKyBy1Os/U1bA80E5xEMU32iKBQ5lzFX9IVSlfNMPIcqPC4mdgF4u6rE0G62KkLDIIzBfJF5b44/tObHaOVYP8JWPo610vbdLiCeYa8PO5Ggv9Mxr5Q78y0mPSsjVpp0Mu2g7oDNrC3TsmU0JNkb9samD1Lcyc95C14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lt1hrcbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lt1hrcbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8648EC4CEC7;
	Tue,  8 Oct 2024 12:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390632;
	bh=SfmeqCPGZgXIknJg8Rzv41FVueGy+2mSLfN7nfbk7g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lt1hrcbzbuGnD1nP19yrzLV8fXCDTUX3e6mogDdWUPoMMgD089SiFdtuCgLCvGPo2
	 8iZZXD9AwpG8IKMjjHos+jglKgUhz16LaFxxjSv9LRFbOa/r2uVqJg7hZHL3te8gD6
	 AIFFZ/he1up5cxkKI0fMhpq6y69LtWgWu/hZuxIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nam Cao <namcao@linutronix.de>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.10 345/482] of: address: Report error on resource bounds overflow
Date: Tue,  8 Oct 2024 14:06:48 +0200
Message-ID: <20241008115702.002271762@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 000f6d588a8f3d128f89351058dc04d38e54a327 upstream.

The members "start" and "end" of struct resource are of type
"resource_size_t" which can be 32bit wide.
Values read from OF however are always 64bit wide.
Avoid silently truncating the value and instead return an error value.

This can happen on real systems when the DT was created for a
PAE-enabled kernel and a non-PAE kernel is actually running.
For example with an arm defconfig and "qemu-system-arm -M virt".

Link: https://bugs.launchpad.net/qemu/+bug/1790975
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20240905-of-resource-overflow-v1-1-0cd8bb92cc1f@linutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -8,6 +8,7 @@
 #include <linux/logic_pio.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/pci_regs.h>
 #include <linux/sizes.h>
@@ -1061,7 +1062,11 @@ static int __of_address_to_resource(stru
 	if (of_mmio_is_nonposted(dev))
 		flags |= IORESOURCE_MEM_NONPOSTED;
 
+	if (overflows_type(taddr, r->start))
+		return -EOVERFLOW;
 	r->start = taddr;
+	if (overflows_type(taddr + size - 1, r->end))
+		return -EOVERFLOW;
 	r->end = taddr + size - 1;
 	r->flags = flags;
 	r->name = name ? name : dev->full_name;


