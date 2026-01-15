Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCD686334;
	Thu, 15 Jan 2026 17:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497447; cv=none; b=H1UwDSLWulLOHJVtye9gyEL9WvGLvGY3KWqR29h8DUdlrXpfEJA7kYzLtE30CeMNLIv/CG7TH+7iDjIEafE6M8vJX2AEv6rZKmHTnasBCiYvszr4zhoBAL5ESfPkHL8cowr9m4WhQxHpBA91Sb18N00iy6niRZPFe16IsZ1ndXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497447; c=relaxed/simple;
	bh=OUP6uzgbcSLbmO0ro2K1/aYJIDmtVlvLXK7Es1x+dGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9pn9fk6xbGFsWr98oG2r5EmR77TLNQoXNDkWestNmWBh9dk1XW8YYhKRi/xIKHmcH8YrnaeVXIbmtVSGaQo9KvGrvXi7VcoPHHu8tDVAIHpAfiUIP0vzx7+CIzC/7oaaVk3DptlIuxc1+hzBYAAWEEax2LZQVCtOBzbcdhCdkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqyYitCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqyYitCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6D9C116D0;
	Thu, 15 Jan 2026 17:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497447;
	bh=OUP6uzgbcSLbmO0ro2K1/aYJIDmtVlvLXK7Es1x+dGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqyYitCbpgWp1iNnBbC3/XU1BI0XrMdZ+sOB+apYbhAGKXKKUy0VYR8t6T3FanGVm
	 SUIq27MwHwPHXaItu0st96bv+e0UX8ZWkjvn60EbJaw7YgyQgh+vClJOvfIg7rjyLb
	 iwIHLnKlU+gHWZM4qWshFdzOpoTttVQubR5kIHm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/554] scsi: stex: Fix reboot_notifier leak in probe error path
Date: Thu, 15 Jan 2026 17:42:30 +0100
Message-ID: <20260115164249.286774298@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1ff9b8e85b09c..8ff92ab9b27b1 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1848,6 +1848,7 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 out_scsi_host_put:
 	scsi_host_put(host);
 out_disable:
+	unregister_reboot_notifier(&stex_notifier);
 	pci_disable_device(pdev);
 
 	return err;
-- 
2.51.0



