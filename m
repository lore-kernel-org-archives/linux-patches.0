Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624022;
	b=Y3r1zdJs3b4TY5O7HISOjcpVjg2vG4nJXdtojqSXSijqaY8iXeEnvn75ItLjuLYGulqa
	 wXduwd3aRK43VK3a82ytvYw+rSND3u3pVOd/LJclbW9+EDwwKl5R7TGLftZVYkGh8tShg
	 bjZjsY8SkkYIDGC0lqeZG18jYWxyPA5zbsVQACZ9otxzAHWFIHRK/ddn+yePA9cI5rcA3
	 mjeAZbau9mNbNK9adqzpTyzChaC/PznKODWo/4yJo4mXXJxmb3rNMt+1C3SiUUuciL81a
	 Zh9xJbPYjJvE2yDEonM+skkiB75dA5gG49d2UJU0SXZFmsaYmxN9aO18gzpGtsos9YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kSpdCFvNByUWMDKtF9vMDIIghf52i2emo0haGRxL7E8=;
	b=02i6onYzsojHfekVwXiQqdMUsQqhFSvpXGxFrIkF1WweUXDDkmsNn8/aczY2zkX4xiHt
	 9gMV91YzJSPZSRGWjelXcQjhgEhQgi/qCQyKESDUUkGOK1wjHSwg96UH/yaYUiqN58eeB
	 N4FF4FoKaHpn1nGoTXrFkvmNikErtJ5MBcggSv372ucz6MpM/gbWcYDgu/v1gGVIEhbBL
	 X9vwge44ACNkewCZw7IsXHD+I8G9B0FDpwBtSVHWbgz90virLaJjhWTx3qdk3wVcJRyeS
	 6yiDZ6/x0IBYhZR316Z9ZL8kdUvc9K5VbzjGXD35ebo+csxNrCXrjtnzc+nad4apfLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rHJh7H2x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA058606A334;
	Wed, 25 Nov 2026 16:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rHJh7H2x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065B61F000E0;
	Wed, 25 Nov 2026 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624022;
	bh=kSpdCFvNByUWMDKtF9vMDIIghf52i2emo0haGRxL7E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHJh7H2xKOJL5JLqV1EMaJqCHmrdhUReiFlfYHdnk+coV9NaqcDAYFFqFYfKOkvUK
	 bxEpKZblr6cZH/Hj0W/ncgfP3e/JNyT355tYbHGZ/J4Xyk2zM+5ww0dqp5NDbl7kC1
	 l9LA75j2YopH27RcdFkE/OhlDLew7yqFUH7sML3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/816] scsi: scsi_debug: Drain target cleanup before module exit
Date: Wed, 25 Nov 2026 15:26:48 +0100
Message-ID: <20261125143850.608067111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe Piscitelli <ooonea@gmail.com>

[ Upstream commit 34c99ce2993971712d89010a948d2f650687b796 ]

Target destruction queues cleanup in an exclusive async domain. The module
loader's async_synchronize_full() does not wait for exclusive domains. Wait
for target cleanup after removing the hosts and before removing the debugfs
root and returning from module exit.

Fixes: b402a0dce64a ("scsi: scsi_debug: Fix create target debugfs failure")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
Link: https://patch.msgid.link/20261026202342.668361-1-ooonea@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 27e882a6244d9..7a1ad88669eeb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8315,6 +8315,7 @@ static void __exit scsi_debug_exit(void)
 
 	sdebug_erase_all_stores(false);
 	xa_destroy(per_store_ap);
+	async_synchronize_full_domain(&sdebug_async_domain);
 	debugfs_remove(sdebug_debugfs_root);
 }
 
-- 
2.53.0



