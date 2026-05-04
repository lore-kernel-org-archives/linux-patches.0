Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F36A3DFC8F;
	Mon,  4 May 2026 14:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904757; cv=none; b=eRWxU7VYkb+mvj5aw4TKjlcNeeIeBLHtfvEP3KSk/94jJ1q1tggPVy15xzjwgNWVVgUHrqYZHmDhl6Djlbf2fcPJi1adtWWXijdyowuMO/tn5hRVl7fMOg8bXbapM20L9NSuZx/T07txBI/lemzp/n2bY6pKUb/DK1SbQFcvCJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904757; c=relaxed/simple;
	bh=ICOFAFkD+QtWK2b0RI/v5OoDKmRGM03eXrl3O86F7vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDDbqgFXOdV9hNrtLr+U6YdRGzcbOga/80U7UYm+W3Zh9tFJpuDxkJizp/MQVUqzpV13o3mUrH96OcU3z7OBhw+Yt7SiKvfyXOLGRSKVeBQ+oE23U6WeOQWqFLvk5glJPMmQBNExOFVqYkTUsgGS5OvWhW6/7sy+ya+l5NB+Yck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftVsdbqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftVsdbqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA88EC2BCB8;
	Mon,  4 May 2026 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904757;
	bh=ICOFAFkD+QtWK2b0RI/v5OoDKmRGM03eXrl3O86F7vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftVsdbqFN+AjhuX9QKeGmMFZGKWAJncMkBLrTvcP7+b8G8pdQFBbQ9cqE7oXdgp64
	 b5X96ydPFJTQtMd+TIIVzvCaHvIOMOd3VVXj8jEonGvkFXaUHKOgiKHkgYWkAaVsId
	 nFl9/3aT0xIKG3SqEOl9xyqP4Z27JmT8KUlL4HYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 162/215] crypto: atmel-sha204a - Fix uninitialized data access on OTP read error
Date: Mon,  4 May 2026 15:53:01 +0200
Message-ID: <20260504135136.094283002@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/atmel-sha204a.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 72c9d74d3062..f9c7a4206774 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -106,6 +106,10 @@ static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u8 *otp)
 	}
 
 	ret = atmel_i2c_send_receive(client, &cmd);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to read otp at %04X\n", addr);
+		return ret;
+	}
 
 	if (cmd.data[0] == 0xff) {
 		dev_err(&client->dev, "failed, device not ready\n");
-- 
2.54.0



