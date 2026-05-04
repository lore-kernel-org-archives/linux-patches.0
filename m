Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012871ADC83;
	Mon,  4 May 2026 14:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903704; cv=none; b=izjjI5rDRASwi5AoXTq77LNOPpZcDrDUG5WtMWkaaYxLTH0SN3wts2doBJ1UzvhAUg2ghr/10szSYj9/xN2W/76+l2gh2FW+udzPnSAJP8DYDJBxLshpuG9QGn9aNSXUjXN5oTVP02qRTV5vfk3y24HtbKwqT0jvAyISH7CTZmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903704; c=relaxed/simple;
	bh=oDpr51HeQrE3rWdC5vyEW90p+d3Pq6QR6YBuUPR41uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQNriB4rB/p94QDkyYZRBGuAWRucxHIW7S9VMz31J3SXvmt2QCkKnHC1gJMHNkDEcHwVzRAjPteCEQz/rfLErdHpCstJ0AehnGzoxhxhocfD2juWq4E5DtTsNPUtrxQ5Y0l/DZvO8JgXDC4iE59ZnSNT0Ge91FlEb3zXYjoNTK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnyNIpTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnyNIpTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A64FC2BCB8;
	Mon,  4 May 2026 14:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903703;
	bh=oDpr51HeQrE3rWdC5vyEW90p+d3Pq6QR6YBuUPR41uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnyNIpTHYlA6onEngWit5gtH15rdiJyaF5p0tMuKXSghifKuEaKhTsHEesfQ/4iYb
	 m6SOdUw0g9zOG231nwT7nJxC5+Lx5Cs2Cqhgbcsxv2QI3lcehR2VOzM7fDgjl4dW7F
	 BvLbx9bqx8cl+Yevv/4AU9LfB0+xEp28DtMsc8xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	David Matlack <dmatlack@google.com>,
	Manish Honap <mhonap@nvidia.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.18 030/275] vfio: selftests: Fix VLA initialisation in vfio_pci_irq_set()
Date: Mon,  4 May 2026 15:49:30 +0200
Message-ID: <20260504135144.057224055@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Honap <mhonap@nvidia.com>

commit 4f42d716707654134789a0205a050b0d022be948 upstream.

C does not permit an initialiser expression on a variable-length array
(C99 Section 6.7.9 constraint: "The type of the entity to be initialized
shall not be a variable length array type").

vfio_pci_irq_set() declared:

      u8 buf[sizeof(struct vfio_irq_set) + sizeof(int) * count] = {};

where `count` is a runtime function parameter, making `buf` a VLA.

GCC rejects this with (tried with GCC-9.4.0):

      error: variable-sized object may not be initialized

Fix by removing the `= {}` initialiser and inserting an explicit
memset() immediately after the declaration.  memset() on a VLA is
perfectly legal and achieves the same zero-initialisation on all
conforming C implementations.

Fixes: 19faf6fd969c ("vfio: selftests: Add a helper library for VFIO selftests")
Cc: stable@vger.kernel.org
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
Link: https://lore.kernel.org/r/20260317051402.3725670-1-mhonap@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vfio/lib/vfio_pci_device.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -303,10 +303,12 @@ iova_t to_iova(struct vfio_pci_device *d
 static void vfio_pci_irq_set(struct vfio_pci_device *device,
 			     u32 index, u32 vector, u32 count, int *fds)
 {
-	u8 buf[sizeof(struct vfio_irq_set) + sizeof(int) * count] = {};
+	u8 buf[sizeof(struct vfio_irq_set) + sizeof(int) * count];
 	struct vfio_irq_set *irq = (void *)&buf;
 	int *irq_fds = (void *)&irq->data;
 
+	memset(buf, 0, sizeof(buf));
+
 	irq->argsz = sizeof(buf);
 	irq->flags = VFIO_IRQ_SET_ACTION_TRIGGER;
 	irq->index = index;


