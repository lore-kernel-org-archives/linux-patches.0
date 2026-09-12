Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097E63F9F50;
	Sat, 12 Sep 2026 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227484; cv=none; b=sWKs+9AlbFG07Nmn3AZde+wvTNowBC4xVtALgoMJ6lw6XGS6+E+whaKqiAGk1Gj7an12PKK+vNM1u0wpO/nxnNheuHQfBvKBGc3R9RbhsKdN1PBNEi9v8wZ/Wq3bBsEAK8aF8m7A1lPNqzhmEFa90oTbvAAsy2kWnbTZCP6Eig4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227484; c=relaxed/simple;
	bh=dRhb0aL1oUZ+BTpM7bbo2qNu7gsxJPTbadG1vJRth4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MBlDczEpFe3D+HX+UAQoEEyj9Zmm9blVpFa1FFvYlnpl9uzWSZO7tetJxMtLyIvKCZP+BAqdBsV2+s57/Q7qzCm4k6YPKpxJv2monna1q8P2SVMJrg67djiNZYaq4rpxIKn429FM2suTXVk3X8/Op9uB7Y98+41vFAYAT9hN/Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUyYAB9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUyYAB9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03421F000FF;
	Sat, 12 Sep 2026 15:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227482;
	bh=LGOVODIIhuHeFQM8S/P3fyffiB0NNHIiU+asS3pHM88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUyYAB9Am2NCgp9qM0rZ7yJoKZ/ivvRDhNZen30GAw7at0tkPKxnpQRqiDDfsUEmR
	 CN3vHNZTvHG0RaledA5wGgt29f9PmecaJQXRG+JvZOk76D47w9nujDK9F42q6aF4o1
	 0tHpBiyJzMoB4RqATES6MUMdd+4HEMpQc8GXrsWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.1 0188/1191] PCI/sysfs: Avoid spurious runtime PM wakeup on config space accesses
Date: Sat, 12 Sep 2026 08:48:36 +0200
Message-ID: <20260912065552.436609470@linuxfoundation.org>
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

commit b14b2bab88d7099ab4447560cbe4b40945e5c069 upstream.

Currently, the boundary checks in pci_read_config() and pci_write_config()
reject only offsets beyond the effective configuration space size.

An access at an offset exactly equal to that size passes the check, has its
length clamped to zero, and then invokes pci_config_pm_runtime_get() and
pci_config_pm_runtime_put() around transfer blocks that do nothing.

This is a problem because pci_config_pm_runtime_get() synchronously resumes
the upstream bridge through pm_runtime_get_sync() and resumes the device
itself through pm_runtime_resume() when it is in D3cold, only for the
handler to return zero immediately afterwards.  Such a spurious wakeup
wastes power and adds needless resume latency.

The sysfs core already clamps accesses against the attribute size set
through the bin_size() callback, which reports either 256 or 4096 bytes.
As such, the affected accesses are reads at offset 64 (or 128 for CardBus
devices) through files opened without CAP_SYS_ADMIN, and reads and writes
at the exact configuration space size on devices where a quirk sets a
non-standard size.

Reject accesses at the boundary offset as well, so they return early before
any runtime PM involvement, matching the procfs implementations in
proc_bus_pci_read() and proc_bus_pci_write().

The value returned to userspace at these offsets remains zero, so the
change is not visible to userspace.

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: tweak commit log, order tags]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260720204356.1501749-1-kwilczynski@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -728,7 +728,7 @@ static ssize_t pci_read_config(struct fi
 	else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
 		size = 128;
 
-	if (off > size)
+	if (off >= size)
 		return 0;
 	if (off + count > size) {
 		size -= off;
@@ -809,7 +809,7 @@ static ssize_t pci_write_config(struct f
 		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
 	}
 
-	if (off > dev->cfg_size)
+	if (off >= dev->cfg_size)
 		return 0;
 	if (off + count > dev->cfg_size) {
 		size = dev->cfg_size - off;


