Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C87311C07;
	Fri,  7 Aug 2026 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113961; cv=none; b=EMTqe5qyj0Hc5m7EHXYbDJ/DUCME85vuWSsHUY3sOwGp199mq0YcBFO2Vj3U6Z7qB6jePPOH96a1onzs2m3rKNDY3QoZkaKZffqRnB9YMmZXF9mdFHTFSPpqhO4cFbFGvpJwOl5HCfPmpg98QIKNdRxstbgcDtKs7ATvc7DAn0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113961; c=relaxed/simple;
	bh=OHwhds5HfyUikZ5I/4lDKUpOjYjd5/uj8xuNWCF4+k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmRkgNXZtAMPz76CjqOLpBIXQ/YHHgXk5fgut7m8FJxDvHgz7mEF5p3v0AkR7QAf8CS0HlOu3FLEC/J4gGs7IwU44V03KtxwsvxDNGTvEbWcsqoktQKAiNGMRjS8811JELkdqIbNZsoaUJe5Gn4axBK7s7H8ndjD3GNdbNfvrlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hl43dTNd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hl43dTNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B25C1F000E9;
	Fri,  7 Aug 2026 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113960;
	bh=05RxvnkWrZpIlGzT/hzL1T/JBcJyI9lM2uv4Rt4/CU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hl43dTNdlL6EE/2y69YdyBqn2VlLujafl50C4rt5zDdgcq4ES0vJzcEswUpAsnNVr
	 7E377hEyah3A9vHILbU5iWEG9LkHX6eay6k+madC9MfYJBwTzq/dmIwMzotkTXsHh8
	 Go/sz6ZW3jWTx9v4bQSS6tV+5TwxZC5CwjbI32/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/337] idpf: Fix mailbox IRQ name leak on request failure
Date: Fri,  7 Aug 2026 16:34:58 +0200
Message-ID: <20260807143420.601179361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 9bff30482c10f70d9e56c0633a6616e07140e217 ]

idpf_mb_intr_req_irq() allocates the mailbox IRQ name before calling
request_irq(). On success, the name is released later through
kfree(free_irq()), but request_irq() failure returns without freeing it.

Free the allocated name on the request_irq() failure path.

Fixes: 4930fbf419a7 ("idpf: add core init and interrupt request")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 4973135c346a2..c2101f7f6e1bf 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -134,7 +134,7 @@ static int idpf_mb_intr_req_irq(struct idpf_adapter *adapter)
 	if (err) {
 		dev_err(&adapter->pdev->dev,
 			"IRQ request for mailbox failed, error: %d\n", err);
-
+		kfree(name);
 		return err;
 	}
 
-- 
2.53.0



