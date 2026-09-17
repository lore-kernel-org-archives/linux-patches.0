Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134143A1A56;
	Thu, 17 Sep 2026 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661201; cv=none; b=CozmUGcUd8SQWGzzGlDPt9Ohz7XZY8LAdgn7fbxXhPBp0weczsUFJI0stiDFLlVMdvDBirlgFpcvWrxeW5VyYH8Xd5kmtWdUYV6yi25XXcssgAl/gifsVqdUaeNnCsZqVdnIqSOceExTPBiU6emfgq6YVOgM1Gd8jSwz0v97SpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661201; c=relaxed/simple;
	bh=bWCUlvvvUtaaEbfCltktUx4BEZwpYTlRPf27KAjOpec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q88CGsiwbMaquEUUlIA9mggt8gjmcr+EcIlj+p8KZ3dXSsQ6gqsiRGh1/viLV/zqyjJLna9J1Ye3IY5XbRaKjtKbRrz3y2pIfUmBfjbAHElXLkKdga3HqKnPY44IbOaecyY4DyjXTzOJDtbDaYw7bNR99hSItqAx52gJKXLmAdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJCHSAfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJCHSAfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7E01F00898;
	Thu, 17 Sep 2026 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661200;
	bh=QuvMEHm2Lw5RvDIrkR4rzOAnrCrZhw2lXsOOp1bWol8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJCHSAfoYQHJgL08ds7R+kI/hAU/kZ6++Yuxeujw/eG0d8OshXwEHWiKe0I6pvrDR
	 fNdY+R1bG8uru/zkgsixXjHNGzGRmyuuuAv9hHagKGhBZcQ6rJ859iVHW/ujdERUa/
	 lqsQSG7duFe7UhEvBhiVVeqLXmLJpP9amV0eNpzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0079/1250] PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()
Date: Thu, 17 Sep 2026 15:57:54 +0100
Message-ID: <20260917151554.107772736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index f3b7f4e410a41..f456e9a2ddc9f 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1605,6 +1605,9 @@ static ssize_t __resource_resize_store(struct device *dev, int n,
 	int ret;
 	u16 cmd;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (kstrtoul(buf, 0, &size) < 0)
 		return -EINVAL;
 
-- 
2.53.0



