Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D5E374758;
	Sat, 12 Sep 2026 19:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241489; cv=none; b=oarVIcEOD2LGDCjtM78lRfb6AbRAu2eSFfkUKZeOqwRzgogV8M9Usn7h4L0Uqo5cHNQs0i6JM36ikv1uQCjOw9cLwBY+HR5Cwgiiqku9+v0rr7xMFn1ceNHif3qi6U68Csfjvb3Sn+twUygErqhOYL0Fm0fa8YrT2Cltb+OwP1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241489; c=relaxed/simple;
	bh=yjxSoK9ydQi8BtSQjAnrtCR4f15t/8EUSpBzwfTdqGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=raqfjhNPrum7/BA4O2cGyDFhTFxdB2awT1opbgCkcL0JrMtNdA1p+xGTt98UhzJX3btXM24A2vObbI3tTuShp+HBa5nJVGp3ypLk6toZk6rzI7RjNcAXqFrD7fYJSvVeGhd9dmIMup2+HxPtF1o4mMH4aiAl5b2WjgRhOFm+o9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gatz6T9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gatz6T9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFE51F000FF;
	Sat, 12 Sep 2026 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241488;
	bh=/ZD3j5f9EU3/OECHXYzhdNY/vrovJ4/dlPFN6HG/Bzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gatz6T9wl3YGvpfc7td/VocH2lUxcKz6h/kN1L0jCtC7tB4pup7qfqlXtw7l0UM6l
	 qpvj9gdoTI8bssaHetU2V2IHnkDeelMOYGZAO7kErR9jTZHYQuLGK9Fkxy0ndjAHfk
	 vilFhCIRtHl2oe4rP5CosjuugB0Phxz9EPBa3xeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 144/798] PCI/sysfs: Avoid spurious runtime PM wakeup on config space accesses
Date: Sat, 12 Sep 2026 08:56:12 +0200
Message-ID: <20260912065520.288587237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -722,7 +722,7 @@ static ssize_t pci_read_config(struct fi
 	else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
 		size = 128;
 
-	if (off > size)
+	if (off >= size)
 		return 0;
 	if (off + count > size) {
 		size -= off;
@@ -798,7 +798,7 @@ static ssize_t pci_write_config(struct f
 	if (ret)
 		return ret;
 
-	if (off > dev->cfg_size)
+	if (off >= dev->cfg_size)
 		return 0;
 	if (off + count > dev->cfg_size) {
 		size = dev->cfg_size - off;


