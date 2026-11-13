Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590803;
	b=rMUgRGk4fF4EYfKZI2XutHp8Q1Sc7BmGW2TZXsUw+rQX1iW/tNiYJCkCwFjTTaciOmD1
	 XhH+UTwjAeCdUUxrnASN1JCTUaswXqmxK3W0W5fY+1vb4InkrDruj/5XblrLXKq17btnf
	 6rjP2sEWnVDjvKn6/EMj/HqufGzb5JfvQdpO/daWLRhB4VJ5tHj8j5wwwRev2O76uNSYW
	 5ITGF/Lw99FcaCtD6wkxOpLXiSat0tHcbFITVt0nYhb186ieQCuXK0+NV5l8Hd8tUu2sz
	 /IreV7/HJvlUwz6hn4cKSyoxhieSh3IabFa3UF3q+yCLC1qjgE04FcD1hZJCblTiftg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HpACdLPYj9PuFPt/CcFz5OGPecuBQ9FkNnRS/NoV/hs=;
	b=FrgmeJYkqNwkKrN172d85dIFxPNz9DlU6eMsLGa43v6muIzCrbz6+O738DaigHYga+c3
	 g1cRv0jii7H9b2FcLVIBXHRYQAJzNr1oTrq2JcCUjmxUQYhgZuFyIb0Db09yhY2MVtBrw
	 FoPeMVumlf3LDJYQYuaEQ369/y431hSjOiloAa7MvTY/PcDHMB0qnPMFNj6MC5p72JgSb
	 ov4J6KkP/+esUfddg2V4X35Wog2xIxEBelKgGQtY0Tl1KXJWdfBuTbu/BPNxg4coeHFAB
	 YCvYtbu4h3E/eW/73A7AwNpuub1OFPpidSHiu0kh6vfpGzsWPKT9eIhgQQh7c3mUKpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1P1V7rq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51FB607D2F6;
	Fri, 13 Nov 2026 17:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1P1V7rq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EEE1F000C4;
	Fri, 13 Nov 2026 17:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590803;
	bh=HpACdLPYj9PuFPt/CcFz5OGPecuBQ9FkNnRS/NoV/hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1P1V7rqXHsBw/GTYM8FxQ1LYcGkb7FXYTozuiFyyZDrFGf79x86Potq2isAsRlcG
	 TxwgsgzH7GLL6AQVyAiLa/5vMCVLWqnaxaTIXbFZiWrTyzcP8qTY7l/07wAGuwgv3r
	 4Jic6u2ABu6hw4Haprc8HFIb9Aa91cFbBdTyRK94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 645/686] iomap: dont mark unwritten parts of a folio uptodate
Date: Fri, 13 Nov 2026 10:52:58 -0500
Message-ID: <20261113153843.637742220@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit a4193b4af359db84b2cdf3a040752861984c636b ]

For a buffered write into a hole, an unwritten or new extent, or past
EOF __iomap_write_begin() zeroes the parts of the blocks outside of the
write and then marks the blocks uptodate. That includes the range of the
write itself which still holds whatever was in the folio before. It only
becomes valid once the copy from userspace has filled it in.

But the copy can come up short and __iomap_write_end() only rejects a
short copy if the folio isn't uptodate. If the zeroed blocks were all
that was missing the folio is uptodate by then, the short copy is
accepted, and the rest of the range is exposed to readers and can end up
on disk. A source buffer that ends in an unmapped page is enough:

        ftruncate(fd, 4096);
        pwrite(fd, p, 3000, 100);    /* 16 bytes at p, then PROT_NONE */
        pread(fd, buf, 4096, 0);

The write returns 16 and the read returns 2984 bytes of whatever was in
that page before. If other blocks of the folio aren't uptodate the short
copy is rejected but the zeroed blocks keep their uptodate bits and the
retry with the copied length leaves the same bytes behind.

Only mark blocks uptodate in __iomap_write_begin() after reading them.
__iomap_write_end() marks the zeroed blocks uptodate once the copy has
succeeded and rejects a short copy.

Willy reported this back in 2024 (cf. [1]) and Zhang Yi posted the same
fix (cf. [2]) but it never got merged.

[1]: https://lore.kernel.org/all/ZqsN5ouQTEc1KAzV@casper.infradead.org
[2]: https://lore.kernel.org/all/20240812121159.3775074-6-yi.zhang@huaweicloud.com

Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
Reported-by: Josef Bacik <josef@toxicpanda.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261029-work-iomap-ai-fixes-v1-1-7eda63bc1b13@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: placed iomap_set_range_uptodate() after the read-error check because IOMAP_F_ZERO_TAIL handling is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index c9ece378687b9..cbd729ef50ab7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -766,6 +766,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
 		if (iomap_block_needs_zeroing(iter, block_start)) {
 			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
 				return -EIO;
+			/* uptodate once copied, see __iomap_write_end() */
 			folio_zero_segments(folio, poff, from, to, poff + plen);
 		} else {
 			int status;
@@ -781,8 +782,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
 						folio, block_start, plen);
 			if (status)
 				return status;
+			iomap_set_range_uptodate(folio, poff, plen);
 		}
-		iomap_set_range_uptodate(folio, poff, plen);
 	} while ((block_start += plen) < block_end);
 
 	return 0;
-- 
2.53.0



