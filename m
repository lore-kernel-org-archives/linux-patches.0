Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623421;
	b=kuV5QmmBdMJ8I7T5aIyXJCwu42HYsvEUZbuqIZaW0097MyibHeEmC0Xrl5HjwCrcNw4a
	 P6lzUTX47It031WrkS/saV+ZfX72F7yDfqHmEfEj44yU70kFOP4OO7Tiy/VU2DMObGsgG
	 ctSdeaV+dK2lophWE9dg62aqbQUh++oEiM4nrvRhqWb5z1U6a7Giq/1G1xMtMBpsqDegr
	 Eg+CAmwhCJEoHAcgwgTKtqcnVNTYbuPFNRtopwB27UoaeP6404jM3ulP4oDGvI0AQa+0A
	 NlNNC187Hg1a7DLfLMFLCTJyNqbC3yM/2XhBiauIw9nCBp3C7Zh0eL5bNI6Cq+m9Acw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Upjz++x9C/G70B/zthn1Gcp66hwafS72xIM3KB3+LsU=;
	b=zv5b+qcyGuBrMu5AxkcWRASOdvhRYM8bpNoaQQEqLpJ9r8tsG8tVwM2Prfn6lfutBmDc
	 iJgbYqTcLfsstUiCbDfVDWqEbc3+BhqMd95jvUfvU7HsxPeRyQD7O63je4EnCKs9USU/I
	 N8bu68dVEtvSqhH8dASZabvVSJPigUhwnnTD+NmVAC9TtzHEFOFq9MyPi788LjCuVWc1Z
	 ASHqfroOhC3o+aYiT3Hu0tqsc+6Titz3Gyri07xyhVw3zBdkLNkxdGDLEXEjW0YBRT95J
	 t3CY37i8IFWEAQHVnDQXXJ811bTMlfVtgG8WNvZXhCUg2FwI/fXR/rVXz5HmdRwFRRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYViiwd8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7D9606A321;
	Wed, 25 Nov 2026 16:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYViiwd8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14B11F000C0;
	Wed, 25 Nov 2026 16:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623421;
	bh=Upjz++x9C/G70B/zthn1Gcp66hwafS72xIM3KB3+LsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYViiwd80litiR3C5c9PnX35IFFiG/Fw66srKWY0pX0Q9huJOlNIrqTFzgccWNvW4
	 JoXgwgPm7WFQh9FaT100YYKxQYeChhpledEh6eUXyFY2mCMQg1K2pFJsWwaNw8h0eL
	 CNzlitz0WEzGglB0qLcY4zUx1J6gbYhV6+egctG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a2626a25eb2595e3ec3c@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@sina.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 854/990] dm cache: reject kcopyd client destory if it setup failed
Date: Wed, 25 Nov 2026 15:37:01 +0100
Message-ID: <20261125143842.032387620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@sina.com>

commit 8b97b168eb4d3affcf23d2980a0c3f35ed9262e2 upstream.

The value of cache->copier is -EINTR when failed to create a rescuer
kthread for wq kcopyd, in cache_create(), the code jumps directly to
__destroy(cache), it merely performs a simple check to see whether copier
is NULL, potentially hitting:

BUG: KASAN: null-ptr-deref in dm_kcopyd_client_destroy+0xae/0x480 drivers/md/dm-kcopyd.c:980
Read of size 4 at addr 0000000000000174 by task syz.2.19/6560
Call Trace:
 dm_kcopyd_client_destroy+0xae/0x480 drivers/md/dm-kcopyd.c:980
 __destroy+0x172/0x2f0 drivers/md/dm-cache-target.c:1973
 cache_create drivers/md/dm-cache-target.c:2604 [inline]
 cache_ctr+0x1674/0x2bf0 drivers/md/dm-cache-target.c:2649
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]

Set copier to NULL to avoid destroying a invalid kcopy client.

Cc: stable@vger.kernel.org
Fixes: c6b4fcbad044 ("dm: add cache target")
Reported-by: syzbot+a2626a25eb2595e3ec3c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a2626a25eb2595e3ec3c
Signed-off-by: Edward Adam Davis <eadavis@sina.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2550,6 +2550,7 @@ static int cache_create(struct cache_arg
 	if (IS_ERR(cache->copier)) {
 		*error = "could not create kcopyd client";
 		r = PTR_ERR(cache->copier);
+		cache->copier = NULL;
 		goto bad;
 	}
 


