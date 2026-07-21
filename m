Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D0047012C;
	Tue, 21 Jul 2026 19:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663391; cv=none; b=kUNgk29urm6j7mj7qZ3dNbZf15nbVYH52irwySRJKqbV3Gyexno8QRZOBD7zpR6hks0uvdSXzWd3GPvohoDcXFt5pNkVmYVgc3HvTJSw/p85RX4H5YJp9PfWlDbI08EDZBztGhTqSqtfwIUoHCOebZz6ZyxyNDDKKWPPW3sdIJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663391; c=relaxed/simple;
	bh=YKqxToK8xXqzF4n/AVp8NMbmn8BjNS6cCTwQnhSG1bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbipZl8QxaXT0L4zt4TN1UF+7veL/TneacKTn1+36SSVBarA6He72D3iurnS/BQ2LzPCUEzlTJdCPMKvV5v3u88ajsrVXAMol0CbHnrVQStDD9QUqWSIW2+Xb8XASa7qI1hyE9Qab5/BGWCO2rPyeEPEjXBklZpRPzHvVKZM1CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMSRhfxQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMSRhfxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06481F000E9;
	Tue, 21 Jul 2026 19:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663390;
	bh=f3gcCET2EYYagY+5DJM8BXy9U6n6FdV0l0Rz/iP8oOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMSRhfxQNeT/emd2uFC2Tj3pQ9LkXXS3ju5wAWk+QVtBhwuQjcTFXCHeeA0+VDrFm
	 V3F2TENfZeY/Hl7oopzO9jX50jfPl/UxlKGqc1lgg1nzSSSk7y95GvYsTWvL+m7cWD
	 5LbXvti1ay6rGRicrjwqNyCPfF8T6f/xjRoCP8Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0805/1276] smb: client: fix overflow in passthrough ioctl bounds check
Date: Tue, 21 Jul 2026 17:20:48 +0200
Message-ID: <20260721152504.087142399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 6c867004be696c..cd0cf3393055dd 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1771,8 +1771,8 @@ smb2_ioctl_query_info(const unsigned int xid,
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



