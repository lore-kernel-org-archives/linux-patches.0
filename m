Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15435321445;
	Sat, 17 Oct 2026 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258167; cv=none; b=XCxqORMrJHOnSqisog6U5fckFSfxJg8J7y3smXnW8PCCncCwgv7NiqDWoWX9Vr25XvoPNqFJLd0zi52UxiMMPEJgofD22vKOLuDku87VoDk8xL3Y7utUUp4HjrQXmdvXasCuzABxSDXLx9iNHw6rNwGrrFXLzLtCapsL3gztWto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258167; c=relaxed/simple;
	bh=ovR68K2trJ8Q1iqR5fyPiRuxZ+avkG9OqUo1/4+0Crc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDKvIM8QU0iH6NtN0o4TjUJSu4zcuBroSOtmlMEQSlDG67H/wiYetsVBd+Po81hr2PpdHhyBMCuk5jO0hIbOI/U5XWdzARxlbaZEdUZdobDMlbhwk/XpbwzcnP4DNujNZlJl08IL8j4xYWWkhmZoFoHO37bzjiVS0xWxUwQKobk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNgY2hAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNgY2hAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2AE1F000C4;
	Sat, 17 Oct 2026 17:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258165;
	bh=4gI/tK+uk7l6s5dmgpL1gc2QwiOECsUTKMaRyYYj5ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNgY2hAyJ0lwlHFGKo3/8YY1RcHQgNhZy+Su/JyFkOEtxBzxAywsdDbpALfViRSce
	 ZeHfqZO53oGMuom1ASuN08s/p+vsysk/vCbyENA5O11ur4kLCwlNlNWNvXXvO+1w5y
	 Y+rICd1sK7Zw7S8+CD+ercUpzEKC+pLyjvvwGxoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0792/1674] dm-stripe: fix a possible integer overflow
Date: Sat, 17 Oct 2026 17:51:04 +0200
Message-ID: <20261017160451.435621544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 1071d560afb4c245c2076494226df47db5a35708 ]

There's a possible integer overflow in stripe_io_hints if we have too
large chunk size. Test if the overflow happened, and if it did, don't set
limits->io_min and limits->io_opt;

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Suggested-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-stripe.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index aad50e9fe9958..11d8ff3c45635 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -456,11 +456,15 @@ static void stripe_io_hints(struct dm_target *ti,
 			    struct queue_limits *limits)
 {
 	struct stripe_c *sc = ti->private;
-	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
+	unsigned int io_min, io_opt;
 
 	limits->chunk_sectors = sc->chunk_size;
-	limits->io_min = chunk_size;
-	limits->io_opt = chunk_size * sc->stripes;
+
+	if (!check_shl_overflow(sc->chunk_size, SECTOR_SHIFT, &io_min) &&
+	    !check_mul_overflow(io_min, sc->stripes, &io_opt)) {
+		limits->io_min = io_min;
+		limits->io_opt = io_opt;
+	}
 }
 
 static struct target_type stripe_target = {
-- 
2.53.0



