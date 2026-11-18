Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047317;
	b=IHT1NftSF9Bw5VmR9SCtnIVyDROYzCU6L7Z0s6KyImaqZoyxcXjuc5UPNUvxJZrPUjRu
	 jTrgIKXYJg/pZUDtKswOcIrnxsBYC+hxcu+0LFnKjiq2bPFaKIh20Sp/9dmgVEU6O0mow
	 RP2DYjGBSlgowk15VIg0uggKyJVY90JijC51F2O/NvC7p7ZqaWNuuO0D1vt1gfy2Gc+6b
	 nJyop5ZqASPeStW0RA08y84EPWjHlXw5NN6cePtMnJmkvxNmGSAvHVxNPB0oaosKIlbmI
	 uqbkvoPejiv/qZGudM8SiYcrYeWC5sjYlADL5K7aTSYEycKMtkPg5nr3ea7eTTF3dyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6T5I4ErcuFGn6D/eocVWIIk30FbqWejOBw0qGaOj4ts=;
	b=F0C8e+Ar8PUQxpuBP22tUkOT9ZSPwNW9MdruO2hSwUh5/LQx/tDxdcUfR3wYZR3FPeMZ
	 4bmR+Q0+PL4hSC1e+Tm09wMmL9sExnzgoE2dllWwP9vFaX8zz6PewGvgvMwRVrWrsXcVm
	 8v7WuTDUT4j8kISc5GvJaq6ziXQdLTmmM/8om70DJYRtQEqijFgP0BQKX1+VP1M/z7/Io
	 qRU8/nZPI3ZDUADw5f/Ai0nGfpnigP+j1bMr2LJ5EBrI4ui9jp1YZf3bFJVoFi6KOx7Y0
	 VWu1n+MGKf6lIKEGF/bqEtQEWHx6onlwqc/Qwkb+9WGcYFC+HnQFuvoDvJgRJ+xBkig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXc9o+2i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218BB606A330;
	Thu, 19 Nov 2026 00:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXc9o+2i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE461F000C4;
	Thu, 19 Nov 2026 00:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047316;
	bh=6T5I4ErcuFGn6D/eocVWIIk30FbqWejOBw0qGaOj4ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXc9o+2iUZhao2gZNockn7hS2xryV6+3NJCSRPpiixIVEG9eGkD7xEH3rYc5Hyrh8
	 so0JjrJaDq/0+mhIoMiGZxWrUQJ2QJrza90UHxQPnF8WNH3NVnA35Xsyglgi9sUq4N
	 bCVVjJxGsbrHQEYUadNt0PLjuG5B/ZIob7RCtZh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1554/2857] iomap: dont mark unwritten parts of a folio uptodate
Date: Wed, 18 Nov 2026 15:43:08 +0100
Message-ID: <20261118150257.333112138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted iomap_set_range_uptodate() to include the required iop argument. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d0cfc4c3389c7..9b22279b5c685 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -560,6 +560,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 		if (iomap_block_needs_zeroing(iter, block_start)) {
 			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
 				return -EIO;
+			/* uptodate once copied, see __iomap_write_end() */
 			folio_zero_segments(folio, poff, from, to, poff + plen);
 		} else {
 			int status;
@@ -571,8 +572,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 					poff, plen, srcmap);
 			if (status)
 				return status;
+			iomap_set_range_uptodate(folio, iop, poff, plen);
 		}
-		iomap_set_range_uptodate(folio, iop, poff, plen);
 	} while ((block_start += plen) < block_end);
 
 	return 0;
-- 
2.53.0



