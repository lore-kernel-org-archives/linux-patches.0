Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590025;
	b=0+8QGgZcPEmzuyGM8vqiRQKvAGDl6apD/4EWTSdyvVoBu60TFhIvvKc0ox0JiagNU9Ge
	 jgge6nR2Fq4ZWqMRd61aI1BoWw9RwCHUtg3qiR089Pk8jVSefv6sneHaoN38rOUNBkE9M
	 Ft6SNQyPcI40kncmxsnFcVTCtLORprU6wd5KvK0cSZ/QUJdiN7LX+2GjV/w3VSWHUmN4s
	 f1Ay+ts5kZvGzJiLeGPtim+yvUThwacQzTC4dlwe31TRJvKjD0Q+huBMjOgGe9UEuUGrB
	 yncPoivnaUMbmQmtNDapl2CeLpGELarQiXYT3vQZQqHyMhK6GGgRWp4OLi6hw4X7MwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cjD2gquWILre0T5da0+IPL8bj3ELKFY4W8LruqXDVzA=;
	b=PTXsEUDFJ9u4pkptZ7jDMqFpWD2Z9GZ+bzOH1xKmquBxOPog3ylkNRlaEV+ErXauPESU
	 /rSUrazxULuRXvzvRLmh7Rc+jHD38a2OfGcPZCNO8C8CTWXw067cfSGbfLlchRhDEtkHS
	 Qhrc24h25/xV/kxtsRUKJ6dxVIpxwU46n8DCqDZWEnt4pYACs/E5XOZs86tBsBqxw6/Rt
	 QNW4XGR0dlgwq/oh1quY84vCBy/pO5fT+E5XvqXIqH8m0xYlNfYXznL7TOrDg7uRU+/a4
	 GiDtLQ2tfwKs+7PMHkMXS09Fp2cLFNKXtXtPgRXMgxTI0auP3V3votN2uqYhuOCnujg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BucX+u+x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6E4606A32E;
	Fri, 13 Nov 2026 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BucX+u+x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F0E1F000C4;
	Fri, 13 Nov 2026 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590024;
	bh=cjD2gquWILre0T5da0+IPL8bj3ELKFY4W8LruqXDVzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BucX+u+xO9AkAX8m3d2M+O6BCK2EjPJJMTckTDFrVb5IKAgjywre+wSx8GHt6eZHT
	 jszfj1lkUImPbTTbZ9gtp7sJxs3MmhPkAaGncE2DIzTZM+gVq68brAa/WdNhUpDBJA
	 Iye+IXILzWFvc3KF3lFEDoH45fXZGXAm+xXuwbaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang En Sim <sim@shangen.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/686] io_uring/cancel: count all requests that a CANCEL_ALL cancels
Date: Fri, 13 Nov 2026 10:43:17 -0500
Message-ID: <20261113153823.104162152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 44d8b7b25267e..1db26c66e45c6 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -192,7 +192,8 @@ static int __io_async_cancel(struct io_cancel_data *cd,
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



