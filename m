Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841EE25BACC;
	Tue, 11 Mar 2025 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706459; cv=none; b=WpPF32vIPKJX9Rz6A6GX4sw1rVnPEcTtJNPwa0SYJIktFTj0lpWRE/PzFmaw5CG6lynNdysujv/r7ytQf/PPKFfFLzNdpBOQnQuuwfYdZ99SYN1soUoAIJBEk0LJXk8/AX6ApcPNI67Ff92lZpE3ePe54rVP/2E9+aKn2xDdkoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706459; c=relaxed/simple;
	bh=fbIHs5yRUKMt5s+kB9LIScSSr8n0H6LwqNFHYUqja+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2N0DfMXSMEXUh3wAh0FxL1RA1J8ZYYyttG8fbp7b0KdeBocNOHB+adKq2nHskU775ZQmQ4ZiVx2hPFPSlUZDa/njEGAywRqrm6l/Azbf+2Tr+RMLMU5771NbDcubb2dx5imRl9CI/7tVKRS4xDa8hFkMPgFanQZd5H4UvcwKVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pw3rfYAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pw3rfYAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EB7C4CEEC;
	Tue, 11 Mar 2025 15:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706459;
	bh=fbIHs5yRUKMt5s+kB9LIScSSr8n0H6LwqNFHYUqja+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pw3rfYASbnPgE4cHS+ZuYi5prpyGaA3DgTlgZFsxPV2cQgeR/s/q51WFBBXl6Ermj
	 A1BA00O1HsYeU0Iml9j7C2EQypCoqZ8SHQNgnPzDQsL9eA/Og/C5m8nivqC4OoaJ8b
	 y5PgfQQUrpe8rHmLrm7nXU9c7QA8riDxNttDq2o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/462] padata: fix sysfs store callback check
Date: Tue, 11 Mar 2025 15:55:22 +0100
Message-ID: <20250311145800.566395319@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 9ff6e943bce67d125781fe4780a5d6f072dc44c0 ]

padata_sysfs_store() was copied from padata_sysfs_show() but this check
was not adapted. Today there is no attribute which can fail this
check, but if there is one it may as well be correct.

Fixes: 5e017dc3f8bc ("padata: Added sysfs primitives to padata subsystem")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 914a88d9cee14..a2badc5dd922e 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -972,7 +972,7 @@ static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
 
 	pinst = kobj2pinst(kobj);
 	pentry = attr2pentry(attr);
-	if (pentry->show)
+	if (pentry->store)
 		ret = pentry->store(pinst, attr, buf, count);
 
 	return ret;
-- 
2.39.5



