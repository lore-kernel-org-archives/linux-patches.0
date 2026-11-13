Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591113;
	b=2gwPfYcXOngzYt9Zc1Ax5rqPHlvJiOfwjI8Zbr399iNwqQmuLdy9JLngFO9riapPbenN
	 j6yPQPhrsaHOrtYU/iFOO0hAB+Ogex/x4T8JUzH66iVxzjCEtvjAWHhPbucceSyT298Xf
	 utrh2l0fKDuSgvNbG2fcIgoVrdX6+uVaq9LFJjd0eEjIaJ+2NfQRAnRg+XHXkMAIciG+K
	 ECUZSAjtmY5zOcm2bVNv00voLrMkg/SERE1rNjx7gVlwlyoNnL3YAPcPJsG5HyMKdPhSM
	 3mgtWOABLUrqW84xR6VZnYCIlrl2/ULJIOzdRceHTD13dbEkNDpOxLB63qgmeVJYCIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RbEpgELqnuB90RFJWA+njewYgHOxsbzKGkAlGIw5Ii8=;
	b=o+P9vs+ci7JWvWwNNh2B2D3s+hhpkFB+AydnDwJpKfMsU38Es3+0wHw3VLtQa0NGk1My
	 xIRA6WG+YAhbCL+nrMKwBsCo5O5D5rqWLBQOpebT5D7NPzbf+nq2qO/msaSXl+ilYVv6l
	 Y5YWnhIqhe+s+8wvSVhknaabSQ2s5tAmJ1wde1nWQHcW8Qjj1j8nRqhBmD+pfu8VDgVAb
	 VK39cp2rpXAxPDuYWppsnDZElddevVUzXYk93v+B7OcKKHGnaQqEMk6/cfpcbSYg9Lo77
	 54txmyKSVTJgxHKEwNaGDiCDG+EEkmhtmztqFnuKoeJMvI2INVkZ22pHtNKdaSj2Qkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhxtS7sC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86235606A8AE;
	Fri, 13 Nov 2026 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhxtS7sC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A101F000C4;
	Fri, 13 Nov 2026 17:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591113;
	bh=RbEpgELqnuB90RFJWA+njewYgHOxsbzKGkAlGIw5Ii8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhxtS7sCrqtgi5c1SPMIcMaiX/ewTEmaPR2nzIFqYIbN/lwKMLE5xeBzgXMnFWPVm
	 MLFhbBJ7pCnp59EO7gk4NpW1bVOBjJxCMY/peYrsTijOtg23Ucp2ld7qQRyHdfPqNV
	 iHtLGGwbUqpz2fh/5oytRc9LSAPCA/lWJOlRB6tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/670] hwmon: chipcap2: fix off-by-one in command mode retry loop
Date: Fri, 13 Nov 2026 10:46:51 -0500
Message-ID: <20261113153820.208058349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 4c0e65a4ed665c416ccb1524c58a646a580e491f ]

i == CC2_CM_RETRIES can never be true inside the loop, since it
only runs while i < CC2_CM_RETRIES. Use CC2_CM_RETRIES - 1 so the
last failed retry breaks out immediately instead of doing a useless
disable + 80 ms power-cycle delay before the loop condition ends it
anyway.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-2-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 0c66a0af36528..148b2c27ee7ea 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -223,7 +223,7 @@ static int cc2_command_mode_start(struct cc2_data *data)
 				     2 * CC2_RESP_START_CM_US);
 		}
 		ret = cc2_read_command_status(data->client);
-		if (ret != -ETIMEDOUT || i == CC2_CM_RETRIES)
+		if (ret != -ETIMEDOUT || i == CC2_CM_RETRIES - 1)
 			break;
 
 		/* command window missed, prepare for a retry */
-- 
2.53.0



