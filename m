Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88261DC184;
	Wed, 19 Feb 2025 09:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956343; cv=none; b=S3LoP2ablj7j/wvBRRUw4G8DbRxpr1lgg0SrxkWY+9uB5Q1aL9P7n9jCSAzEPi7B5cQog6B0vqW7ZxPXl5JFH6fXJso5t7gO/yA6F4DckjFwwDRKxtIruKaoUxUBrNjlqndVzRIxCy+BFToSW99HP/ezj2nNt+2sHvML3wwuUec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956343; c=relaxed/simple;
	bh=E1zuAFxbEWnUzF9u4QgLA1H1XxigXGSiP0KrpT8hwhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZIgvAzTOLjweAn1VlAlfGC6BvN+PAPEdR3aPWaQfGw50O0gBX5PUdPr3smp3aRJb4f0/9mexi4s+/vhL5dstHRwHvzL/HO8aLQLnu+HIudtiMOsh9Hbjc9UA1RVNU9g9NMNPVBd+b+yMVVQflD0+lyu80w45tnG35rddj5AEwCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwA4P33w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwA4P33w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6806DC4CED1;
	Wed, 19 Feb 2025 09:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956342;
	bh=E1zuAFxbEWnUzF9u4QgLA1H1XxigXGSiP0KrpT8hwhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwA4P33wqK0+3QOtNLb4Cbu6vLJy/cQQ0Fdwc8Y6I2zY8e+B/5PnTxNy6MPfllLhQ
	 dy3B6U7rHu+QzIyNKoaEELrT2Bv7eNQA/jDHGciyEK7Fs2jgH1Rwt2SCc37la0DW2Y
	 gDJD6LIPYcsCf6QX5ZihUtQ3r08qGRyuhlpKKRXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/578] padata: fix sysfs store callback check
Date: Wed, 19 Feb 2025 09:21:59 +0100
Message-ID: <20250219082657.505106246@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3e7bf1bbc6c26..46b75d6b3618c 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -959,7 +959,7 @@ static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
 
 	pinst = kobj2pinst(kobj);
 	pentry = attr2pentry(attr);
-	if (pentry->show)
+	if (pentry->store)
 		ret = pentry->store(pinst, attr, buf, count);
 
 	return ret;
-- 
2.39.5



