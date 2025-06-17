Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E342EA145;
	Tue, 17 Jun 2025 16:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177760; cv=none; b=rOWsZTmXjRL4/tg63bV9wRh0Tnrt9IwTUyYkw/nvmzZvXhTThmSJvN3EDcJjSqZgwbhBobo+PXXBbVNyO1PIjBxFZp5AYJTNmDHbl4/q1x+ecwuXgkk0xW8znnwqqYzdBgiex0nX/lgYhxsf0y48jyGDq1a8c4qCNoRtSJ3J9TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177760; c=relaxed/simple;
	bh=ic5w4DvB5bO6k/DQLPzklGV1SizilgVsC87xPOZ04w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b552e/+rg8e1XRGcW9I+j4iH95NEhYwd6SjRXixBX2VoZ/AbzdWoZAAtUXMqmFiu3Xae7mETnBppdDhd0eiUr/bikEvXkW91tP9qV7/w8aFDBl3cY25WOeRMFSpeFXTKScUpl5BJIULysKXzhvCsPm6uhKRqKDn/Q95G8YTcCDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6kQMiEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6kQMiEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D32C4CEE3;
	Tue, 17 Jun 2025 16:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177760;
	bh=ic5w4DvB5bO6k/DQLPzklGV1SizilgVsC87xPOZ04w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6kQMiEjaDxxxprEJfzc9dmq9kNV8zAI1gejs+w8QQ92uOS/XcQDbg9n/OVTS6xvV
	 jpwYEaYwkd0+PPc6Q6KVOwBFi2uO/lHxEfmKnNUKBYn7h9DmjbU1Sbhxf6R1TN0nyK
	 ZdbBndL33L+2AqkjTXvTF/ejIX8NvDOvnSgWPZbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 327/780] net: airoha: Fix an error handling path in airoha_alloc_gdm_port()
Date: Tue, 17 Jun 2025 17:20:35 +0200
Message-ID: <20250617152504.763387558@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c59783780c8ad66f6076a9a7c74df3e006e29519 ]

If register_netdev() fails, the error handling path of the probe will not
free the memory allocated by the previous airoha_metadata_dst_alloc() call
because port->dev->reg_state will not be NETREG_REGISTERED.

So, an explicit airoha_metadata_dst_free() call is needed in this case to
avoid a memory leak.

Fixes: af3cf757d5c9 ("net: airoha: Move DSA tag in DMA descriptor")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1b94b91345017429ed653e2f05d25620dc2823f9.1746715755.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 1e9ab65218ff1..c169b8b411b4f 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2541,7 +2541,15 @@ static int airoha_alloc_gdm_port(struct airoha_eth *eth,
 	if (err)
 		return err;
 
-	return register_netdev(dev);
+	err = register_netdev(dev);
+	if (err)
+		goto free_metadata_dst;
+
+	return 0;
+
+free_metadata_dst:
+	airoha_metadata_dst_free(port);
+	return err;
 }
 
 static int airoha_probe(struct platform_device *pdev)
-- 
2.39.5



