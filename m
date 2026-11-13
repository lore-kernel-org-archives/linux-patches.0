Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590875;
	b=ExI379RbtmJktuEaXXzKOSjfn30t9RwgloHQdDDcOihjhEgo9MW/xSCikJaorT9M9qxT
	 n+Ffu8tTVMLom0vXJyIVqFrHwlTDMbe80g8aux4wfe9J8SOI1GTlxPtjRHP7af8LPHA1y
	 GPAqe5YWBhpITkKKtqVeyiQy9vFQF8wG/R6adD5+VOR5dMwCcKHLc4xDO/+VImsFnFn/Q
	 2YEXtpe0SrdutmoNdMD4XsT2i1WxF9JOccBdaeMWcwI0K5q74oOmHJJBl4/aJ6oUxLiht
	 LyVM9rEXZoGKZkNJ3Gtk2zV0FCk24kX8FbzNOOxQ3IwjSYGRSIlHVEktbOAkyLFGFgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C2MEVn2qB4Ms0sZJLDIivlve9diqJey1LwGIdLQq6CU=;
	b=tcLagUPBqq6b1ohGrhvnn2S1WHqEgS59BkUrPrgppnl/jT3eg9RnCn4m6qJBQCYeGOyU
	 nULflDR17DEePRIc+J0VOIlJQVPIl77+mbQ1NQIRbrWIc5uqRy8E4VVULLt3gQYVM+P5X
	 i/sEs/9+PGMFVwIaDtdDkkQWiMxQCj4ogqLst/zo44fVRNf3Ty8mjRIjvyZb9NZB2C3aM
	 LydBQhcjhw0XTuKz9Ks8E52z4uO/Xxq2w4pBHh5dimFkrWp48XZmkFSFCtVjmqg5SLzyf
	 OKiss+qJstbDiETXzQXyVVgN/DEg//b0aENgIGiRT+S/PooLvHQSQkkALJuXATj7ESA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XLfsSglY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A13606D4B6;
	Fri, 13 Nov 2026 17:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XLfsSglY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FCF1F000C4;
	Fri, 13 Nov 2026 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590875;
	bh=C2MEVn2qB4Ms0sZJLDIivlve9diqJey1LwGIdLQq6CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLfsSglYXhOqmvzF0T828dxEsPkQ46s1Fovp2VMI5E30MlJaomUl367FGG2/FTrPx
	 YSbvd76EBe3H7bh6ECUXRqXcAqHVibDqAFApHL+xmS8D6tocNUDMCQXr7wxiUUoHiF
	 s9S0+MVBZ9TR0J54Xl4FRI/W4tKRXdAzFhcI9pTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang En Sim <sim@shangen.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/670] io_uring/cancel: count all requests that a CANCEL_ALL cancels
Date: Fri, 13 Nov 2026 10:43:38 -0500
Message-ID: <20261113153813.291177861@linuxfoundation.org>
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
index 13d5d4f2924f8..16dd8af6ac981 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -189,7 +189,8 @@ static int __io_async_cancel(struct io_cancel_data *cd,
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



