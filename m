Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C177080D;
	Fri,  4 Sep 2026 05:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498943; cv=none; b=p5zHX+4SMk/pZyfMV2JgElCr3fR7BxP6GPSWWbJ0FaUIRpBsSQj7Z7Wg0wSZgfNUUmd4a+yluVar0OnxVPleVnsUqYYNx9VhVTD4lj1QHh+FlV7F6J+TDd9UJQFkq4JEW/BR0vs6cVpOAYIRODRFaIXIwck+y0BHu/iHPYUKCNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498943; c=relaxed/simple;
	bh=BrSdfnTtF2lCxC5rItgQGar2jdPFT7TI2DbF9h+z6ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hso+QekOsm2ZtjVsdb0qelv3PC4J47ot/sz/JVBnyi4FShkZ8MEHWGaFNUAoALimYS3lHDTbjbTRI+cn7zICTm5rsu1R70eQFJWDnm2VNidTZPzlVVVFYjoINDuGXDJJM9SjKgvDiHhcRuGTD2frLKSKNxhr5hMkVStXk8BJnt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YT5Dt7g1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YT5Dt7g1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DD81F00A3D;
	Fri,  4 Sep 2026 05:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498942;
	bh=AUV/91NvAs/8TCErRbvdaZjI/sSHbLlzV7u43SXlrQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YT5Dt7g1SWI7s1phB21Y/391a6NZ0m3hOB6Ygu2M6kJ4Srn1cibwGm1V2BEu0Hg79
	 la3T8S2/7fXVPYQtWxT32Ju4V4lOBWiqqHcQEdZsa9oIqR/B1eTnCcH+yn12s2SojE
	 83eRttBRTibNgKuEJd5lxWZk7IeQVvEVMXcZ0+DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 242/713] smb: client: fix use-before-check of ReparseDataLength in reparse_buf_ptr()
Date: Fri,  4 Sep 2026 06:53:30 +0200
Message-ID: <20260904045809.255809951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 05f78e6cf34ea3a285053bd5999e08e8ac298bd5 upstream.

reparse_buf_ptr() reads buf->ReparseDataLength before checking that
count covers the full fixed header:

    buf = (struct reparse_data_buffer *)((u8 *)io + off);
    len = sizeof(*buf);                          /* 8 bytes */
    rdlen = le16_to_cpu(buf->ReparseDataLength); /* offset 4, 2 bytes */

    if (count < len || count < rdlen + len)      /* check comes after */

struct reparse_data_buffer has ReparseDataLength at offset 4.  If a
server returns OutputCount < 6, the read at offset 4-5 reaches past
the end of the received data.  The off+count bounds against iov_len
were already validated, but that does not protect against count being
smaller than sizeof(*buf).

Split the check: verify count >= sizeof(*buf) before reading
ReparseDataLength, then verify count covers the data region.

Fixes: a158bb66b137 ("smb: client: optimise reparse point querying")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -40,9 +40,11 @@ static struct reparse_data_buffer *repar
 
 	buf = (struct reparse_data_buffer *)((u8 *)io + off);
 	len = sizeof(*buf);
-	rdlen = le16_to_cpu(buf->ReparseDataLength);
+	if (count < len)
+		return ERR_PTR(smb_EIO2(smb_eio_trace_reparse_rdlen, count, 0));
 
-	if (count < len || count < rdlen + len)
+	rdlen = le16_to_cpu(buf->ReparseDataLength);
+	if (count < rdlen + len)
 		return ERR_PTR(smb_EIO2(smb_eio_trace_reparse_rdlen, count, rdlen));
 	return buf;
 }


