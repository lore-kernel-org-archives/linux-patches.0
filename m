Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3474423A8A;
	Tue, 31 Mar 2026 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976274; cv=none; b=oODmSzYhzRz+XbndCnVubwqwYmxSyisNI5g7WHFV8CT5orUIYHWMTXmAkVa5aEBvVtRphVubh4JEHSb+fKTW6HoDKLnG0My5GOy0ApmEAj0ENkPcH6ebVirY2FQVt9qfeo3I3SdCxxH3rdyek8papI2mgyJ8JyMP8IpdizcajVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976274; c=relaxed/simple;
	bh=gbDpTDwV2qJE9o3rnTcSGJgwi90NCZONjismGjO7J6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ko0GvD15qYm6hv5ompEr/hcfM8IIV0cedMYbQtQ+TQvfGl8cS+36yM9x6eyRrYx0SRg19NVkT1rM0IfXOxftoVkbOG1y1Dtov+kOaedrR7NVEalnUCAuIK6rwJotVnqDwTRaSYUcz3YRfoYoi3laaFII+fXtvXc4QLXJB8prtQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xO5oqW+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xO5oqW+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39668C19423;
	Tue, 31 Mar 2026 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976274;
	bh=gbDpTDwV2qJE9o3rnTcSGJgwi90NCZONjismGjO7J6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xO5oqW+TZWc8Ny7JkBAe9aZULmYngRYMypMIu+CxVYlal1aqX6Lo+4DS0v6dR8XM2
	 AQLabspkA/D4cRcFbdICY5FhExxhy9d62lV5hBUHCmrK/vlEWDYVIFtZgkzzORqzFv
	 GmtzD2YxAd/WE4meFqxcBgZK/JGA62XqFiQROF/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daniel Hodges <hodgesd@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/309] nvme-fabrics: use kfree_sensitive() for DHCHAP secrets
Date: Tue, 31 Mar 2026 18:18:45 +0200
Message-ID: <20260331161754.296644982@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hodges <hodgesd@meta.com>

[ Upstream commit 0a1fc2f301529ac75aec0ce80d5ab9d9e4dc4b16 ]

The DHCHAP secrets (dhchap_secret and dhchap_ctrl_secret) contain
authentication key material for NVMe-oF. Use kfree_sensitive() instead
of kfree() in nvmf_free_options() to ensure secrets are zeroed before
the memory is freed, preventing recovery from freed pages.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Hodges <hodgesd@meta.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 55a8afd2efd50..d37cb140d8323 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1290,8 +1290,8 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 	kfree(opts->subsysnqn);
 	kfree(opts->host_traddr);
 	kfree(opts->host_iface);
-	kfree(opts->dhchap_secret);
-	kfree(opts->dhchap_ctrl_secret);
+	kfree_sensitive(opts->dhchap_secret);
+	kfree_sensitive(opts->dhchap_ctrl_secret);
 	kfree(opts);
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
-- 
2.51.0



