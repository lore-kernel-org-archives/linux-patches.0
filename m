Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320D533C526;
	Fri,  9 Jan 2026 12:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961601; cv=none; b=txooJxV8Vaud6a6V5oYwH0zJSjDoFhsL++js0gNTQPcv5EYwE4re+adROXkh4KASkijnMmNW2x39YPO73MKweTF3+AP/6PuViqHBlirlbHFc6xeqM6hBVNr1Fkv0ZBAJ3jFuzqigsim0qXC8UGvpPEgvtbqUv478gvSOYnLeJhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961601; c=relaxed/simple;
	bh=7tx1CkdMnp/hb3jQ9I7I/n+hlupeWMY84sSi9pFVUaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7IEW8yJf7oI8hk12n/MOLsecTCofP/d9u58wrLIms+3BYlln14CozZBvYWE9md3Mw8hl0SepoYUok556GSNc/OXhbmWxQaGS2JSk0UmjuoHkDVTuNXjvsDxJS3/0OJnSw7NCS6qG+Nc3btq5nwnHI6Mg9U0ZoEvB0gp6wjBvdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgNST/8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgNST/8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BF2C19421;
	Fri,  9 Jan 2026 12:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961601;
	bh=7tx1CkdMnp/hb3jQ9I7I/n+hlupeWMY84sSi9pFVUaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgNST/8A0MsXuzIc9Rj9BiiyYn7deYj+7eo+2n3ce+xcJ0tRKVE9Hr67xR6vLruM1
	 +VK4oON9NjHjDOoXpS2Rin2GwKELpuCghQ/crKO7GR1lPPIwBZHPufCi7D2egdWgTo
	 qCZSuxxabEey34h64cDXqjs4mMHuzUayp64JlYgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/634] s390/ap: Dont leak debug feature files if AP instructions are not available
Date: Fri,  9 Jan 2026 12:35:42 +0100
Message-ID: <20260109112119.854922314@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c692b55dd1169..4bc5210df78a4 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -2196,15 +2196,15 @@ static int __init ap_module_init(void)
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



