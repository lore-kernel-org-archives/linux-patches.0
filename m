Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E736403B06;
	Tue, 21 Jul 2026 17:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655109; cv=none; b=AryOi0FjKFy/frUMxWutnmrLFOW2PUwJjR7jsjiP80egJmaC9s5V9UPUcIeQHkZfjXF5E4sZVuLp/bFbIBw6F3kuD25yYba0bEwKbQ0t1MdOOFcGZn/h2P8ud+lthrav8juF7HpAdeNhNIajdeZFXDRENkZ7jmnI52oVzjNMsIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655109; c=relaxed/simple;
	bh=nGqAOUFF87GBh+VbOEje7mOBKeAF/RTbeetoPTjHpbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovcYtzxUhgUA+Z+BkVZlAAkiAAMKsyu8rMk8/XYf8RzZRY5wfYacJsBXh8weG1n4+ArKDtuM63iSB9Qz2Q3mnyCDI/SpwuNtoYPmXsFm7JiinN08teap66ZFdI4euXhf13q07lWRORsAzWWqyXzIkS8Vaa1dO/xtHPqoRSPD6t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TK3DvxX4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TK3DvxX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BFE1F000E9;
	Tue, 21 Jul 2026 17:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655108;
	bh=GBcUlqv5KUsQmXY3AeBZ1lAK5Jpz7j12g0iKzVuHZOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TK3DvxX4wy5991/CHM4hFhUWiB1cAhUz9km8wLlAVqKVIFwolldXWs4hak2Ky+tUa
	 R40oE0FBFv+SJsXLUwQkWSkl4+O9WlM9VSMxGu4wAVyJ62nTfvVoWF2+WD+8eHS/X3
	 7fz/ld6jkaQqAK6wlPlcWl3t8t7vmldwv8sJ21M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.1 1959/2077] orangefs: keep the readdir entry size 64-bit in fill_from_part()
Date: Tue, 21 Jul 2026 17:27:12 +0200
Message-ID: <20260721152638.914742279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 18227a6bc98bd0ba96ed3ce9d5b28776a5a28dfc upstream.

fill_from_part() computes the size of a directory entry in size_t but
stores it in a __u32. An entry length near U32_MAX wraps it to a small
value, bypasses the bounds check, and is then used to index the entry,
reading far past the directory part -- an out-of-bounds read that oopses
the kernel.

Compute the size as a u64 so it cannot truncate; the bounds check then
rejects the entry. The trailer is supplied by the userspace client.

Fixes: 480e3e532e31 ("orangefs: support very large directories")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260619-b4-disp-50d2bd59-v1-1-ce332969b4a2@proton.me
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/orangefs/dir.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/orangefs/dir.c
+++ b/fs/orangefs/dir.c
@@ -191,7 +191,8 @@ static int fill_from_part(struct orangef
 {
 	const int offset = sizeof(struct orangefs_readdir_response_s);
 	struct orangefs_khandle *khandle;
-	__u32 *len, padlen;
+	__u32 *len;
+	u64 padlen;
 	loff_t i;
 	char *s;
 	i = ctx->pos & ~PART_MASK;
@@ -215,8 +216,8 @@ static int fill_from_part(struct orangef
 		 * len is the size of the string itself.  padlen is the
 		 * total size of the encoded string.
 		 */
-		padlen = (sizeof *len + *len + 1) +
-		    (8 - (sizeof *len + *len + 1)%8)%8;
+		padlen = (u64)sizeof *len + *len + 1;
+		padlen += (8 - padlen % 8) % 8;
 		if (part->len < i + padlen + sizeof *khandle)
 			goto next;
 		s = (void *)part + offset + i + sizeof *len;


