Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C77044211F;
	Tue, 21 Jul 2026 22:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672244; cv=none; b=dWPUPFJNQ89PypLmVF80vS+35lws62bnilSMx7MvGSt3tPL2q3xmxT0yxRv8OChh6mEwZ8FVjowcEey+CPLUfipeLeI1oAKVn7MQSfKJoFHs70pRAMSYZNSYTYEolUyvW/ezT7Wlilm6K7tvI+bb3k5zXwc4G8AIejScsV0mN3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672244; c=relaxed/simple;
	bh=wX1UU6KVOYYoZWICn2eU72CIzBu00zPLSsoJkHaNibA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRX7In6nFpJ12Y3jnvv8EGNFuYYngDGZa430RIWn0P48P3KGbUS7efQW4+adb5Ek5EVZHzRsUh2Zy+eM08f9yOuxa26BEL6NxM+xgR9TElNdulJQh3BZ2jC1KQP+vpqAtIoVRVrc8eMYevlcXl6mQWArz4IT+dt4eRz3DwB6DSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5qQnqd3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5qQnqd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DBF1F000E9;
	Tue, 21 Jul 2026 22:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672242;
	bh=P8RE3PievqmjM30LXU9Szb4kpBmEnS56gPeFH2wA+hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5qQnqd3bYUMQSzfaKhS0fjZseA0EF7bUtgVyaa+5jTfdVlibzoxxoC8Bf7p/cH73
	 sVNH1u4p6EyR5eUP0hEcYBuRgTDfiS9/ZEQ3EliOYKPy4EKWwuWDj5WE/bHnLc096T
	 bWnfRBVkzUJ5GPEWAVfxdjowDKg0xl6/DFoQyEI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 552/843] smb: client: fix overflow in passthrough ioctl bounds check
Date: Tue, 21 Jul 2026 17:23:07 +0200
Message-ID: <20260721152418.463503014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/cifs/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 47dc87af194047..93fa450b30724b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1804,8 +1804,8 @@ smb2_ioctl_query_info(const unsigned int xid,
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



