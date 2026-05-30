Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F221279DC9;
	Sat, 30 May 2026 18:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165790; cv=none; b=mAT8R45XPirOFA1InZlc7VuZI6MzQgEeRTgUHQ3Azrn8EYOxGNVjTuu9S8kV/kJ6vJ1oLRKB3V+lOIpFdLqfriIcyX1KWcB0bKcbTwyXBQyl3QqhP8NwoRaVTP0UhIYfaA7ynyeglsR43+Jkk5lyVoHxunYHoeeud13tuYTqpOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165790; c=relaxed/simple;
	bh=mh8W6uFyuWERORdRNQGiKZOVPz6UH/9vWKdq9oiHllw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRD1ng9uKd0vqqDSv/VtHr6NP40ZTX33yypcapklCt+22TU3nNp9PqX0PsWn286GLT8hVFLkSnvXJqwQmQWoHq5EeUsqvaiDQTKQfq2rb3+YuiQgJmQhMweVDfkMQj622CNL5pt68To2kxYGsr7sXeVUKZzHDnUILWODRHtbVdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBC0mz4L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBC0mz4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CE91F00893;
	Sat, 30 May 2026 18:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165789;
	bh=NaTFzj8X0ZdfjzTBoIG+SEkuavJmmaCmcWmH+lyzKoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBC0mz4LgDXTTIVnJnPjFKEGnRJXyoAwRhmNP8nPARjkoOpXlSFjVqFxhgnOaG4FJ
	 A5Yn7fE7RGDe/gKxT0FedRO45KaC7V+L7YSeWjwlY2VqoBoxnEwwMZyvYrE4GJ2kPW
	 r7+auhVWBWZv3AzxE4mVgnDQGKOJ3DOa9+u633I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/589] mtd: docg3: fix use-after-free in docg3_release()
Date: Sat, 30 May 2026 18:01:04 +0200
Message-ID: <20260530160229.699934178@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Kim <james010kim@gmail.com>

[ Upstream commit ca19808bc6fac7e29420d8508df569b346b3e339 ]

In docg3_release(), the docg3 pointer is obtained from
cascade->floors[0]->priv before the loop that calls
doc_release_device() on each floor. doc_release_device() frees the
docg3 struct via kfree(docg3) at line 1881. After the loop,
docg3->cascade->bch dereferences the already-freed pointer.

Fix this by accessing cascade->bch directly, which is equivalent
since docg3->cascade points back to the same cascade struct, and
is already available as a local variable. This also removes the
now-unused docg3 local variable.

Fixes: c8ae3f744ddc ("lib/bch: Rework a little bit the exported function names")
Cc: stable@vger.kernel.org
Signed-off-by: James Kim <james010kim@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/docg3.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index fa42473d04c1b..378239c7513e0 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -2042,7 +2042,6 @@ static int __init docg3_probe(struct platform_device *pdev)
 static int docg3_release(struct platform_device *pdev)
 {
 	struct docg3_cascade *cascade = platform_get_drvdata(pdev);
-	struct docg3 *docg3 = cascade->floors[0]->priv;
 	int floor;
 
 	doc_unregister_sysfs(pdev, cascade);
@@ -2050,7 +2049,7 @@ static int docg3_release(struct platform_device *pdev)
 		if (cascade->floors[floor])
 			doc_release_device(cascade->floors[floor]);
 
-	bch_free(docg3->cascade->bch);
+	bch_free(cascade->bch);
 	return 0;
 }
 
-- 
2.53.0



