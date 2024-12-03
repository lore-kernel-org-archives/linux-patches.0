Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90A11F76BB;
	Tue,  3 Dec 2024 15:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239524; cv=none; b=Upe47fbdFuI5kbYSSNHl2iEtWFPa3nTC4YfQ7e0+3KOja4COEhVdHujJfdiOjjIwRrB+aPfReIJW/fSo5d7lOmyZtme51jUEwsfWKuARRPszvG+KOqjQQEDPZ9OrP2Rl1O6NpUtpXq3JWSTQKBZwoAVOYl/cla3RwVDrSaqv+co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239524; c=relaxed/simple;
	bh=qh0M576BUHbnsivdoPgXZF5it63wYmDbmOuurBxOoMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QE88oVCwY9iXHGDcYY7sWI71Q6W1y4E/PUySQ0eWnk9rCLHE9PmnWOoJ6k5nKqN0XBJys0FX51B1Si84kf/OQ/tZJENspjaYIQURy1lRhpJ6UtlNfGu3X8v78dLPgzF4yFdV7r1HmpCh16GKEjpgHOEGw92wRPDx0wHQdpDKt2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnF3aQX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnF3aQX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507E2C4CED6;
	Tue,  3 Dec 2024 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239524;
	bh=qh0M576BUHbnsivdoPgXZF5it63wYmDbmOuurBxOoMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnF3aQX3NVctEDSh/cc8hrv22s9SozEwyiv9RrKjrP1OgQGGp1OOUJwOH0lcwL6a3
	 8v36pIVPmEvVQDruvJN17B4s4xNTMTHD1walc3x2teIlv4+AZj9badJBtD7/29kOgI
	 Bj3N4rWe3ya13nCHDBd0AYfi3r6jy2nXmdhHY7ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Russ Weight <russ.weight@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 612/817] firmware_loader: Fix possible resource leak in fw_log_firmware_info()
Date: Tue,  3 Dec 2024 15:43:04 +0100
Message-ID: <20241203144019.822730613@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 369a9c046c2fdfe037f05b43b84c386bdbccc103 ]

The alg instance should be released under the exception path, otherwise
there may be resource leak here.

To mitigate this, free the alg instance with crypto_free_shash when kmalloc
fails.

Fixes: 02fe26f25325 ("firmware_loader: Add debug message with checksum for FW file")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Russ Weight <russ.weight@linux.dev>
Link: https://lore.kernel.org/r/20241016110335.3677924-1-cuigaosheng1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/firmware_loader/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 324a9a3c087aa..c6664a7879697 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -829,19 +829,18 @@ static void fw_log_firmware_info(const struct firmware *fw, const char *name, st
 	shash->tfm = alg;
 
 	if (crypto_shash_digest(shash, fw->data, fw->size, sha256buf) < 0)
-		goto out_shash;
+		goto out_free;
 
 	for (int i = 0; i < SHA256_DIGEST_SIZE; i++)
 		sprintf(&outbuf[i * 2], "%02x", sha256buf[i]);
 	outbuf[SHA256_BLOCK_SIZE] = 0;
 	dev_dbg(device, "Loaded FW: %s, sha256: %s\n", name, outbuf);
 
-out_shash:
-	crypto_free_shash(alg);
 out_free:
 	kfree(shash);
 	kfree(outbuf);
 	kfree(sha256buf);
+	crypto_free_shash(alg);
 }
 #else
 static void fw_log_firmware_info(const struct firmware *fw, const char *name,
-- 
2.43.0



