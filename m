Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038610;
	b=xVwS4ljqOY2rxOXSHA1JdW8QTtdzlsvicB3Q4xSLhcHRv8Mq1QoBH3Ho/AXJBAYGW5eo
	 5LDB2X3aO7kUGTRXIIrfMjzB+2aAB/j66fq7rbknGLw08UHmZ0YlUx4SiCSMWyYFI+M1k
	 yH//B+IunOekR0Nb9DnmOBoMhclrOuAClDZpliQtFOAu5DeaRPbavjEZZPK4UnoGZR3IL
	 2Z4TO9s3mLGhv6tye1B6GNmsUwM6yyC+0erUXCK4rA8PEwrQaRBZX/xolJYRp3KVos5+k
	 gI2Y8MVe2Vfw2MqHPN77JgoOk0HNuc8cLgrkJPiU1siB1DmFZQ/+qFrxkcW3FBX51yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VXMTl0dfZ+hIhU8y4qdp3QoKD5V9A8IACwN+Jp9RMHg=;
	b=32eGqONbBDrEmrK2gxtCQXl6JNl16ta/2n8V7AzjYbSrJxLglnkNzCHVFu8a8/eT/kGg
	 vjLFhzJnbTdyfFHY0aQgxzBE8NrbloGzOUZUZwBvOn5rlmwjVHJfSHaqn2vIPBsFEwzjk
	 6J6h9fkS9E7ybLD5WmYo/rzB/Z0bQGnMw97eLQdMttPMRVlI3A7MS5L8lyk1V5y7pVn97
	 b3oA0VL/0J27RK8sZoUj2SkCNIkm0bR3wlSuKgoEgWbAjxXm+5LenwCIY1JIpEjepNOLO
	 junCqU7Rlb6RuTwQKp+tpVfWJrcZV0i+fbOiYrCQYrItKTrAwhbIO+hnSG1ocmabWeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gs6l/Bdj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA8C606A320;
	Wed, 18 Nov 2026 21:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gs6l/Bdj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB181F000C4;
	Wed, 18 Nov 2026 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038609;
	bh=VXMTl0dfZ+hIhU8y4qdp3QoKD5V9A8IACwN+Jp9RMHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gs6l/BdjCOvVSiQbjhQrLHMo8A+zGBeNvBbGeWwaa3LN3j1S1OwKgbT2tn7X2WXPn
	 Yb9z2O+sXLx7v56fC4PvL/fDI5FT5xAKgFYDe/KpqFY3dujPLG/crUE79U+Z8IpOhr
	 8a8QaFPX6sgyXFKORpBUf/aJSUQEnyJ+tRXhlJs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1804/3318] iomap: dont mark unwritten parts of a folio uptodate
Date: Wed, 18 Nov 2026 15:40:26 +0100
Message-ID: <20261118150415.975094011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted __iomap_write_begin() context to place the uptodate call after the status check instead of IOMAP_F_ZERO_TAIL handling ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 549490acb229e..d74a8f38612ed 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -710,6 +710,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 		if (iomap_block_needs_zeroing(iter, block_start)) {
 			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
 				return -EIO;
+			/* uptodate once copied, see __iomap_write_end() */
 			folio_zero_segments(folio, poff, from, to, poff + plen);
 		} else {
 			int status;
@@ -721,8 +722,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 					poff, plen, srcmap);
 			if (status)
 				return status;
+			iomap_set_range_uptodate(folio, poff, plen);
 		}
-		iomap_set_range_uptodate(folio, poff, plen);
 	} while ((block_start += plen) < block_end);
 
 	return 0;
-- 
2.53.0



