Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1791186334;
	Thu, 15 Jan 2026 17:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497359; cv=none; b=Q/ruwj2fuUTTdZMbW1K6WM6imL5UJaFvXOFn93uN5RSjatzHupOeD6kdiubZWXgpmA9SD9qQLvqa0MC3K0okuXP/El/gkKXgMAg6RTIyl9JV0OQHA2MxxAlCN3HG7BnBrB4I9docgUwrRlwzUMMXJPFxHzsaZzZcyVnGKk6SAVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497359; c=relaxed/simple;
	bh=JcsexM4vEqjDbLI7UoHVZkOfE/SzB6ZyZNEReP0M2bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5hxsXcVnEYU1hSz4SsEUb9Q1Br6nQ7VwrdjZ6ApoHhmEcIBcChFVovGabpkXh4RlzdU5J7fqTlkc1SpxrNMbypXAACJk+prcAo845j2FU+PGVewceCZQ+0PoHetmcLQTUy3FgWzWFr2lCEB4Z3WJlQxI1loHIg+bhCml+JqiFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UnJI8H5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UnJI8H5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8D7C116D0;
	Thu, 15 Jan 2026 17:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497359;
	bh=JcsexM4vEqjDbLI7UoHVZkOfE/SzB6ZyZNEReP0M2bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UnJI8H5/TQyTx2nw+ubr0oGfNNuMXvBUNxFFMpXszc07IHB5zvRDAw5LKomjccwd
	 UeEB/C25R3U5YtQWYuYbYb0NjAKJeHaL94fNb3rvAD4+5QBxGOyrUUe705+NQ0dCpZ
	 CiMS6zzhjv/36ZrQbaLmZ1nQ+BSDM7tPlH6/s04E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/554] s390/ap: Dont leak debug feature files if AP instructions are not available
Date: Thu, 15 Jan 2026 17:41:59 +0100
Message-ID: <20260115164248.165168599@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 020d5dc57874e58d3ebae398f3fe258f029e3d06 ]

If no AP instructions are available the AP bus module leaks registered
debug feature files. Change function call order to fix this.

Fixes: cccd85bfb7bf ("s390/zcrypt: Rework debug feature invocations.")
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 1dd6dd2ed7fbc..489dff1dd94ef 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1873,15 +1873,15 @@ static int __init ap_module_init(void)
 {
 	int rc;
 
-	rc = ap_debug_init();
-	if (rc)
-		return rc;
-
 	if (!ap_instructions_available()) {
 		pr_warn("The hardware system does not support AP instructions\n");
 		return -ENODEV;
 	}
 
+	rc = ap_debug_init();
+	if (rc)
+		return rc;
+
 	/* init ap_queue hashtable */
 	hash_init(ap_queues);
 
-- 
2.51.0



