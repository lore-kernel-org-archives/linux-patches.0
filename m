Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BCC3563D4;
	Fri, 24 Apr 2026 13:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038151; cv=none; b=RX4ECZS+nR0pwBOGKcO8L7WlbaOtRDyJWLD8T2X4L91Ejp6I6Mn8enohpwQnfYyHMKbYAnoqDY+PIe6+qQhKC1WFQHRvWsRJ6LIB1BMnxByhLqQIamafGxTI7CIFS09NoVpuhT1uoA8rYxscLkSD48KOvBthrbgatCchRgrHwBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038151; c=relaxed/simple;
	bh=hHYTfZQzCOZfTiA3ksb39R2BniL1jhsQrdTQzguakNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJKSQg2ZcSQygzOiA0LUEb9YWJZ1XpFRQS3/OGf3Xx/l9QWjOUQCiX4zS0ZX7HjEOWQKO3TmCBIZBEJ8iIZ3NDLxO6Gg7kD2oVzmuCbqLtpFwXMtjKx8AyVpQoWGmp0r8G0QBEL9wRwiejwfrd4FnfvxnUHUduDoFmVqcLmPb4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYFzmsS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYFzmsS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7D1C19425;
	Fri, 24 Apr 2026 13:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038151;
	bh=hHYTfZQzCOZfTiA3ksb39R2BniL1jhsQrdTQzguakNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYFzmsS6U/cvqUMsY8bs6NQP01enFKWq9NQ3qqbq3w0LyKB3Y3FuilJW14PDHBIv3
	 PnPRCIKEiQQmWa1lAc/sNLepaV/lnjQjNoCkk9ypDJjcvQ6XJZcWOdGxGfDXi9j/rb
	 0KNsh/chACOjmf36Sm1nGY5a12EwUb6x4fIrREpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 43/55] ksmbd: fix out-of-bounds write in smb2_get_ea() EA alignment
Date: Fri, 24 Apr 2026 15:31:22 +0200
Message-ID: <20260424132438.973010750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4831,6 +4831,8 @@ static int smb2_get_ea(struct ksmbd_work
 		/* align next xattr entry at 4 byte bundary */
 		alignment_bytes = ((next_offset + 3) & ~3) - next_offset;
 		if (alignment_bytes) {
+			if (buf_free_len < alignment_bytes)
+				break;
 			memset(ptr, '\0', alignment_bytes);
 			ptr += alignment_bytes;
 			next_offset += alignment_bytes;


