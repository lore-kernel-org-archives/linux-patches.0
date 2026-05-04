Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9735B3DE452;
	Mon,  4 May 2026 14:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904326; cv=none; b=ZqYtU6ZzM72jhmLj+y8eBrbZBVLZSCN650cXhTmThgXj3TRzxKB2du8sdKnfss8eqSk68U+CZqsdiNYqZIGNm6GNECxw5MHhoIUJl33/PwIOmRowx3XBqKZK0OP4/mmqPRuan7HVO5GUOCjD7tTEHkk3lXSYpiuGno8x1QFTl+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904326; c=relaxed/simple;
	bh=CbkbvLOJw2dilJz5VAymm9OuaQzVREKBXRlu+prRWVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcyvO72Gp134M2K5QS5iAjg2yW6FcFjdSMZL+eLslSFnRgfe+nl9SpFUXYZ9p3KqVLQlZQxSMQzcbmLQ0vM6zFsrLkcNE1hio4qvC/dlVc1cULWswigRePjmtt/7bZEjawLheb9jgk+Qq80k3h1f1nnnQlqJF4/A0/wDxOJgvbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyHqmfPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyHqmfPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2C9C2BCB8;
	Mon,  4 May 2026 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904326;
	bh=CbkbvLOJw2dilJz5VAymm9OuaQzVREKBXRlu+prRWVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyHqmfPsv2NdMXK+VGnScKjmwWQqlP3oZN5Y2oEVCNpOnKkaIGKap4B57V/MHQT25
	 GU2jdIakKD+yy1EQtQA5guCyw6/rXWaHf3svHXWLtlm0BIAXwjEQ7f0Tgp+HTgdWEi
	 y+DDwLH69IAhE7WBBTbfcJItKw1reMqIerloN41Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 229/275] crypto: atmel-sha204a - Fix uninitialized data access on OTP read error
Date: Mon,  4 May 2026 15:52:49 +0200
Message-ID: <20260504135151.566541451@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit de4e66b763d1e81188cb2803ec109466582fc9d1 upstream.

Return early if atmel_i2c_send_receive() fails to avoid checking
potentially uninitialized data in 'cmd.data'.

Cc: stable@vger.kernel.org
Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp zone")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -106,6 +106,10 @@ static int atmel_sha204a_otp_read(struct
 	}
 
 	ret = atmel_i2c_send_receive(client, &cmd);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to read otp at %04X\n", addr);
+		return ret;
+	}
 
 	if (cmd.data[0] == 0xff) {
 		dev_err(&client->dev, "failed, device not ready\n");


