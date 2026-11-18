Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025489;
	b=KSM1TenccpwufhR0Jn9cFbWgbchQQ93oAvuZy5UvI5R5TAStAR1WNCuWxiOUfBtXxhYI
	 STHWXXV2kgpO27CpwcHaK7H2VhuT3fj3UJzT52bgsAOSrztZzZFsSGJWHmpUkDAnBjkT0
	 CkpYzGei+CXNHaw7huLYof0sh7VBIukAkMsJjUtQIm0/xLC8ba0OfBxzwpUIi0MX4RAyI
	 LOQ1uuuKhcOyI3oSXytMAY8rW7dPV1OQ76UWMV6AzMEc79wPRsSaFNqrpo6hM/waCx+4a
	 Ya2Ehy5nj9ofOPb1X3SuguR908qys9EokkgSBc+iOZFKJ3DI/DiDhSAeJi8igvOhrMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=otprLeZWmE4cTrrxFdn2W/jcUZqyC1fkWhIA5bq6auQ=;
	b=4jY86lVrcjjBulQkOtqzl5ot6Nyqobbqyg5hTtSY+Q5DjKvKMRp3vR6nvZqEQQvFUhMT
	 A66N12t4F6qgXVWs0aY4BO1bEISnkwyD0b5QGysSMkbY+QNmmE/HzYqiXudc6aCccVjrq
	 qnxiFjAQpXq3P/1SWcY4VH61v6Wf4b3u18z2bUjsT/D66/r/gjRzZ3wi5bMmwlJ/8ssXb
	 pPZs1PVBxGuBc/yHhagaQ7XAfEl2pIH9tX47Me30ANdhecZqbhEYTdAmNWa7MMpUxRaSL
	 awma33AQRGVq/43CZw175NLI7oPydZpjzVURHujaSg12CjEhCrSHphkcp3QBlpS08wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjBV871q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D72606A325;
	Wed, 18 Nov 2026 18:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjBV871q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F931F000C4;
	Wed, 18 Nov 2026 18:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025488;
	bh=otprLeZWmE4cTrrxFdn2W/jcUZqyC1fkWhIA5bq6auQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjBV871qFxWVmhH6wRQNlr6rmuII+lFN6rcEewnzax20KqXx56EK8WrLYcg5na5rJ
	 25rAAGruIv3BWCU5/0XNklllBvwb/+YV272r36YTcjrqPh4TRQ2epYKChIP0ugL6SJ
	 YdUYSxcQBA/rf3vm3fE8abEV7pT0ywic40vqfsmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1096/2151] wifi: b43: dont pass unterminated string to sscanf()
Date: Wed, 18 Nov 2026 15:47:11 +0100
Message-ID: <20261118150202.192680691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 9b6cb072f9249e2cdb7c32be2b8069774c7e01e6 ]

The "buf" buffer is a PAGE_SIZE and allocated with kzalloc().  We store
a string from the user in it and then pass it to sscanf() in the write
functions such as shm32write__write_file().  Only a few numbers are
stored in the buffer so it never comes close to filling up the whole
PAGE_SIZE.  Reserve the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/b396713e697c7411b23a2157e2102c347ac900bc.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index 5a49970afc8cd..1214f65a5f6c0 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -559,7 +559,7 @@ static ssize_t b43_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



