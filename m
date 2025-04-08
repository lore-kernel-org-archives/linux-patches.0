Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C86A26AA88;
	Tue,  8 Apr 2025 12:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114170; cv=none; b=KU2Q/0c7h5DSzu5OlpmBTsvF/vDhtYNyD8KG/JZdddN1TIrGD/PuzZGSKEHs8bm1OE4VI7YDUftOSe+lX0A2IMWxSZQrRW2I/0yN3F9CUJIWZHgHjERmRU5MA7virhoPCmntA/PD8IBi7tse+oX0wIjJ84xvVoBQugU298HxYRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114170; c=relaxed/simple;
	bh=wLq+Hl1TNDRxBoil+X0wrJs4pb9oK4aIGfA8mek6mN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFr7hXqxaEwPU+TzEAZsAzxAoZTmMMmPk6NTa/N3ocBb/I5vC22k0BwHNy3xqK+bIS4RoCdPW4nFdKKqANj3Lih1m8necgXMm2b5NSOuZ5ZHiZsQPW5G8K6Qjl4FS5O0r86h1lTeoO6sUgSicav1uPBRzcSMK9isSYst0jYqKVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9AIhCwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9AIhCwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1637C4CEE5;
	Tue,  8 Apr 2025 12:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114170;
	bh=wLq+Hl1TNDRxBoil+X0wrJs4pb9oK4aIGfA8mek6mN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9AIhCwJmVnGfm6vXGBWaH4a86gJR8/8vg04XzSefWDcO72qeyc0Ttj4yBL5IdvkI
	 3EuFTA48tnOOW3esvdR4ZXcQDBYK1tSUG5wF/A70q4LMZeFiIoKZSs3+KGCmNWKCRg
	 d6qUVuDx984ldwHpf73EeNCOdqIJSxayilmXPhns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+4e6e7e4279d046613bc5@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 5.4 153/154] jfs: fix slab-out-of-bounds read in ea_get()
Date: Tue,  8 Apr 2025 12:51:34 +0200
Message-ID: <20250408104820.194360930@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit fdf480da5837c23b146c4743c18de97202fcab37 upstream.

During the "size_check" label in ea_get(), the code checks if the extended
attribute list (xattr) size matches ea_size. If not, it logs
"ea_get: invalid extended attribute" and calls print_hex_dump().

Here, EALIST_SIZE(ea_buf->xattr) returns 4110417968, which exceeds
INT_MAX (2,147,483,647). Then ea_size is clamped:

	int size = clamp_t(int, ea_size, 0, EALIST_SIZE(ea_buf->xattr));

Although clamp_t aims to bound ea_size between 0 and 4110417968, the upper
limit is treated as an int, causing an overflow above 2^31 - 1. This leads
"size" to wrap around and become negative (-184549328).

The "size" is then passed to print_hex_dump() (called "len" in
print_hex_dump()), it is passed as type size_t (an unsigned
type), this is then stored inside a variable called
"int remaining", which is then assigned to "int linelen" which
is then passed to hex_dump_to_buffer(). In print_hex_dump()
the for loop, iterates through 0 to len-1, where len is
18446744073525002176, calling hex_dump_to_buffer()
on each iteration:

	for (i = 0; i < len; i += rowsize) {
		linelen = min(remaining, rowsize);
		remaining -= rowsize;

		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
				   linebuf, sizeof(linebuf), ascii);

		...
	}

The expected stopping condition (i < len) is effectively broken
since len is corrupted and very large. This eventually leads to
the "ptr+i" being passed to hex_dump_to_buffer() to get closer
to the end of the actual bounds of "ptr", eventually an out of
bounds access is done in hex_dump_to_buffer() in the following
for loop:

	for (j = 0; j < len; j++) {
			if (linebuflen < lx + 2)
				goto overflow2;
			ch = ptr[j];
		...
	}

To fix this we should validate "EALIST_SIZE(ea_buf->xattr)"
before it is utilised.

Reported-by: syzbot <syzbot+4e6e7e4279d046613bc5@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+4e6e7e4279d046613bc5@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=4e6e7e4279d046613bc5
Fixes: d9f9d96136cb ("jfs: xattr: check invalid xattr size more strictly")
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/xattr.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -559,11 +559,16 @@ static int ea_get(struct inode *inode, s
 
       size_check:
 	if (EALIST_SIZE(ea_buf->xattr) != ea_size) {
-		int size = clamp_t(int, ea_size, 0, EALIST_SIZE(ea_buf->xattr));
+		if (unlikely(EALIST_SIZE(ea_buf->xattr) > INT_MAX)) {
+			printk(KERN_ERR "ea_get: extended attribute size too large: %u > INT_MAX\n",
+			       EALIST_SIZE(ea_buf->xattr));
+		} else {
+			int size = clamp_t(int, ea_size, 0, EALIST_SIZE(ea_buf->xattr));
 
-		printk(KERN_ERR "ea_get: invalid extended attribute\n");
-		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1,
-				     ea_buf->xattr, size, 1);
+			printk(KERN_ERR "ea_get: invalid extended attribute\n");
+			print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1,
+				       ea_buf->xattr, size, 1);
+		}
 		ea_release(inode, ea_buf);
 		rc = -EIO;
 		goto clean_up;


