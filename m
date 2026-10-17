Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12D53A7D63;
	Sat, 17 Oct 2026 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260566; cv=none; b=K91QJ6SUwEtnCu8asf3JdCwKjkYU7X7ilaO5VFwSqvWrPt5MGv4EdfMBDbBl7LVAKHqGl8bTK6Yn/mmlhmbABr7iauWM/KfGyEjKTrJFGtCpa6DxhB/bjdgUIzgP759gjKaUeYPzruBi6d7TNFNKo7DhwpjoNPE7Dpng4hTXiHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260566; c=relaxed/simple;
	bh=4JYcjiLu/rtGSvjUMb0XTfuFrDV++N8lEsO/BdQ5JZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=je1IFAHO9F3kMpFE35pfHfCBH5lBnhE6ktRlfxmbtQa8Gv6fk+rIbyVhpRU7KAgKFFZfnlqusLmEfGSBuPpfOfzIVwUFH5XLNZCLoKW6g/xVNuK9b6YOI74a19bacfT2FDP3VU8pJPhdQEbt0tHj1Sl7YjjlKZ6Olhi3g7bXqPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSzTs4WU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSzTs4WU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291C81F000C4;
	Sat, 17 Oct 2026 18:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260565;
	bh=OPlRtyosYZpuVdhbEMTrFp8rP7sB6RNM3i7zTgXg3ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSzTs4WUuhf9xzCqBZNrzTkiiNUtW1LmeJMyEzKZuK9wHnnc93Ka00B24q0lPMXXZ
	 7WsL5oPhIZlOMS8tus24SFW7Pi+q2hfaIL759+Dr4MBIBXK6sIefmBgBOpTv5lp99b
	 e1pDIQgxuFSMrVBsMmOfKGHjWVCODMoeS6qdTzd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1546/1674] PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()
Date: Sat, 17 Oct 2026 18:03:38 +0200
Message-ID: <20261017160510.791563724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 25ec7f57deceec633f27bc93b615f951e2ade814 ]

Currently, the __resource_resize_store() allows writing to the
resourceN_resize sysfs attribute to change a BAR's size without checking
for capabilities, currently relying only on the file access check.

Resizing a BAR modifies PCI device configuration and can disrupt active
drivers.  After the upcoming conversion to static attributes, it will also
trigger resource file updates via sysfs_update_groups().

Add a CAP_SYS_ADMIN check to prevent unprivileged users from performing BAR
resize operations.

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260508043543.217179-6-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 087fe400e6372..2bfbc917fa8c2 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1432,6 +1432,9 @@ static ssize_t __resource_resize_store(struct device *dev, int n,
 	int ret;
 	u16 cmd;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (kstrtoul(buf, 0, &size) < 0)
 		return -EINVAL;
 
-- 
2.53.0



