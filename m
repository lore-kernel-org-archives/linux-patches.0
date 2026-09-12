Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB112931EE;
	Sat, 12 Sep 2026 15:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227309; cv=none; b=PJqOIMA16xWnTo1wcJw369FJVuiq1o0CgMW9Sj59vvJwGkdKijk82PxZKPPFfJPrdrwHu8L4b+8MouC9v8cYEeZgntBLDtC/DFBzY4adJcwAaHydpOwf0BY4kP1MBeF3VJf34SOfAdfQBKKr5QoHEbaf4r+kLjSHb5+1vJrhkGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227309; c=relaxed/simple;
	bh=3HKRRO8X9YOJtAFhNu5BygBLCWJhP9qtQu32XwTGHJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mh7AnoLsn89gSZqXufjy7D+nBR+cM2A9dYS8e2YW9Kg8GpmMrO89l5VAfoXFGVulqa8jE1wIa7fyVrJoAoWn70+2Aj0LlSMWz0cT9XKYmU0mvtngBy+CEnynn6eevh7hNwutueJxBRsQR/TV9a4CFwy5ZXQKbIttgkLvUlfjvTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSAMqEXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSAMqEXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2401F000FF;
	Sat, 12 Sep 2026 15:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227308;
	bh=ikWbHZrTaCn1ajMWu+BzA1O/eI1biS4PhWRo49zrZKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSAMqEXJdLh2JNbmNti1DlPg3n4jdFXnVVT0ZsGda5gjZZSffoRpVY9ktciJcRGos
	 ta/6tQj4j+zGny//csT5G2R3IT+3sDaWaI51D2CIHuithxlqO/jptboa5Ew+Ah9TaF
	 gnMs7l+FfSeckjxWSlsgR9NM6XZBIWvqAFk8QoZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 6.1 0147/1191] orangefs: fix double-free of trailer_buf on readdir copy failure
Date: Sat, 12 Sep 2026 08:47:55 +0200
Message-ID: <20260912065551.505174260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifei Gao <gyf161023@gmail.com>

commit f574296be7f46eb60beca851240b526df232f480 upstream.

On a readdir downcall, orangefs_devreq_write_iter() frees
op->downcall.trailer_buf with vfree() when copy_from_iter_full() fails,
but does not clear the pointer before goto Efault. The waiter in
do_readdir() is then woken with a negative status and frees the same
pointer again on its r < 0 path, causing a deterministic double-free.
A client holding /dev/pvfs2-req triggers it by sending a readdir
downcall whose declared trailer_size exceeds the bytes it supplies.

Clear the pointer after freeing so the readdir-side vfree() becomes a
no-op.

Fixes: 382f4581e67f ("orangefs: rewrite readdir to fix several bugs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/orangefs/devorangefs-req.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/orangefs/devorangefs-req.c
+++ b/fs/orangefs/devorangefs-req.c
@@ -474,6 +474,7 @@ static ssize_t orangefs_devreq_write_ite
 			         op->downcall.trailer_size, iter)) {
 		gossip_err("%s: failed to copy trailer.\n", __func__);
 		vfree(op->downcall.trailer_buf);
+		op->downcall.trailer_buf = NULL;
 		goto Efault;
 	}
 


