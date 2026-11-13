Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591571;
	b=kA/BFzsqovqwPPAACGHsH+CffnL6P6W/fMpVw7iX06O5d/2duS8u1qLy8RQOCWKVDILU
	 gsd8wVU0+N2PBGLiSw+x1IjCJBCyMVXatNv2QFBGVGBN1+kgtDXASKozdEaXXp9YFDngT
	 zR/0mzW/PBUgd8rVWft2LABoMdJ1zJ/ETpvjAodbUStPOWMVP7zEP6VXQlHwGocR/rxN0
	 5wxEHHFSsh3L9XVHYqzb+LNZVZUDpWDbfmURWHEK0vDz5wmsuObxcWgBBTbi37mD3Rkl/
	 Dja6JJI2OzjQPY475a7KThWdqRKhtVcWYI8p52XVNXUyA8/oj1657WlRPBbW9semrCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=STjG1OnFjwquqTf41y2AFlvwq0AsxrMKhOUjck2/HpA=;
	b=ckFTdbHW8118MyRmxzgqdVEv2gKoHkm/XMO3RKQeJ51/DlhGX4QQbfXspQfe94yvEqim
	 YyNslAUIaEHQi12sGS8Q3146M5OsKe1bPUntcObuPbylBd4rQ3rwa9Qmmb0KFObHisvuF
	 eGua5AEZe8YjDGikhY6MXwFMqPwHo1GQRerUYZbXDVstEt6Azy7/O2/ImQJQIlAdJshkM
	 gFATlBD1Jeg7NFnwv3dKOEYZ6ObLfeW032QCHNXV2v532EpLJJVvrUSEfV8r7yL6rKzfX
	 Wd1T/2uYyaDys6sB+HUO875G026NjQh7GT/Hn5gbD/ATaKXygCMsYjlLVJfxm7gJbFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IPcW9cKX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B26607E822;
	Fri, 13 Nov 2026 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IPcW9cKX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79DE1F000C5;
	Fri, 13 Nov 2026 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591571;
	bh=STjG1OnFjwquqTf41y2AFlvwq0AsxrMKhOUjck2/HpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IPcW9cKXaF+xBweDeOamnPuAKIOP27A/dGpq0FQUziB5Djy7DKM3ls8X0kJ6Bt4fx
	 Rp0Vc1MlkzRhFpwrlvi1JbDY66joz27h3dm5a0NjxbMHsFhy6eA9eYfutM3rWfzhPt
	 om3PUEKlDEoeKyt7cg/CKmUs3DQ1QsyJMEQFGTmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 621/670] iomap: dont mark unwritten parts of a folio uptodate
Date: Fri, 13 Nov 2026 10:53:05 -0500
Message-ID: <20261113153832.846918350@linuxfoundation.org>
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
[ sashal: adjusted __iomap_write_begin() context because IOMAP_F_ZERO_TAIL handling is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 02a5fc5105e7e..23457bdfc20d2 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -760,6 +760,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 		if (iomap_block_needs_zeroing(iter, block_start)) {
 			if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
 				return -EIO;
+			/* uptodate once copied, see __iomap_write_end() */
 			folio_zero_segments(folio, poff, from, to, poff + plen);
 		} else {
 			int status;
@@ -771,8 +772,8 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
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



