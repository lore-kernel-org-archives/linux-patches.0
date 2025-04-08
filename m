Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DC826A1B6;
	Tue,  8 Apr 2025 11:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110246; cv=none; b=bFxyhPZ6YT7Xv0vqUQdd+9p5dDZptRXuY1HsUPUO4fPaQbJzRJujX0Sk+omDGAoGVakVziltrJ5zlh0So+g61Xg1Elgy6VKqHi2WMUDWE4cKf7ZzDHfp33u5DF/SDb0gjUCstsVj2FW2Onm1ZYQiB2B8bzwFyP6HtFttUbTwVHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110246; c=relaxed/simple;
	bh=FQ3mCA/RBGYgyRD98kHdHdUxvsbTB1ma/vljgj00IdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrDJFitjiovyoEJeNBrR8x4N4KF72tkXVK11ruKGPnzlJ4kVfzQoVPfm7BY1NelYBuwsw+G9vjvqTJyqSmU+NrhPZweCGcbwYq0nqVQoYk+5n9RaM8sT1utVeSahJJ/FqZonl1JU1ZlSIRs1+aRbdTC1lRr2EFU90sY74vi7btA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITw1O0RY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITw1O0RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB35CC4CEE5;
	Tue,  8 Apr 2025 11:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110246;
	bh=FQ3mCA/RBGYgyRD98kHdHdUxvsbTB1ma/vljgj00IdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITw1O0RYOd0UudFJE5fawSkLV3xLEjxRy0JaFQ0uHG95sj0fEoBBjETroHppUwMim
	 VGqskOHZ5G4pKtrQp/gmLQdohjh19w3GVhRbAlBZSbk15/jrEF+kPI58SQZ6NJVNlb
	 9hk0neb0AFIIZv3lRFpf8iO8g4wjTDllkkCzFfdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+4e6e7e4279d046613bc5@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 5.10 222/227] jfs: fix slab-out-of-bounds read in ea_get()
Date: Tue,  8 Apr 2025 12:50:00 +0200
Message-ID: <20250408104826.951931166@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


