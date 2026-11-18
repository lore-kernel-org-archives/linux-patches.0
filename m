Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021567;
	b=P+ROvHWGXjeUjmoYTps7tYWOtetOYACOmnzqfkx8BZBvZl6YKvaq80varwmMICitu6Lb
	 Cn7vjJAHN6BrZO1Faaag1Z683M+74AyDw9oB5+CPehnKlNz4w7MU0ClKm0XYwyAhCc/HC
	 dgDMhpd6Dtd2DZ4XIXJT7ecaK/6TVexq1UhFhGy/Gezuk3n4MCnMkPZO5smqe84wwwvAq
	 TCQbG+oJlzMHtxNtODweftS3rO1ytVnd45qHKqJLOH3DMv8y9CymXcOBQC+TR7sie5Ksl
	 h/HPtfgtPAPChLGkFPuj06/xBV65VXOdwA7QEeQST4ihhyP6ae2K3QYqYom4voNFqiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sCMMsMdoiqJy0jUDtG9ITrCx/sUrt46GpVFkjT3B3Sk=;
	b=pxHJv8KJ/2RuqvsxiCu4n9f0JoIZE+DNxkuDPlGkGwcAKDttAXr3sHcebpl8LZ/jdR7M
	 qebiPIgcSlLFcAo4TZvSBk1H1ClachJZfRPJDslVJL/zcPkOacGBGj9wjMJLDllsEhjFg
	 4xj0KavXcyF388s5LjbOlU3zaDEu96vgFjWlN3CxB/7d2MVo7oHCzhH70ejfx32gCW2Xk
	 4fF5z/aTzLe4eOrL2fIruBeRxnvg5YNrTB9vRuXqUTkm2USAvqmHu+CTiMMaiwowe6Vf8
	 XxT1HtAlf/zC24VVV6lzuO/aHiRgGL9NDtL/E1Rgsd4A5M8EipVc7oM460M+zcEHYag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IfNmps6J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBFC606A31C;
	Wed, 18 Nov 2026 17:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IfNmps6J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6021F000C6;
	Wed, 18 Nov 2026 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021567;
	bh=sCMMsMdoiqJy0jUDtG9ITrCx/sUrt46GpVFkjT3B3Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IfNmps6JmjwMOsXLwxJuxeJUoQqBem/FMilkAPWPyoWZi7MGmxlis3tB2WPMRPFtg
	 8/91pepiHvuSGbwIBImoD+Vcrf7hViKWorAUcL8GfAsno+8+n+L5Wsl9ZwfUAxvWOv
	 LzZ084im2kNihG6jfCZmGmCFqavC/8cu39XQD074=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Omar Sandoval <osandov@osandov.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2352/2651] proc/kcore: advance the vmalloc retry by the last copy, not the total
Date: Wed, 18 Nov 2026 15:59:52 +0100
Message-ID: <20261118150409.726519281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 390547b992acd..3264c99bd68ac 100644
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



