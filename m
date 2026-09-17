Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04F93D890F;
	Thu, 17 Sep 2026 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668245; cv=none; b=Opvujh30APWxd9/jLLKoLaEaaq2XruYXmWM/Cx6dWBDTZm0Ru0vvoJ/BOJBqoEFVL6Xvet4LNcPX8fOPeDxRecuztTDXa5Yq1MgIjWfpLlV3erz1EudmXi0hx7cFyX6XWunoackVg+sWXmhiwgxJa4qj+oLTZkdClKW7+WrC7xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668245; c=relaxed/simple;
	bh=zjuQpJBGEKjbsCKQZ3ekV8Tj7WiIFjW3hWbSiC8pYZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tizRXXNkbPqSPF5Fwedr6lI/mlbP9aZcGIi2dZsF/g+ODoUguWOZcPat6X/M3DU4+nZnY3Tdr0/WiI8TFaZAx+Z3U3K7fbso/3PilBFzp5ugO8ntL8eVjAcZ3foB+Uv7xxAB2n8jm64iUeYpl+lmcBALUCwDKCZcTkzdylRNvFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjQWhHOM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjQWhHOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541001F000FF;
	Thu, 17 Sep 2026 18:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668243;
	bh=v1ztopZ0I3l1OyDGcSUqLf4auX+KU5FD1EJ/SiesT3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjQWhHOM8mzFW5Au73chpL2um/d1yae/uA6b5mVu4B9cskd5/qZwEgVKhld+usaJP
	 0g4/zeiLruD/eY3Fo9IlRKh8cK5Koq78lg4YKAxdh1TczVkDOHZwV8ZNBcnzvXAPq1
	 q66XGDwmHcN3lnl3PVEjma7XtjqeV6Xu2ONAsR2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuan He <heshuan@bytedance.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0360/1102] PCI/proc: Fix race between pci_proc_init() and pci_bus_add_device()
Date: Thu, 17 Sep 2026 16:05:03 +0100
Message-ID: <20260917151548.685341411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit 8857f6578b001bcf5f53c8c6a3936647f05291a8 ]

pci_proc_attach_device() creates procfs entries for PCI devices and is
called from pci_bus_add_device().  It lazily creates the per-bus procfs
directory (bus->procdir) via proc_mkdir() on first use, and returns early
if proc_initialized is not yet set.

On x86 with ACPI, PCI enumeration occurs at subsys_initcall, before
pci_proc_init() sets proc_initialized at device_initcall.  The
for_each_pci_dev() loop in pci_proc_init() then creates procfs entries for
these already-enumerated devices, but runs without holding
pci_rescan_remove_lock.

On ARM64 with devicetree, PCI host bridges probe at device_initcall.  With
async probing enabled, pci_bus_add_device() can run concurrently with
pci_proc_init(), and both may call pci_proc_attach_device() for the same
device or for different devices on the same bus.  As pci_host_probe() holds
pci_rescan_remove_lock while pci_proc_init() does not, there is no
serialisation between the two paths.

When two threads concurrently call pci_proc_attach_device() for devices on
the same bus, both observe bus->procdir as NULL and both call proc_mkdir().
The proc filesystem serialises directory creation internally, so only one
caller succeeds.  The other results in a warning like:

  proc_dir_entry '000c:00/00.0' already registered

The caller receives NULL (duplicate entry) and unconditionally stores it to
bus->procdir, corrupting the valid pointer set by the first caller.

Serialise access to proc_initialized, proc_bus_pci_dir, bus->procdir and
dev->procent with a new mutex local to drivers/pci/proc.c, and store the
created entries to bus->procdir and dev->procent only on success, so a
failed creation can never overwrite a valid pointer.

Additionally, wrap the for_each_pci_dev() loop in pci_proc_init() with
pci_lock_rescan_remove() to serialise against concurrent PCI bus
operations, add an early return in pci_proc_attach_device() when
dev->procent is already set to make the function idempotent, and clear
bus->procdir in pci_proc_detach_bus() to prevent use of a dangling pointer
after proc_remove().

Reported-by: Shuan He <heshuan@bytedance.com>
Closes: https://lore.kernel.org/linux-pci/20250702155112.40124-2-heshuan@bytedance.com/
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20260611150543.511422-1-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/proc.c | 79 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index ac3c105fcf8fc..2967e4d2918dc 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -20,6 +20,7 @@
 #include "pci.h"
 
 static int proc_initialized;	/* = 0 */
