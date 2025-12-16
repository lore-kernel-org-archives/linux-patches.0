Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A7A34EEFB;
	Tue, 16 Dec 2025 11:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885622; cv=none; b=VUo4FCYZfk0GZKP/35hcxBdMYi/5mRi64W+TZ2kc+Vnfak5n1kRtrLYqG4Erzq00/pbOVteH0P4GRYqTQNCmOrKTPW6g1CqETWY6ttfZKC3Yu07XDxSZwuR1JbZG2mmLFpz0nf/IUWYpnzIdkJBsJgl+prKumF/oIW8c+FqyHb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885622; c=relaxed/simple;
	bh=BIOfW6657/bLTsVSnjv5HS1iRtwJEegSEsEXH9jRFgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lp9/CnZSYHde/Q2sLhh8GgxF0eN78Pfe4ZT5Mdde2sThiBchphN1FtpTB9XQRnH0XkPyqSkTQKPX8IBYW44hcSMjpY0cL7fQhq59XiDvH7ZGC4javKyWuFdfT2QbrhllSq8J5D5ihUrBcHKOwreqC7/3twPIhLMmgkhwGRWH4cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSngTtNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSngTtNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FD3C4CEF5;
	Tue, 16 Dec 2025 11:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885622;
	bh=BIOfW6657/bLTsVSnjv5HS1iRtwJEegSEsEXH9jRFgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSngTtNSVaz/xeXCYlOrmQEP7HncqNfAxAjJqzuhWL9oJ6tKTWH8JPtMK9TYTG9E7
	 mTJKKZu9nsVzfgsVLLRTrzya0yEoYIljWIfYLUwSAA79DkdSC7yOExsc6JgEBQ1pAk
	 EBhUvkbtApr1TJwQeJYLkvN4L8WJxJ+ChFUGz3lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 194/507] scsi: stex: Fix reboot_notifier leak in probe error path
Date: Tue, 16 Dec 2025 12:10:35 +0100
Message-ID: <20251216111352.538924139@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 63ed7f9aaa937..34a557297feff 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1844,6 +1844,7 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 out_scsi_host_put:
 	scsi_host_put(host);
 out_disable:
+	unregister_reboot_notifier(&stex_notifier);
 	pci_disable_device(pdev);
 
 	return err;
-- 
2.51.0



