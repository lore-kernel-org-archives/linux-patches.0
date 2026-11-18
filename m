Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054097;
	b=bIBZp4KMg+CmwiHh7G193QoISKRglO2z9WJaiLeQdvz7zpJJ9M4H8Yo51yiwwfJvg2Ea
	 ohKq6V4qYtlo+XQgJS1pg1y7E5RlKrYF4ikxZv9BuX2lCvxzstE9UVcpnpjuNS21N88vm
	 mdVOjyiQBZ7pDrKEejXSmaKYO3XgXQlLqYe5TiVSEWj6uzQ45UhUU+UYBRC3VAqKRdbbW
	 jmmWCG2JpQhN8t69P21E9JKWPhohu1HF8c79hAiswC7ru/zA+v9HFYpz/zZxl72kMmr6g
	 b7J/HFKeuJbd+PCz4Ile9UKO+ulJrUVD9qnDDsDTmO9kVO0KWFtJg2Ng+sNW0lsiRKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mz8fCXVKvGmRIV+nqTVasf5k4JQis8joOa8Pyjj8UbY=;
	b=y21n+mxMvTCNBidNLviMSqG3W+44xegc0FLw5syrrafzNNu2vC/daV7mJhDS9mruP3FG
	 7hAty+xW5h50lADAIn74Ff+wvQ5ZCKNqkaSad/kGjJKbb3MHxlREjWgmWzQnT5imYjsSb
	 ENwvJmRmBRah3W4UKxUGzMueUFV7sylIyQ1oELT4+SDFLIK19LS0zMl+k7go2E2/1ba5I
	 6s/2XMicr3wquUzRJkdCdaiPBhWIucAXBbQ16pZhhLGM6ufbLN2bRd+OU7TsIRezk9fdY
	 aMvKNujjHmlvF4E/1MQoGQOHET3ju8hZw7AOTYGtzsSEyYrp4Au1jUAgdC50TYBFKbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VpRZa/cE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05938606A320;
	Thu, 19 Nov 2026 02:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpRZa/cE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5770C1F000C4;
	Thu, 19 Nov 2026 02:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054096;
	bh=Mz8fCXVKvGmRIV+nqTVasf5k4JQis8joOa8Pyjj8UbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpRZa/cEJVHK3iifIt++DquIwbtAxWvSrkHnvDYxC+lC67jZLkNXK7bE3nd+RfnM5
	 S+2c3UebVyp/9cOPnHagxoiTm48KWmaKWQSJp+Ga8ONCcvYhyC8veK3wMZhkBXnxuj
	 EVPa939fA/xDFlXdw1QL6vq17qZf3JsqQLYv4H/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1151/2214] iomap: dont mark unwritten parts of a folio uptodate
Date: Wed, 18 Nov 2026 15:47:07 +0100
Message-ID: <20261118150058.036069523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: changed the iomap_set_range_uptodate() argument from folio to page ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 2d65616762ba9..6c7b3791c4953 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -579,14 +579,15 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 		if (iomap_block_needs_zeroing(iter, block_start)) {
 			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
 				return -EIO;
+			/* uptodate once copied, see __iomap_write_end() */
 			zero_user_segments(page, poff, from, to, poff + plen);
 		} else {
 			int status = iomap_read_page_sync(block_start, page,
 					poff, plen, srcmap);
 			if (status)
 				return status;
+			iomap_set_range_uptodate(page, poff, plen);
 		}
-		iomap_set_range_uptodate(page, poff, plen);
 	} while ((block_start += plen) < block_end);
 
 	return 0;
-- 
2.53.0



