Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82596502D6C;
	Thu, 17 Sep 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667332; cv=none; b=drkiIqACEpyvrQ51asyEyk+SssL1Xuc+lWnlSrlAoQlcbOGFpO+bQo9X9dcfrXykYqBY7sAGNU912a+ccbJ3jycrzsnPCS9dlhs5PDfydM7JL0XOXYDxOJ0WgFspXt8DOJeQ4baFav0eRMzwu0f6b0polNlSRY+mBeDo5tNuoBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667332; c=relaxed/simple;
	bh=RWmgRm05WfVKJjVWF69+L6zNl+hvSEMbBTNexP82omc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uNnklqsqk4RffbnyN0xWNhM/OFbcmoFeHJM85O5EsjFxX8lvmpO2GSowFoglzxY6gWpzGRKGaJYl4FvDJYruwwB1lV+2WCg9pScsgdQsgqqlAZgqbIGOrRydd7AGmf0riO/3lhfdCJK1hrivzxk19sQDLCgQVdm2sgIrcJ3RgZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=borYYz2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="borYYz2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34871F000FF;
	Thu, 17 Sep 2026 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667331;
	bh=4m+Ttd3/S0eL7WApO/P7cTwigxrwuen5GFXUkcAGUb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=borYYz2GAUEMA0qrhBRvLtAKX2+8ifpMs7LSbTKPD4P9DQSxgPGJa8x31MeXHQUJA
	 NrXzroNrHX6pcpZw4pXfRjm6JMm9eVXPk6mqmWj+X1i70TiE1BsN7NSnY2j9LMuSDF
	 rLgpm6GkhSKUbQEBBxfC9f7AA/O7Qv6mi3rRoEXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0058/1102] PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()
Date: Thu, 17 Sep 2026 16:00:01 +0100
Message-ID: <20260917151540.910596777@linuxfoundation.org>
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
index bfbb605c40191..458c99388a305 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1431,6 +1431,9 @@ static ssize_t __resource_resize_store(struct device *dev, int n,
 	int ret;
 	u16 cmd;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (kstrtoul(buf, 0, &size) < 0)
 		return -EINVAL;
 
-- 
2.53.0



