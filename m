Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018748;
	b=5Il8M8jqgyxBg4hCG2PuMN/Mi8YQm5b7ey+JScPKVojQQIMfVCRMXUC2e+dX8FlJAlsk
	 Wev2hkf/oYU0tqBARd5dQK3WPXxwMpJH8a1FB/aatlbek0n5FBRjH0wJOEywhyRQawNas
	 VyBWPWIx3gBK0hpTQL7T8/O4XrLIt7WWbSOlA1eKuYHLt5fjAQacp4e21D5ieAdog6ihX
	 zK+F1WWE66PjnnVs4gqrtIOb0APWPWGEwT6iPWzSvy5hJiFrkMi28okrVWuwGX02JuhVm
	 mjt/GWCsH9SAibQDuaI4+flACBxJkX4ZoyYSX2st3fWZuJMOfpH8v2uVj33V+lNfpOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NGBsqlqdpE/lY2OvCTQ9vjb8TUi09jf4Udx95dfeegk=;
	b=isd3nmlgkhytXIFwlAgnKj5bZilJCH4ULW/0ErwP0KCLzEv2dyUxyXipwgBxLKx6eafz
	 1brhmPyrO9iG6JE8r+qCiYZXL8fyhhyjVEHpmxdzLKrUflCtdDU9qCAbvMYSCVkMFxJ3y
	 xyhOUo4jrItKatL8x/KjSGboH8V997lNpAeppsXcxEXQfI6TWZzrFTxcRViMWh6Ocy7Td
	 SIwjQKwkmgaAgbqeKA8qmX/MqTvBC3gChEBhQMCbOTIzO01qop5Z4R632wEUG19/s9AOZ
	 Yx8y7tZWAvbZLHxSQe0jc607dvP92/H5UhJz8fXSYbYTpR+lfQCd4160bZUlpkXjaQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KZSYiYD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DD6606A32A;
	Wed, 18 Nov 2026 16:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KZSYiYD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B915B1F000C7;
	Wed, 18 Nov 2026 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018748;
	bh=NGBsqlqdpE/lY2OvCTQ9vjb8TUi09jf4Udx95dfeegk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KZSYiYD261XsPAIlm7Ia2zi+2MTw5y1yXyEb/cUObDXiGAykmHNS4iAz1vLo/gUb
	 3zqDRQrYpL0WerzJQzEGtBug7doieW/uDSfM/fo70tj9GpCHhgtYe0HxhJR05/x9gO
	 bkdKHP/LxgCrapzMkN44f3Jb/kmN4nClDBCcXF3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1309/2651] wifi: b43: dont pass unterminated string to sscanf()
Date: Wed, 18 Nov 2026 15:42:29 +0100
Message-ID: <20261118150335.100077609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 31a1ff00c1a45..173ef5db90fcc 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -557,7 +557,7 @@ static ssize_t b43_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



