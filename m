Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB579335BA7;
	Mon, 18 Aug 2025 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525155; cv=none; b=n7kJfZZp0D2icEoZrL/kTiQdoYB+VU6hqZ5JZNWGTxlQp88Xw9kMMw3sBgpY0rXAiepQZej3tUBKiiaP891aL1WOTyZc5P51RyH4abyeBBRPsDmLhakUEjTZCfQlRxulrsi3cu/JSe0YSi65Gd75JhAdfjZMIWdT0xlA1XavjLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525155; c=relaxed/simple;
	bh=liWbcz+RLfLi7h96MjxtsExJMNR5I3JzrwrMkkh06q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGLR497MmjASqRUTOCUPDRm/8WeyK1V7ceYySrkqWGd7eXLv8zSnpuXoW6rLH7jVUU4FjdGjo5im4EfT+Oeg+bjFgaC6IOlG0LqFpGLf+i9rBMafo/akQXUINnMVplXEY/STIdWNrZ8jOS4LzoVjkC5NdgGFHm47uxPguwHe9fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRqwqQS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRqwqQS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26D0C4CEEB;
	Mon, 18 Aug 2025 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525155;
	bh=liWbcz+RLfLi7h96MjxtsExJMNR5I3JzrwrMkkh06q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRqwqQS72bec6PoMv0G+O8n7hFyb4Qs9Gwkjf4GsNeBLhdOuDK3llN0Z4SzYQJSmn
	 xiiLTi5MHAY2fJIOCNy4FWNI2aHEJlp0SAQ8G+MtwmwGEEFHO2Bq7es5SSXe87OAOs
	 aM3RzU1+iz7zlmHr1qwXGj3WQYdF312bMd1xAVqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 176/570] char: misc: Fix improper and inaccurate error code returned by misc_init()
Date: Mon, 18 Aug 2025 14:42:43 +0200
Message-ID: <20250818124512.577141794@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 0ef1fe4bc38673db72e39b700b29c50dfcc5a415 ]

misc_init() returns -EIO for __register_chrdev() invocation failure, but:

- -EIO is for I/O error normally, but __register_chrdev() does not do I/O.
- -EIO can not cover various error codes returned by __register_chrdev().

Fix by returning error code of __register_chrdev().

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250620-fix_mischar-v1-3-6c2716bbf1fa@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index d5accc10a110..5247d0ec0f4c 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -296,8 +296,8 @@ static int __init misc_init(void)
 	if (err)
 		goto fail_remove;
 
-	err = -EIO;
-	if (__register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops))
+	err = __register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops);
+	if (err < 0)
 		goto fail_printk;
 	return 0;
 
-- 
2.39.5



