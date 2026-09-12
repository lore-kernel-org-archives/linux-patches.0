Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B12418A5B;
	Sat, 12 Sep 2026 15:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226921; cv=none; b=KgIiQrtlBoHS+S7Z2eebs4G76eyhoYbQciGwsGnesh2mD4oKVm3u/EQFpcmao1yRKLb+2dc9VlKlTgbV7iW+/h9zPOwq3piXtwZzm82eLhOkTG29tmIMJSE+Wde13fCKWOj5uM5HA8OPn8VVnbObLcSA5j5psGWU/vm2X69t9lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226921; c=relaxed/simple;
	bh=Ig+iQT6J3gNcFeJUIgOh2TAuL48+N1+H0GmgQKHTR7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7U1tLw3pyU5Chj25zDfw58jrWawnLV3npgP812T6fOrybRzSXPnB06p50yoHZ4IT61QXFAwBH3nZFJSITgpwMagTI+SOy012BnqB1W+z+yqY7GCnRpTW8hTkE54jhxsPIfZ334O1xyzoEwW67eUtPHKaf+3lQoshwawR6iboos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fn09v+Fg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fn09v+Fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E1C1F000FF;
	Sat, 12 Sep 2026 15:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226919;
	bh=lgK5X5Qn8fBIJF1+xHrwa5CCG6FaehvW/9053jXd4EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fn09v+Fg98nbLUvNSM1qumlNKgUAU38jJT9dKUDloR9ExdhzuH13/qvMz/WGAYhPX
	 h1LxDZlJyPKHoAWgVXmfYkvWek0LeE3nxNCn8aIojjpQyjd3nPkn4JdfNsfridt2Lb
	 iVAl3VVWDL8KdCF+aeYD5sE9WEmgRmkr4jHgwVks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 0075/1191] fs/ntfs3: fix info-leak on partial LZNT decompress in ni_read_frame()
Date: Sat, 12 Sep 2026 08:46:43 +0200
Message-ID: <20260912065549.849390782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Page <sam@bynar.io>

commit 35d1ea92c7d946e2ebdbe36cdb2c969c8704bebd upstream.

ni_read_frame() decompresses an LZNT $DATA frame into the vmapped target
pages and then trusts decompress_lznt()'s return value:

  unc_size = decompress_lznt(frame_ondisk, ondisk_size, frame_mem,
                             frame_size);
  if ((ssize_t)unc_size < 0)        err = unc_size;
  else if (!unc_size || unc_size > frame_size)  err = -EINVAL;

decompress_lznt() stops as soon as the compressed stream is exhausted
(e.g. a zero chunk header) and returns the number of bytes it actually
wrote, which may be far less than frame_size. The bytes between unc_size
and frame_size are never written. The only memset() that follows zeroes
the region beyond i_valid; when the frame lies entirely within the file's
valid size that memset() does not run, so the gap retains whatever was in
the just-vmapped pages. All pages are then marked uptodate and returned
to userspace, disclosing uninitialized (recently-freed) kernel page
memory. A crafted compressed file whose stream decompresses to only a few
bytes leaks the remainder of every frame on a plain read(2), which is
enough to recover kernel pointers and defeat KASLR.

Zero the [unc_size, frame_size) tail immediately after a successful LZNT
decompress so the remainder reads back as zero.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Samuel Page <sam@bynar.io>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/frecord.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2781,6 +2781,15 @@ int ni_read_frame(struct ntfs_inode *ni,
 			err = unc_size;
 		else if (!unc_size || unc_size > frame_size)
 			err = -EINVAL;
+		else if (unc_size < frame_size) {
+			/*
+			 * Partial decompress: zero the [unc_size, frame_size)
+			 * tail.  decompress_lznt() leaves it untouched, so
+			 * without this the freshly vmapped pages would expose
+			 * uninitialized kernel memory to userspace.
+			 */
+			memset(frame_mem + unc_size, 0, frame_size - unc_size);
+		}
 	}
 	if (!err && valid_size < frame_vbo + frame_size) {
 		size_t ok = valid_size - frame_vbo;


