Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774A0411A1C;
	Fri,  4 Sep 2026 05:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501533; cv=none; b=g/3bJzqz1umZRam0+d1ZiKdPiJzyVW3APf2gwa38tIOKNqUChxuHwaAuCE8yXJq37/uKe50kkC1Go2B+drfPrRAXbKq8iVv0wkOnMvsj1HngJ/HwSTN0nmJ6cR4YXLvBpaakH4hVtLSCyG8LiB5WMB8L33C5ZzLrm9w3iXd8hSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501533; c=relaxed/simple;
	bh=jX0dR63gxRDiAj+BOE4EBRvcXZUBwncRFrv/KyJ2OT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pOyaGhhYovyocoWvIn7ZE8EU4KrIhY4wptLLL2lURTCoNHqiCj7W9HyJY65C7/FNPLae8HBOb7HBOsvUV6McRGGm8LFe1q2yd7EquUA00fOeCtWCW3fn4mcsiAE2VHuXVLnEwISEOcKHW+l52IiH87SoW3hK68AOIjS8VEICeKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvywDsU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvywDsU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CE41F00A3D;
	Fri,  4 Sep 2026 05:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501532;
	bh=YEXWRwhVctmMUGFOYrdrpk7/+ZANfCAWWVjmsL9kM7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvywDsU/Y8T1YBLGC8HMGU1s6FtJ23WkHBkrK4Vt0NanloI1m6sabUbsMI4DXCpff
	 wiAlhzq3PiV5Htyc4yVrEZ6plCMQK14d14eWaRxnVlzKJd8HYt4ja8eTWW7ziE6CB6
	 66yvnGTQenUfNm9ZN4km9tpe2crHXWl6Iyie/9xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.18 399/552] PCI/proc: Avoid spurious runtime PM wakeup on config space accesses
Date: Fri,  4 Sep 2026 06:59:16 +0200
Message-ID: <20260904045759.446779890@linuxfoundation.org>
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

commit 4ff664a81d729b37f2eb65de80a670abfb61c9a0 upstream.

Currently, proc_bus_pci_read() and proc_bus_pci_write() do not return early
for zero-length configuration space accesses at valid offsets.

Such an access invokes pci_config_pm_runtime_get() and
pci_config_pm_runtime_put() around transfer blocks that do nothing.

This is a problem because pci_config_pm_runtime_get() synchronously resumes
the upstream bridge through pm_runtime_get_sync(), and resumes the device
itself through pm_runtime_resume() when it is in D3cold, only for the
handler to return zero immediately afterwards.  Such a spurious wakeup
wastes power and adds needless resume latency.

The sysfs core already returns early for in-range zero-length binary
attribute accesses before pci_read_config() or pci_write_config() is
invoked.  In contrast, the VFS forwards zero-length requests to the procfs
callbacks, where they continue into runtime PM handling.

Return early from proc_bus_pci_read() and proc_bus_pci_write() when nbytes
is zero, before any runtime PM involvement.

The value returned to userspace at these offsets remains zero,
so the change is not visible to userspace.

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: order tags]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260729075909.1219906-1-kwilczynski@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/proc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -45,6 +45,9 @@ static ssize_t proc_bus_pci_read(struct
 	else
 		size = 64;
 
+	if (!nbytes)
+		return 0;
+
 	if (pos >= size)
 		return 0;
 	if (nbytes >= size)
@@ -121,6 +124,9 @@ static ssize_t proc_bus_pci_write(struct
 	if (ret)
 		return ret;
 
+	if (!nbytes)
+		return 0;
+
 	if (pos >= size)
 		return 0;
 	if (nbytes >= size)


