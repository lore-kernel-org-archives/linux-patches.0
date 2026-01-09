Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF83C350A37;
	Fri,  9 Jan 2026 11:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959661; cv=none; b=u1pKFNN2f6c/LxdD2t/nC3XxMvIhyvynbBa5ZHyvBNGGnd85aAAiBR5fqcLiGrMBe0RzeOuLl8dczQIcq4d0wLsDLXqIyGSYzQwPyn6z4/JawqXLZXNNmY+iXo1sI/9J/d1wFWpttALEmSqMW+nGGo82AK34+H4lC7c3AdHcFBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959661; c=relaxed/simple;
	bh=TZOWpMOVt8Ek5P7DhvLX6FYRJ4Qcaq25UfYr5Wqf0Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ft4AWUr9UQQDAhRWXEWU0GMa+Fk27YPF29GNyqSZ22rALBaDxjURhxYBwWWuuuVwvN/i0cluj1eJlVlFCtAulPKG9VWZqERfs3VQp2KDLohqIjzgvycQY8m94o196Nd5jluQgAewjiuQ4J8O4mwRNY+raQjTFaLFFbWGwDA3HyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKYeWnAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKYeWnAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040BEC19421;
	Fri,  9 Jan 2026 11:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959661;
	bh=TZOWpMOVt8Ek5P7DhvLX6FYRJ4Qcaq25UfYr5Wqf0Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKYeWnAnfYKFn73JoMq21R2te8eVbofVKQ2bIyHcpHBLAN8KI3aDI2H19QcNtUUKA
	 28Dprf616kepv1hlTW375Ur6sbsv1G0wFDIafjaPxmy0VjQRqdrntGQ7c16Tu2RvY1
	 kDntYN2n11zbzOOHOTNkaoj+s0pCeZg6XylDLVdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/737] scsi: stex: Fix reboot_notifier leak in probe error path
Date: Fri,  9 Jan 2026 12:34:29 +0100
Message-ID: <20260109112138.892535280@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 20da637eb545b04753e20c675cfe97b04c7b600b ]

In stex_probe(), register_reboot_notifier() is called at the beginning,
but if any subsequent initialization step fails, the function returns
without unregistering the notifier, resulting in a resource leak.

Add unregister_reboot_notifier() in the out_disable error path to ensure
proper cleanup on all failure paths.

Fixes: 61b745fa63db ("scsi: stex: Add S6 support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251104094847.270-1-vulab@iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/stex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 8ffb75be99bc8..879b090fb39ea 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1846,6 +1846,7 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 out_scsi_host_put:
 	scsi_host_put(host);
 out_disable:
+	unregister_reboot_notifier(&stex_notifier);
 	pci_disable_device(pdev);
 
 	return err;
-- 
2.51.0



