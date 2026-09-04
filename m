Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3CE351C35;
	Fri,  4 Sep 2026 05:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499775; cv=none; b=PqyspTM47TaJ7eDi3sIB44hAlID50KFrGJJ8z8b0Yr83wXhr/843GWJNhFDE4OPedRZZ9r2Ysn0XYVH62DKzsSnrcohmX0AH1yOXGDfmz5R2UJ/miDS68ZUnYXbY6UIK8PnrFLzWk/QHi6CZcTf/xTu9spIEvwCTGshS/jAR7tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499775; c=relaxed/simple;
	bh=pcxJ9SI0qzkcMNZlePMY3dGN9EcwYF3Gyzsa/0LOn7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJuF4cRcAiq9fv+8whVy+yFUA2rj3eEqIXD91u7r0nX5w4F9EQqgd7iXRlG1140yGZ3/ODNs4HDDdYF6xDVHpYI4h1HrLeaBZswnc5rCsy/6TdHQeP6uU8e8F/wZyEQqRlkhYjjyxPdQh6zG+aQmDUf6+ysPL9YbG2Sf3B+xBkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GuRS3Mpz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuRS3Mpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D081F00A3D;
	Fri,  4 Sep 2026 05:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499773;
	bh=1W2FDZibk3HSFE+7/Jer1gsc8fmR25/jq4zWiwzbPxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GuRS3MpzTpI932FjyjjwFJ9gN7QUqU7Wb8T3W8JvTJE5yh4q3pxna4ng4stbiBbve
	 +m8WckjF1KMlzdVQm3B63zdXoA77pgC9l0l9bXdS2NA4cCRCgHZ34qeVoZKzsGOFrf
	 ZXqOfza4QFe+3o1F2Tdzf88NUHwXGqcGIWE7UUv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 7.2 534/713] PCI/proc: Avoid spurious runtime PM wakeup on config space accesses
Date: Fri,  4 Sep 2026 06:58:22 +0200
Message-ID: <20260904045815.790717013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -46,6 +46,9 @@ static ssize_t proc_bus_pci_read(struct
 	else
 		size = 64;
 
+	if (!nbytes)
+		return 0;
+
 	if (pos >= size)
 		return 0;
 	if (nbytes >= size)
@@ -122,6 +125,9 @@ static ssize_t proc_bus_pci_write(struct
 	if (ret)
 		return ret;
 
+	if (!nbytes)
+		return 0;
+
 	if (pos >= size)
 		return 0;
 	if (nbytes >= size)


