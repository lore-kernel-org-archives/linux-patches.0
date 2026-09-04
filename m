Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24965419FBB;
	Fri,  4 Sep 2026 06:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502700; cv=none; b=lcsynZHyfHEpwh8fNNnrMpKMHPf0S3/1UIonzBUV+7YfdMEzxYLgVAJAnciZqprdKMCTPW8M7iwtBSoVbuMQkdW1z8U8m37UZ1gB6UHttG6Slb4nM5Z93vyAT0xIbxH/7CREIAWFsjUXYOoCLcL9/AHHgMpwmC5udhpBvIE0APc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502700; c=relaxed/simple;
	bh=W2g2jdh5yeiFQEe7ZV9R+mlgXu3r34MWoJ94Sp8an4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YeptxKc8ElmJRSce3yo1/1LbivWw5geGVVr3ST7SjnorCGckQCbMQE4iDnIfTYKnB7H+UDS/HutjJTsYAv7ISRRa1VPatCHRVNgVr2egS740EPmRQeaDqY8z3NFg8CK58jqDDQsIdMwP5abmh7U4DtT8e/CObkoNnsodcTSXwiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ur5SdTKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ur5SdTKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF511F00A3D;
	Fri,  4 Sep 2026 06:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502699;
	bh=bYhDGOFYzhpZPH4NYVZ/qE9YFdXSTlHh1eCIu/ADIcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ur5SdTKq3Ky8AW4ACr8SAL4kiAQHcOTUosqBFfMwtHMwKmAJQAOE6wCO1zbxokBet
	 nGHTA/I0f6NCTBq88fiCm4zf3J9qFgEk41U5lQjqZdMntj32aP9G6SfDAgymVXNpYu
	 ccb3eMaawymWTlR53EYnEfeCOBLht0/hYXZjvsOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.12 299/403] PCI/proc: Avoid spurious runtime PM wakeup on config space accesses
Date: Fri,  4 Sep 2026 07:01:42 +0200
Message-ID: <20260904045741.642555721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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


