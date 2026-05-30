Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49323242BA;
	Sat, 30 May 2026 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159747; cv=none; b=az2sA4OZCbf1z70z3YAgfurztDGvhHnRdcGXgNA/Qgd8LA4O2B/7hbHYuLqVyTCIM+mjtAegIDLTEIxCH0QRe5rGMUTQeJWLvPiBNkL21DuZlQi1EByM2qUxZw1yxlDK4g4uN93sXEh18kthlH0srVl3YmwVBK1Clj0XN1hKGVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159747; c=relaxed/simple;
	bh=NpEmDmCMvvZPRTMQN/+qcCzG94y+5UqMgBiW+PxBV9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiq2tOXCLxc1APURAMT82Sn6d6mISBqgBha1KUn0+WTnzhqsayBiw7HdF2jyiax4Z6VLdmaPLOqb6GkN28KzAGPUKVSjaXA1orB7hm3jYpyNMDEhAwagX5DhHsVfZz9uny2nvZfpmm0H+hkIW9ZaqH8NlrsdbSFif5J+5AClmYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sjrkn/Q9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sjrkn/Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B275E1F00893;
	Sat, 30 May 2026 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159745;
	bh=h6n2loZ4hACeNYPQAJlAw18Zf8K2LFE5wBdepAL9Nls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sjrkn/Q9L30rqILVsh/CiiLlbCsyetWwZLAJnYvvBEga54L5Z3qkZ+tHt3bpFxgol
	 /2NlP7xNRwtdJOQ7AqotslndEGval5elK4V2oP06C/VhM6bnCAziiYsYOxtiYdRVy0
	 JXnlUw1/RqK379piF95d2nx3bx9TXDeDWMs0vW4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 150/969] ksmbd: fix out-of-bounds write in smb2_get_ea() EA alignment
Date: Sat, 30 May 2026 17:54:34 +0200
Message-ID: <20260530160304.693380345@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit 30010c952077a1c89ecdd71fc4d574c75a8f5617 upstream.

smb2_get_ea() applies 4-byte alignment padding via memset() after
writing each EA entry. The bounds check on buf_free_len is performed
before the value memcpy, but the alignment memset fires unconditionally
afterward with no check on remaining space.

When the EA value exactly fills the remaining buffer (buf_free_len == 0
after value subtraction), the alignment memset writes 1-3 NUL bytes
past the buf_free_len boundary. In compound requests where the response
buffer is shared across commands, the first command (e.g., READ) can
consume most of the buffer, leaving a tight remainder for the QUERY_INFO
EA response. The alignment memset then overwrites past the physical
kvmalloc allocation into adjacent kernel heap memory.

Add a bounds check before the alignment memset to ensure buf_free_len
can accommodate the padding bytes.

This is the same bug pattern fixed by commit beef2634f81f ("ksmbd: fix
potencial OOB in get_file_all_info() for compound requests") and
commit fda9522ed6af ("ksmbd: fix OOB write in QUERY_INFO for compound
requests"), both of which added bounds checks before unconditional
writes in QUERY_INFO response handlers.

Cc: stable@vger.kernel.org
Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4495,6 +4495,8 @@ static int smb2_get_ea(struct ksmbd_work
 		/* align next xattr entry at 4 byte bundary */
 		alignment_bytes = ((next_offset + 3) & ~3) - next_offset;
 		if (alignment_bytes) {
+			if (buf_free_len < alignment_bytes)
+				break;
 			memset(ptr, '\0', alignment_bytes);
 			ptr += alignment_bytes;
 			next_offset += alignment_bytes;


