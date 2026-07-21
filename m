Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8683E0C55;
	Tue, 21 Jul 2026 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653926; cv=none; b=kN4Z89j/5mWOHMSs19cvT/kI8xUo0RscQdwAJc4li8+fGzG8zNcGyvGKGhYjiqR5jnfVNPtp0gzlD2bj/olzLwBUCNSE0KaAjh8n4aOzJNXv29wFxMT1lLZv1zh2S1kKs8aPGFCPjhig7ZxEDY1hKSje/JSr2z3HaN+nDoqM97Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653926; c=relaxed/simple;
	bh=zjfn+Wg+3VLzOstSVu1KA2RpKvPb29zBUklscpJnosg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iubO48u6vp0khEVpB0DnhAuWlQphLQxBqEXSd0CST8Z8jNflw8dZ9YZZizKjVzpUBm3RPmgTBidiHf/qMsytJE5T7PeNLn4vjnaZGqDNW5myHujjn3m3v8pk2/NJyXSfQMmlo3kdPqf17dSEljMXnp6AxV1zmI43twEuxCeraVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEPOgR2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEPOgR2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93811F000E9;
	Tue, 21 Jul 2026 17:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653925;
	bh=QUe00Ba7acPs0QJvnx4N5iglpmiYMBYFIc6JDCtKelI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEPOgR2+lTeXBbqDq6NpmDG74X0/fkBimSf2o/ioXqiVic1oHgi6TEeYRB5ZVNTDM
	 T7M+axkqyBpqX2aRHb1tROsdkMW2Zr2rgCoszKsLOr5S/7XH7lN04b5FTnqPDiv5I+
	 l0AtVnFputVbzYZD/grt9dUOXhCTUFAXn06lHQhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1510/2077] smb: client: fix overflow in passthrough ioctl bounds check
Date: Tue, 21 Jul 2026 17:19:43 +0200
Message-ID: <20260721152628.399504130@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit a4f27ad055392fa164f5649e89a3637b033c5fcc ]

smb2_ioctl_query_info() validates the PASSTHRU_FSCTL response payload
before copying it to userspace.

The payload offset and length both come from 32-bit fields. The bounds
check currently adds OutputOffset and qi.input_buffer_length directly, so
the addition can wrap in 32-bit arithmetic before the result is compared
against the response buffer length.

A malicious server can use a large OutputOffset and a small OutputCount
to make the wrapped sum pass the bounds check. The later copy_to_user()
then reads from io_rsp + OutputOffset, outside the response buffer.

Use size_add() for the offset plus length check so overflow is treated as
out of bounds.

Fixes: 2b1116bbe898 ("CIFS: Use common error handling code in smb2_ioctl_query_info()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 10664380f351aa..15cfb513238f6c 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1772,8 +1772,8 @@ smb2_ioctl_query_info(const unsigned int xid,
 		if (le32_to_cpu(io_rsp->OutputCount) < qi.input_buffer_length)
 			qi.input_buffer_length = le32_to_cpu(io_rsp->OutputCount);
 		if (qi.input_buffer_length > 0 &&
-		    le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length
-		    > rsp_iov[1].iov_len) {
+		     size_add(le32_to_cpu(io_rsp->OutputOffset),
+			     qi.input_buffer_length) > rsp_iov[1].iov_len) {
 			rc = -EFAULT;
 			goto out;
 		}
-- 
2.53.0



