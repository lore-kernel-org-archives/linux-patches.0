Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2DA1A76A4;
	Tue, 30 Jul 2024 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359821; cv=none; b=IS8i0aV5RWxIJZZy5QSIC6hcXUi+YCWl2u/tXUxxoDzVfCl3ifOd+Nmf2DTX1VK76Z9ugXIXV6IUSQK8yrHTlJBNMoe0dUUQxQ5NKMJ/oIhQl8a9jFgYydfkq0fvUshfadQ78NwouK2H+w+lEAl0kw/RM1ztPHJvMH45qaguB78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359821; c=relaxed/simple;
	bh=mzQ201SFz9Cexo9GiBxuJ0reMdf1SjmXxrWpktpZ2kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIuyrYFbgXhSNO0aCtZWOyxAsGOS1VMJg5646vk75Ot4LOLPkMh8frk0aXUdUBeJJ2jxIyNt++OJNZed3GUjxqt29UUnDZ5eOrvrTNojlYJ5Yh1uESw7tPKhaIgaFpcEXRyuf96tjEcpsb3zM/d6GRPBj6R/2VvNgscvRlIZaV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5ovDYHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5ovDYHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFF2C32782;
	Tue, 30 Jul 2024 17:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359821;
	bh=mzQ201SFz9Cexo9GiBxuJ0reMdf1SjmXxrWpktpZ2kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5ovDYHdJS6JQtcjOY0Hv37kOeGrtAtyyIEgr296y+3tWQZN0LT1e5h9nOzrxwCMz
	 iz1vVgMHDIq1NTcQyiRlCckHsb6c1Jtqz97vHELp+Y3F+CXXhRT33FaMQIyQDZm8mp
	 Ru9EQtkKMpsGnvVSWPwc2Fk2Q1TVEatQY0jMDYNA=
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
Subject: [PATCH 6.6 512/568] PCI: Introduce cleanup helpers for device reference counts and locks
Date: Tue, 30 Jul 2024 17:50:19 +0200
Message-ID: <20240730151700.035843246@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1146,6 +1146,7 @@ int pci_get_interrupt_pin(struct pci_dev
 u8 pci_common_swizzle(struct pci_dev *dev, u8 *pinp);
 struct pci_dev *pci_dev_get(struct pci_dev *dev);
 void pci_dev_put(struct pci_dev *dev);
+DEFINE_FREE(pci_dev_put, struct pci_dev *, if (_T) pci_dev_put(_T))
 void pci_remove_bus(struct pci_bus *b);
 void pci_stop_and_remove_bus_device(struct pci_dev *dev);
 void pci_stop_and_remove_bus_device_locked(struct pci_dev *dev);
@@ -1851,6 +1852,7 @@ void pci_cfg_access_unlock(struct pci_de
 void pci_dev_lock(struct pci_dev *dev);
 int pci_dev_trylock(struct pci_dev *dev);
 void pci_dev_unlock(struct pci_dev *dev);
+DEFINE_GUARD(pci_dev, struct pci_dev *, pci_dev_lock(_T), pci_dev_unlock(_T))
 
 /*
  * PCI domain support.  Sometimes called PCI segment (eg by ACPI),


