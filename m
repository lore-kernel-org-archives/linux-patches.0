Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB473DEFF3;
	Mon,  4 May 2026 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903521; cv=none; b=on6wf6c274RLTXUPCKpp0SPJ716yE7OcM5n+a4C5WPg7+9xEiDJ9yFtQW1tMD6P3gRwqlQOYchxj4ZBCOYVteuonaZukn4yx2f//kHYOjqI0NHK+afROukp6Lyec6gYSZf1FO8hKzOQijIN+7bi4LKkNylvo6Yq4FZR/dBetrwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903521; c=relaxed/simple;
	bh=wK1NwcX6V8dX6wWQo8JGe6Y4GqNIM3jTSQkrt+BUr1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htnrSF2bbDggrCDRFNWvrsADVcx2JRVHc+vmgoxeVdkTABSO3T34UKTD5Sq53dqRe+VRayhU4YicHILBH9uhn5Uj08lrPFpcOT00PPAbd6Yzr7lgtqW+O7RAnCnB03QrnDn8aB2G5RTA4uA4uPmyJ6Ixn07x4Q3kdo+6CztpmDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShjiLaNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShjiLaNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332ADC2BCF5;
	Mon,  4 May 2026 14:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903521;
	bh=wK1NwcX6V8dX6wWQo8JGe6Y4GqNIM3jTSQkrt+BUr1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShjiLaNTMbF/pTr9I1oGlqnrfMgu0WMwQVl6XhKqiIBOhpjn7GqM2motSmaNfj5/E
	 Fpqn5pZNbt501A/Qk5vAd5AeD2YyMs5nb0kI556FIBKZs+h9g/4iyPxbA7uyclh/12
	 Kqw40odQI8wf0agqjmejeuBhQpSUHdUu4oT7TJZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.0 266/307] crypto: atmel-sha204a - Fix uninitialized data access on OTP read error
Date: Mon,  4 May 2026 15:52:31 +0200
Message-ID: <20260504135152.819854035@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


