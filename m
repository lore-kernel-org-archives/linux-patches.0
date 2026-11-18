Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027756;
	b=Kq46T85IFNBx95WAHkaohGYuZLz7+nZuvEsVqV2Fk76RarOb3JIDCKEh7Ssnvn7LYpGx
	 iEHBqT7huCR7R42HIz/kyhfbamuJpe0pCJ79cnUCz9Rr1ssxzIeVZYU+YGd+BUqHDTcY8
	 UkrnowvmEFbwfXWMzxkwQQrQWYgoLzjSZKW/iATOZfsLvwlp3bjw/QKD49Hd6waHCY2/U
	 yuNIDnrXc+4Dei8VVRIWtVudlcUK+GlgH0NnZD/TWCvSetDQCnHvGbYsWqBLfXdRrkXci
	 +jK7vhEcZb/M5fRPbYw4ZjAE8HSxYB58tSwkRn9CWaLnDJpF0zRf+AlDGgk3FO9YtdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TBb5BLgqBiK3jRZp3gRqglHB5U8g8oZr9CrhO+JHsOU=;
	b=eQM2hkxJC/7/J1o2X4Xe1BGa1h46BduWRShpn6ydISPfT4Ls2Qi0Sjv6SDIXNRRVmp/l
	 FMFD9SBh/RyxUIFypE5/rXd27g82Z9jayj5/rnfPqbxLok1tTylSntl2iulA9DXq50I7D
	 n0nMo3zBBZc48xRg5d816QvcROyDgON7naZqhHfJ7vdeRVqxyr3rz6tuZabmeYUH7wpy7
	 KsChk1WX3NB7ImqnUBnSmqo2z2d3zgT5MJU6HRXAsNeIPDxHV6arfcetUF7pOReCNjHVA
	 SPV3nQEhOcTEY8OHtw1lY8fuQHenlDXR6lPRsPcxcYVUqpEas2SW6sfwSzJY/iDZfoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S8x+hJ7A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EEC606A31C;
	Wed, 18 Nov 2026 18:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S8x+hJ7A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614A21F000C6;
	Wed, 18 Nov 2026 18:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027755;
	bh=TBb5BLgqBiK3jRZp3gRqglHB5U8g8oZr9CrhO+JHsOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8x+hJ7AFlNUSMDs/vFIpj1KPV5yr77XE0jA7l6Tiq6mei8Ap10uhg0F9fgjvuyMD
	 PSK+yhmsVt94EXzdNIns+ACe7JneUS3Rxpkehsf/RekOkMKxmb9ORBEayUsQA1N/tE
	 bFTcF90+oeiWm5EmaHhau1hMuLE04MwbrideQh/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Omar Sandoval <osandov@osandov.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1901/2151] proc/kcore: advance the vmalloc retry by the last copy, not the total
Date: Wed, 18 Nov 2026 16:00:36 +0100
Message-ID: <20261118150231.042916278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 88c3f9d6145204cfd88e5d9cbc9463ffd892e10a ]

A readv() or preadv() of /proc/kcore fails with EFAULT, although every
byte of the destination is writable, when the page of a later iovec is
not present at the moment the copy of a KCORE_VMALLOC chunk is retried:
swapped out, migrated by compaction or NUMA balancing, write-protected
by KSM, or unmapped by MADV_DONTNEED from another thread. Only root can
read /proc/kcore, and the read must use more than one iovec. On an
x86_64 defconfig kernel (v7.3-rc7) a preadv() of one vmalloc page into
two 2 KiB iovecs on separate pages, with a second thread repeatedly
unmapping the second page, failed 77701 of 200000 calls with EFAULT;
with the fix all 200000 succeed. Affected since v6.4.

read_kcore_iter() copies a KCORE_VMALLOC chunk with vread_iter(), which
writes to the user buffer with page faults disabled and stops at the
first iovec whose page is absent, after the earlier iovecs were
written; the loop then faults the rest of the buffer in and calls
vread_iter() again for what is left. It keeps the running total in
`read` and advances the source address and the remaining length by that
total:

	read += vread_iter(iter, src, left);
	if (read == tsz)
		break;
	src += read;
	left -= read;

In the reproducer the first call copies the 2048 bytes of the first
iovec and stops at the second: read is 2048, and src and left move by
2048, which is right. The page that fault_in_iov_iter_writeable() then
faults in is unmapped again before the second call, which copies 0
bytes: read is still 2048, but src moves by another 2048 to the end of
the chunk and left drops to 0. The third call has nothing to copy, src
moves by 2048 once more, left wraps around, and
fault_in_iov_iter_writeable() fails on that length, so the read returns
-EFAULT. When both short copies are non-zero (three or more iovecs) the
extra call also copies bytes from the wrong offset of the page into the
buffer before the failure. A single iovec is not affected: its nofault
copy is all or nothing, so a short copy is always empty and the advance
by the total is still the advance by the last copy.

Keep the return value of each vread_iter() call and advance src and
left by that; `read` stays the running total compared with tsz.

Found while formally verifying vread_iter() against the kernel binary.

Fixes: 4c91c07c93bb ("mm: vmalloc: convert vread() to vread_iter()")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261017034739.793431-1-nickolai@csail.mit.edu
Reviewed-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/kcore.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 728630b10fdff..2df121e9ad565 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -531,12 +531,14 @@ static ssize_t read_kcore_iter(struct kiocb *iocb, struct iov_iter *iter)
 			 * again until we are done.
 			 */
 			while (true) {
-				read += vread_iter(iter, src, left);
+				size_t n = vread_iter(iter, src, left);
+
+				read += n;
 				if (read == tsz)
 					break;
 
-				src += read;
-				left -= read;
+				src += n;
+				left -= n;
 
 				if (fault_in_iov_iter_writeable(iter, left)) {
 					ret = -EFAULT;
-- 
2.53.0



