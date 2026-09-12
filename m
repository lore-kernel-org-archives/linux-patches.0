Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871F3340298;
	Sat, 12 Sep 2026 18:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236981; cv=none; b=kzX+JyLGCk8exwe+uSToLLR1BRhVYVgV0WYwbeXybA5Zko1mzRmsgaftayScL8W54Wl9Mu1VnRVkZBy6H1Hub5iZuxSb5zLJwks+5t5MdIFWGHq5u9F6E4JmZDU3tx4MKak/2dbJfEXLayStpu/WN5VC2cXeQ7/g3JdOkd+zRdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236981; c=relaxed/simple;
	bh=TbYih27lI2A7FvnB6GyqBbsNDjJ1LANgKY1o7bXOcGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKDaq+srA9AEKnW9h+qCYEfedgBjK3i876sb/EldeGgvvSMyC7Y5TYnUDkOc722XUdeudDpoOwz8umD4ObO0ZcphNkr4z+AALUHLoDj1NVBAT+ehKMI9jCQ/DLOnBZxrrUgXCLrL5LC7J++M2FKetuwDOlzhdUk+cChLEO9rHcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCWmL4Fm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCWmL4Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB9D1F000FF;
	Sat, 12 Sep 2026 18:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236980;
	bh=rukjS7EiBTsUX0R13pCv0HBjl4jQGExzZFDIs5yV1Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yCWmL4FmcocACqLw0Eg1GQmKyhajPuFwhijkzUQ0CIbbKcRtT6e6G86K1uZ4ZvgRK
	 NWlEbt64ZonZm7jUZ4K1r54uZu1uvzTab6BsYZc+2RUEzOgRFF/YryJtKZ9fHO1m6e
	 5dhXiAdUGWvKMk+242NYRtMZo7zgMaBZa6OB05V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.15 164/935] PCI/proc: Avoid spurious runtime PM wakeup on config space accesses
Date: Sat, 12 Sep 2026 08:53:14 +0200
Message-ID: <20260912065530.580801187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -123,6 +126,9 @@ static ssize_t proc_bus_pci_write(struct
 	if (ret)
 		return ret;
 
+	if (!nbytes)
+		return 0;
+
 	if (pos >= size)
 		return 0;
 	if (nbytes >= size)


