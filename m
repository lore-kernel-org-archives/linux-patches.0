Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28802EA14F;
	Tue, 17 Jun 2025 15:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175973; cv=none; b=o7PSpfshfRmQMs+3UWmPw50+OZub5TlnO/Uu5eoKbnKBmJucSJTilcRic0UevsGl+tkdH4lzkOm3x8b3hkF4TVaLNg63M4UUx2RR0SIhxThxuzSlN1iG6HX5wq7iuz8xhaINe011ebg/zBRAXANdl+f0KY4fgC69UPHmHnO0lLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175973; c=relaxed/simple;
	bh=LezxC0aLNm1j/izh2yijIktPkls8e454K/phwrS5+yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEYVHcztxdIZLuYjnzfuRsTmWClYDuWqch+2MYy7XQzJID7vOQobaPAKUQt4HLjyJXAVk6wFJq9GaRCk/vVoQKdPSSEsA9aGMJKWlB9u0ZpFdtfOvccsP53sNLecaGfty0MpnrPAopytMoiDtoAJxznkcLUrIwSqeXfA09CwYpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuDRrw+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuDRrw+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17623C4CEE3;
	Tue, 17 Jun 2025 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175972;
	bh=LezxC0aLNm1j/izh2yijIktPkls8e454K/phwrS5+yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuDRrw+XypcVAG34Vf0GhUWaRjZNDir1sSAYHA7hfSvMkzOjWrSAAbROtXrd2846b
	 YnSsRSAow068M1Sjhb5RO0kIcrXCNlurC098dXz7HSiQcDGIe7yH1FSMXkOfATZfi7
	 oxAD/f5ZcTJMeqfhSo4AWgX42xJsgLd+WaZKmT8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/356] serial: Fix potential null-ptr-deref in mlb_usio_probe()
Date: Tue, 17 Jun 2025 17:25:46 +0200
Message-ID: <20250617152347.492796701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 86bcae88c9209e334b2f8c252f4cc66beb261886 ]

devm_ioremap() can return NULL on error. Currently, mlb_usio_probe()
does not check for this case, which could result in a NULL pointer
dereference.

Add NULL check after devm_ioremap() to prevent this issue.

Fixes: ba44dc043004 ("serial: Add Milbeaut serial control")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://lore.kernel.org/r/20250403070339.64990-1-bsdhenrymartin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/milbeaut_usio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/milbeaut_usio.c b/drivers/tty/serial/milbeaut_usio.c
index 70a910085e937..9de3883a4e0b0 100644
--- a/drivers/tty/serial/milbeaut_usio.c
+++ b/drivers/tty/serial/milbeaut_usio.c
@@ -522,7 +522,10 @@ static int mlb_usio_probe(struct platform_device *pdev)
 	}
 	port->membase = devm_ioremap(&pdev->dev, res->start,
 				resource_size(res));
-
+	if (!port->membase) {
+		ret = -ENOMEM;
+		goto failed;
+	}
 	ret = platform_get_irq_byname(pdev, "rx");
 	mlb_usio_irq[index][RX] = ret;
 
-- 
2.39.5