+static DEFINE_MUTEX(pci_proc_lock);
 
 static loff_t proc_bus_pci_lseek(struct file *file, loff_t off, int whence)
 {
@@ -426,40 +427,64 @@ static const struct seq_operations proc_bus_pci_devices_op = {
 
 static struct proc_dir_entry *proc_bus_pci_dir;
 
-int pci_proc_attach_device(struct pci_dev *dev)
+static int __pci_proc_attach_bus(struct pci_bus *bus)
 {
-	struct pci_bus *bus = dev->bus;
-	struct proc_dir_entry *e;
+	struct proc_dir_entry *dir;
 	char name[16];
 
+	lockdep_assert_held(&pci_proc_lock);
+
 	if (!proc_initialized)
 		return -EACCES;
 
-	if (!bus->procdir) {
-		if (pci_proc_domain(bus)) {
-			sprintf(name, "%04x:%02x", pci_domain_nr(bus),
-					bus->number);
-		} else {
-			sprintf(name, "%02x", bus->number);
-		}
-		bus->procdir = proc_mkdir(name, proc_bus_pci_dir);
-		if (!bus->procdir)
-			return -ENOMEM;
-	}
+	if (bus->procdir)
+		return 0;
+
+	if (pci_proc_domain(bus))
+		sprintf(name, "%04x:%02x", pci_domain_nr(bus), bus->number);
+	else
+		sprintf(name, "%02x", bus->number);
+
+	dir = proc_mkdir(name, proc_bus_pci_dir);
+	if (!dir)
+		return -ENOMEM;
+
+	bus->procdir = dir;
+
+	return 0;
+}
+
+int pci_proc_attach_device(struct pci_dev *dev)
+{
+	struct pci_bus *bus = dev->bus;
+	struct proc_dir_entry *entry;
+	char name[16];
+	int ret;
+
+	guard(mutex)(&pci_proc_lock);
+
+	if (dev->procent)
+		return 0;
+
+	ret = __pci_proc_attach_bus(bus);
+	if (ret)
+		return ret;
 
 	sprintf(name, "%02x.%x", PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
-	e = proc_create_data(name, S_IFREG | S_IRUGO | S_IWUSR, bus->procdir,
-			     &proc_bus_pci_ops, dev);
-	if (!e)
+	entry = proc_create_data(name, S_IFREG | S_IRUGO | S_IWUSR,
+				 bus->procdir, &proc_bus_pci_ops, dev);
+	if (!entry)
 		return -ENOMEM;
-	proc_set_size(e, dev->cfg_size);
-	dev->procent = e;
+
+	proc_set_size(entry, dev->cfg_size);
+	dev->procent = entry;
 
 	return 0;
 }
 
 int pci_proc_detach_device(struct pci_dev *dev)
 {
+	guard(mutex)(&pci_proc_lock);
 	proc_remove(dev->procent);
 	dev->procent = NULL;
 	return 0;
@@ -467,19 +492,27 @@ int pci_proc_detach_device(struct pci_dev *dev)
 
 int pci_proc_detach_bus(struct pci_bus *bus)
 {
+	guard(mutex)(&pci_proc_lock);
 	proc_remove(bus->procdir);
+	bus->procdir = NULL;
 	return 0;
 }
 
 static int __init pci_proc_init(void)
 {
 	struct pci_dev *dev = NULL;
-	proc_bus_pci_dir = proc_mkdir("bus/pci", NULL);
-	proc_create_seq("devices", 0, proc_bus_pci_dir,
-		    &proc_bus_pci_devices_op);
-	proc_initialized = 1;
+
+	scoped_guard(mutex, &pci_proc_lock) {
+		proc_bus_pci_dir = proc_mkdir("bus/pci", NULL);
+		proc_create_seq("devices", 0, proc_bus_pci_dir,
+				&proc_bus_pci_devices_op);
+		proc_initialized = 1;
+	}
+
+	pci_lock_rescan_remove();
 	for_each_pci_dev(dev)
 		pci_proc_attach_device(dev);
+	pci_unlock_rescan_remove();
 
 	return 0;
 }
-- 
2.53.0



