Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1A518801A;
	Tue, 30 Jul 2024 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358400; cv=none; b=l98c3R4Zwy8lFouOUetwZMfUu8GcdfsQHJ0eIl6u49PLBr335q3mKWT3rDG/pF/1jio+hweQQEnP/8GE9gYvn99DCzdUG8ZFw357qknulnkuoSBxXN2OwDd9Crx4cNXXJMHwWKpszy3XqRlzHyjJ1vkgtqkGPR1f4vTI21FbBW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358400; c=relaxed/simple;
	bh=E0w7jrUOgtiH77thYz280NFyfgAF85RK8cmPux/aMeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqid4/Voi2NHgn0zRoCnFtcYv4YPeUUWsBbQyFG1sS6HD4+gTgUybVZ/5NOscAk6YY2QM1BEy/jJOeYTcxn1Lj24dYuOJ5F4tB0A46HAZjhanRIxa+LSIZkdJzKuVsBhBMkQIpINj/sjyJvTY0JTrPbUipAkJZ1Qd/KbWlTydvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4RMTyzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4RMTyzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9575C32782;
	Tue, 30 Jul 2024 16:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358400;
	bh=E0w7jrUOgtiH77thYz280NFyfgAF85RK8cmPux/aMeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4RMTyzrPmdYS6Wp9/8BU6T6jb6PKqzgeWe4G/5Uwyf26k4RIcXvhfw/7tmVLlZ6g
	 Z3fDXydojcJ+YXOy0jpUBJXSFifYAxmuYTslRzClGBmJ+7oheHbWLRJZSG4p6+L9LC
	 edtuADtAp4vHIsuRQ/Ud7xp9HinJ11NKkgkOzfhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.1 387/440] PCI: Introduce cleanup helpers for device reference counts and locks
Date: Tue, 30 Jul 2024 17:50:20 +0200
Message-ID: <20240730151630.920826862@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ira Weiny <ira.weiny@intel.com>

commit ced085ef369af7a2b6da962ec2fbd01339f60693 upstream.

The "goto error" pattern is notorious for introducing subtle resource
leaks. Use the new cleanup.h helpers for PCI device reference counts and
locks.

Similar to the new put_device() and device_lock() cleanup helpers,
__free(put_device) and guard(device), define the same for PCI devices,
__free(pci_dev_put) and guard(pci_dev).  These helpers eliminate the
need for "goto free;" and "goto unlock;" patterns. For example, A
'struct pci_dev *' instance declared as:

    struct pci_dev *pdev __free(pci_dev_put) = NULL;

...will automatically call pci_dev_put() if @pdev is non-NULL when @pdev
goes out of scope (automatic variable scope). If a function wants to
invoke pci_dev_put() on error, but return @pdev on success, it can do:

    return no_free_ptr(pdev);

...or:

    return_ptr(pdev);

For potential cleanup opportunity there are 587 open-coded calls to
pci_dev_put() in the kernel with 65 instances within 10 lines of a goto
statement with the CXL driver threatening to add another one.

The guard() helper holds the associated lock for the remainder of the
current scope in which it was invoked. So, for example:

    func(...)
    {
        if (...) {
            ...
            guard(pci_dev); /* pci_dev_lock() invoked here */
            ...
        } /* <- implied pci_dev_unlock() triggered here */
    }

There are 15 invocations of pci_dev_unlock() in the kernel with 5
instances within 10 lines of a goto statement. Again, the CXL driver is
threatening to add another.

Introduce these helpers to preclude the addition of new more error prone
goto put; / goto unlock; sequences. For now, these helpers are used in
drivers/cxl/pci.c to allow ACPI error reports to be fed back into the
CXL driver associated with the PCI device identified in the report.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Link: https://lore.kernel.org/r/20231220-cxl-cper-v5-8-1bb8a4ca2c7a@intel.com
[djbw: rewrite changelog]
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pci.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1138,6 +1138,7 @@ int pci_get_interrupt_pin(struct pci_dev
 u8 pci_common_swizzle(struct pci_dev *dev, u8 *pinp);
 struct pci_dev *pci_dev_get(struct pci_dev *dev);
 void pci_dev_put(struct pci_dev *dev);
+DEFINE_FREE(pci_dev_put, struct pci_dev *, if (_T) pci_dev_put(_T))
 void pci_remove_bus(struct pci_bus *b);
 void pci_stop_and_remove_bus_device(struct pci_dev *dev);
 void pci_stop_and_remove_bus_device_locked(struct pci_dev *dev);
@@ -1746,6 +1747,7 @@ void pci_cfg_access_unlock(struct pci_de
 void pci_dev_lock(struct pci_dev *dev);
 int pci_dev_trylock(struct pci_dev *dev);
 void pci_dev_unlock(struct pci_dev *dev);
+DEFINE_GUARD(pci_dev, struct pci_dev *, pci_dev_lock(_T), pci_dev_unlock(_T))
 
 /*
  * PCI domain support.  Sometimes called PCI segment (eg by ACPI),


