Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955BF3563D4;
	Fri, 24 Apr 2026 13:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038251; cv=none; b=k2W4f77Z4f9ZInQ94iVX2RIiTxRYt2KTCSok0pR5+0iUUZzaslpNkKjoTOZFGkkF4LqOu2kNgouPzjf3F3+4T8nWzu2oTyLC8tdP9qttRdA181HLX56sBUYpoxWHB9fUaMl8Q9Von0aB8Bc0fXatKszXNOb9Qk4/Y7Q2O0uC1VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038251; c=relaxed/simple;
	bh=TJcQR2KYc3oF/JPhnWVECkHtiw0P4pwAG+XhrLr05MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa9QHCnA7c+zUl6GxopAreL3vb5e1l7IW/HHhEnoQyUWb+UmmlLrSkjEtiWhbHCnXSrwpZX3YT4tkYXoOxoPaTIR3nHi87+jw1VCVcdk0361u4mhpKNetxOitfcIb1SYwFvqZ0Uoui1vPYFRTxepei/4mYuXfFIGKHcarurlno8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVJHKJ4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVJHKJ4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C65C19425;
	Fri, 24 Apr 2026 13:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038251;
	bh=TJcQR2KYc3oF/JPhnWVECkHtiw0P4pwAG+XhrLr05MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVJHKJ4zlzz6tQvBnHlSNlrKwO5vs15CU0GMVKpAF1xkmyRN4DRv/dOgc+ONq4KLH
	 SkVd4UD3dgU+rqpwnAnCKUAOcgPvqTIEXwE97jZHQQigp+sjn8fKj1KctnjnpaTmqS
	 fjd/XMpyS/8DQmxtLvEl4/r/V+5uU4RkdJ8XrOFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 26/35] ksmbd: fix out-of-bounds write in smb2_get_ea() EA alignment
Date: Fri, 24 Apr 2026 15:31:33 +0200
Message-ID: <20260424132417.223622735@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4833,6 +4833,8 @@ static int smb2_get_ea(struct ksmbd_work
 		/* align next xattr entry at 4 byte bundary */
 		alignment_bytes = ((next_offset + 3) & ~3) - next_offset;
 		if (alignment_bytes) {
+			if (buf_free_len < alignment_bytes)
+				break;
 			memset(ptr, '\0', alignment_bytes);
 			ptr += alignment_bytes;
 			next_offset += alignment_bytes;


