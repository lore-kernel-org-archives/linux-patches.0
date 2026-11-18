Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051273;
	b=ytbDB1ysgH811apAKYY+pjWtkB3gKP01p1yxfjBcAsjBnbMsUBT0Hb9awjx9nmE34tQU
	 wgp36w57K7Ac6VpPkd+CQLfoarkGJ9JXRDjjN9rq99QTuIUA9WAHG12HbvQzRy6fRW/xr
	 UdJ3SNOxBquXJkT/+DP/KN5CzAZXjaOUhffKzdgxHkboY1aNXMoZWzOl/Wd8qaNZgV0lv
	 aUc0LoWAHwGf2PJ+Etg5UWOBguutGnaU+qqsQKWMSBWRzaiywuc6nP9Tj64Oeyl++nFQG
	 U73jtTlN+LxxeQgbJITOEMgGM75rwA8x3SyUeZ4y7W2b1UtgZZ0K0AVKUt4ZfrsVK/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=moNzGoOX/KOXkeY1xfnwv8JLlL3C67oq7sNUjtZ9xMg=;
	b=He1QSwFSYzWDDiNMYkKn6r+BnnuiR6P2npLTfDRakmSPKBqgLyZhGdpvK3+8hatyeh7s
	 +IOtO1JXYndyboJGB23+Wo6QtX9ztWxK976PC+607ieXC7LbOIPY9xk6X/NlrWNfOQvy7
	 qkY/2mhkXbrz270u95pD4iME330zcXCYyIGFuBoYPPbe6odoDpYvZxtOQFQdgKBEE0uC5
	 Gelfw/KglyUzoOwodLCZ4T9WqAW3is8tyVh4ooBr86MrkmE02bFqRvMiELKt340BKrT8r
	 l/PBvEswsZmbJ1U3B5menHcIyrZI9uXEzFlW/JQoCY5jGSbtqozPpY8LYejL/ZzdhmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igz5qWh3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011F7606A32A;
	Thu, 19 Nov 2026 01:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igz5qWh3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579671F000C4;
	Thu, 19 Nov 2026 01:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051272;
	bh=moNzGoOX/KOXkeY1xfnwv8JLlL3C67oq7sNUjtZ9xMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igz5qWh3lHXOGOwFwHsvWUwch3B77jI+hRYLhB09YdFD/ZAAynp8OeKcJpdGdWWe7
	 10qPTq8TkiIlfhQaHQZ6eArkv844sHt0zP0nNFJKZbLgIQXnhlQVTfWdgxswia6iVH
	 NA8+LHHfrrtgEnHpWpBw9C6IMAaM7ocmhNsbapgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0150/2214] exfat: free new directory cluster if zeroing fails
Date: Wed, 18 Nov 2026 15:30:26 +0100
Message-ID: <20261118150016.158726974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit ce12a39bed483008683438962b3a605374e6f803 ]

exfat_alloc_new_dir() allocates a cluster for a new directory before
zeroing it.  If exfat_zeroed_cluster() fails, the function returns the
error but leaves the allocated cluster in use.

Free the newly allocated cluster before returning the zeroing error.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index a1e6f1c262f42..53b882d3ea303 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -325,7 +325,13 @@ int exfat_alloc_new_dir(struct inode *inode, struct exfat_chain *clu)
 	if (ret)
 		return ret;
 
-	return exfat_zeroed_cluster(inode, clu->dir);
+	ret = exfat_zeroed_cluster(inode, clu->dir);
+	if (ret) {
+		exfat_free_cluster(inode, clu);
+		return ret;
+	}
+
+	return 0;
 }
 
 int exfat_calc_num_entries(struct exfat_uni_name *p_uniname)
-- 
2.53.0



