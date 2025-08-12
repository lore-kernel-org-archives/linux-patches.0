Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716D61C1AAA;
	Tue, 12 Aug 2025 19:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025496; cv=none; b=JNTMbF0fg3rLR2AAXfDzvk2ObYdCKbUE9+O6S0YpxCgmALoeffP2lBXfzjMg+8FfLydjFnm3v2f09pwy/WPYz7txpVTfjFJVYL11MaJij+dki+Mh+ShSab8iba/8S+CW1QBs8L7g78JUz6tBiPsuyyvantd115zh8m2Vmpkct0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025496; c=relaxed/simple;
	bh=GAGp2rrF1YFvL4N0YvTYj4IbMG44YYEhqBiWfroiQiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Umf5FPGFQ2rWPZTMEr8IQd9ruIOiWDGiP/0rUl0tcOFhh8KpJEj3iWIRswHzC840wsKmxwYR/yOdIGa6wKsSnHtTQRrKnh4DRTMRg+tXumxz+c/jNcLc17X7xVjatFXcuVkPnZLzQkfYrMkxSSAj9+BPiDpVg9BUFrzYnGmlRUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exXLi6o0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exXLi6o0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A94C4CEF0;
	Tue, 12 Aug 2025 19:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025496;
	bh=GAGp2rrF1YFvL4N0YvTYj4IbMG44YYEhqBiWfroiQiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exXLi6o07CM6VExyrLKFoasvCLnoc49DsyWr8pANYRwLzDNvrv9JTakK/gYGLtnjI
	 QWImLJK38G+gwAHJwU7Q4v+Lr4gYYgT5cOxu1FEPzOVrGNo18WKY4aTik3ra2XKfvz
	 BM76xD38yt1Lor2WPZEOKDvH7adnL/6HyvWfY1ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 059/480] drivers: misc: sram: fix up some const issues with recent attribute changes
Date: Tue, 12 Aug 2025 19:44:27 +0200
Message-ID: <20250812174359.850533629@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit bf7b4a0e25569ce39c6749afe363aefe5723d326 ]

The binary attribute const changes recently for the sram driver were
made in a way that hid the fact that we would be casting a const pointer
to a non-const one.  So explicitly make the cast so that it is obvious
and preserve the const pointer in the sram_reserve_cmp() function.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Fixes: c3b8c358c4f3 ("misc: sram: constify 'struct bin_attribute'")
Link: https://lore.kernel.org/r/2025052125-squid-sandstorm-a418@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/sram.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index e5069882457e..c69644be4176 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -28,7 +28,8 @@ static ssize_t sram_read(struct file *filp, struct kobject *kobj,
 {
 	struct sram_partition *part;
 
-	part = container_of(attr, struct sram_partition, battr);
+	/* Cast away the const as the attribute is part of a larger structure */
+	part = (struct sram_partition *)container_of(attr, struct sram_partition, battr);
 
 	mutex_lock(&part->lock);
 	memcpy_fromio(buf, part->base + pos, count);
@@ -43,7 +44,8 @@ static ssize_t sram_write(struct file *filp, struct kobject *kobj,
 {
 	struct sram_partition *part;
 
-	part = container_of(attr, struct sram_partition, battr);
+	/* Cast away the const as the attribute is part of a larger structure */
+	part = (struct sram_partition *)container_of(attr, struct sram_partition, battr);
 
 	mutex_lock(&part->lock);
 	memcpy_toio(part->base + pos, buf, count);
@@ -164,8 +166,8 @@ static void sram_free_partitions(struct sram_dev *sram)
 static int sram_reserve_cmp(void *priv, const struct list_head *a,
 					const struct list_head *b)
 {
-	struct sram_reserve *ra = list_entry(a, struct sram_reserve, list);
-	struct sram_reserve *rb = list_entry(b, struct sram_reserve, list);
+	const struct sram_reserve *ra = list_entry(a, struct sram_reserve, list);
+	const struct sram_reserve *rb = list_entry(b, struct sram_reserve, list);
 
 	return ra->start - rb->start;
 }
-- 
2.39.5



