Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585342;
	b=BTDhNXYN7IjDTaNLwuaDsGV7pnIAFfsBYtwxO4YhmjagV75dmQKXmHskaeTNkMxsbotP
	 1b9Zrv8bmb38L3Kydyb41hbwrSTEfVdj7jig4+D8CI+FOYGEPWqN57HN6qFM6izk2cKoI
	 mhyNv4LfPUOZ+aMChvrkFFEKDcMguSZkHleb8ASL7tGQYYGeBrVTfsuyGFaCYJgwD9N9G
	 szFfciX1oh//Y7pIv4jcF/CV8cvFhmfnEF9ZpMiTZt2c5WQdc598W+hUddArA78Nxivxv
	 OC8sY7Snz6U180e1bECwW0i5byC2N+9zxdat1gu5qwUUgBwPaW5yE0xn20I+bukmAwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cO8FEgYmy8umALWsg3yRNHuS30cbh5pbX+PpRdqaroE=;
	b=0SC7GXOaxbD3SBPko+o9sAatNSR2B9N2s61sq6YwJk2gkovDZHHRrQQ/n4GfJxsojF8R
	 Vxc4Fy4KBb1inV3jD+J9hQ76VlHZ815uwXQTJ816o9zXW4AjRqDM51fzwCN3BAFtX2ABA
	 WDa6k3PbvLFjy8Ybyw2pY0O7QRogbzThDkXEYqvj6P9AxJQnbuaSrbq0ZdcwsBO/sR59Y
	 /xzhvzi4642K1YEH1HLOZ0lwntjRfc+NjjarcQAQhds1ZCmOTuxl0klyLu/lI71pbudJq
	 mP6FUaPIyCMtvCPKIF5YMVpUEVUeg/41LUj3Ok3Oq6UnSgIqMmfsb9ZwAk/OofLG8xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bjMgXNdm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3216660A2638;
	Fri, 13 Nov 2026 15:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bjMgXNdm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28B41F000D3;
	Fri, 13 Nov 2026 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585342;
	bh=cO8FEgYmy8umALWsg3yRNHuS30cbh5pbX+PpRdqaroE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjMgXNdmKeghO2aDKgk3vTN0kkO02FljVsi+WiLzj2RN3fpbDCgMev8/4n1QdX6hT
	 NGpep7A/fygLStwOw0NNjhpvV73HiTlp8/aLkBsJJfTl1MnP1D6tET5UyUW9PpHxqa
	 jJtJtFuZbPiPlCN3QfyHKu18JutZvAkp+oXYK+hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang En Sim <sim@shangen.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 026/507] io_uring/cancel: count all requests that a CANCEL_ALL cancels
Date: Fri, 13 Nov 2026 10:45:30 -0500
Message-ID: <20261113153754.263460437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Shang En Sim <sim@shangen.org>

Commit 21ddbb14f7c3baab50a2a6c13ee375edc2bbe031 upstream.

With IORING_ASYNC_CANCEL_ALL, __io_async_cancel() counts one for each
io_try_cancel() call that cancels something. io_futex_cancel() and
io_waitid_cancel() cancel every match in one call and return how many,
so four futex waits cancelled with CANCEL_ALL give a result of 1.

Add the number that they return.

Cc: stable@vger.kernel.org
Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Signed-off-by: Shang En Sim <sim@shangen.org>
Link: https://patch.msgid.link/20261030050319.1448530-2-sim@shangen.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index c7ed51377dea2..a34543cb423cd 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -198,7 +198,8 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 			break;
 		if (!all)
 			return ret;
-		nr++;
+		/* futex and waitid return how many they cancelled */
+		nr += max(ret, 1);
 	} while (1);
 
 	/* slow path, try all io-wq's */
-- 
2.53.0



