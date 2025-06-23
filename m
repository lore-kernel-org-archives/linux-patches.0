Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5671E2528F7;
	Mon, 23 Jun 2025 13:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685278; cv=none; b=Yr3WvTd+mHsa0wkQfsr4PxzwtZ3liaRt1CaqCHqHtcAFLHx1jNXuw/s0/TaJJxk1HoNK5fVMNok6Qx2pK+5A1XuLdT4tsZK+6Yd2VGi/S2OjqQBk6t4PleT6cBnMzHmVDsUbEL5pSZhLFwvvzsJDIaC8xR8lwGL+Nxx+ZXKptlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685278; c=relaxed/simple;
	bh=2g7lFnTuF063fH0w6Eed/gbEXvmWUJSC/e24HIYDFnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=at6cRjvnhLTjl7XboxXpkVDFw+Jd1SK0PJRpqpR4sQyK31AL+EPuLxeoCzy30jAla0qudrmHyi1VWYAvHrFsmOqiZ8S/LBnv2hpqBoemSAYGPsphdMvmH9fOkNZt4VUDs5JJ8FjDPFLyC8DmfrqvbFW1817q8dilDMgUAO89Oek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Th8kzFII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Th8kzFII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908E9C4CEEA;
	Mon, 23 Jun 2025 13:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685277;
	bh=2g7lFnTuF063fH0w6Eed/gbEXvmWUJSC/e24HIYDFnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Th8kzFIIHfZRWFftp/OaoB6ICdGZGRcj9LySB3n+IQVkLmtcwzBXbbp48EkV66Xks
	 T7e3xBTWrFObzcJ06CkwMluue2smnNelROUucmeSCIIfaofe7dVwFZS3gN1sxUPURk
	 mkxVZ+WcDA33em8LfYskl+/rfCbcxE5NkTWH55g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/222] serial: Fix potential null-ptr-deref in mlb_usio_probe()
Date: Mon, 23 Jun 2025 15:06:40 +0200
Message-ID: <20250623130614.063975348@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 949ab7efc4fcd..e7ad13e2323f3 100644
--- a/drivers/tty/serial/milbeaut_usio.c
+++ b/drivers/tty/serial/milbeaut_usio.c
@@ -527,7 +527,10 @@ static int mlb_usio_probe(struct platform_device *pdev)
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



