Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF703C4B93;
	Tue, 21 Jul 2026 21:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669858; cv=none; b=YlQfuOhYe2COhiiqfPYx2jJwCt8Pozgs3S1cb3n/wVG7jpB8pLByVFTMB1ux01DmlM95r8JpYtcIey4V8aFPH0wH54uGUANOb/4bi0BGVEHxiDQ2zCEAUjWR+GoMqFUhtmOBU+InID/VMVE8vh3+U2H3VH4faDaTjk+38JuoU3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669858; c=relaxed/simple;
	bh=HmUZStnMDBzYxrtGK8KldyWJR2RpVEqtFCWWy0AHRTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFMzixSVO4rkvbm4wom5kZhaRE+jIyQRZEupIOYRsP0yo3/ECY49RdH647Y7buTiEYE3Lb4h3458uYYACxnmZXEb6s/NLHwfjWkcx0W2bpYeYLqnK0f5ak3Ptk0k7v7OkpltYx1KsZ6y4GGjh0Uq/nMDcZMHMvY7ZX/ot0QERIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9r+omUP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9r+omUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE54A1F000E9;
	Tue, 21 Jul 2026 21:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669857;
	bh=8ZXsILMZoPu0fgUF7sukqC5DK0q0UtyebtLVVPJCHug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9r+omUPwyVLlzjQzfdzsAx19/+0B3tRehp4vxe3VqJSelcPJ6WICzcL8KWL9qbd+
	 tL8Lxkpk0SBW9YxoLAeIF0NUl7Gw0Wwr3MlNC2Hl9cbgIWskzXobqIU/ukAiPBiRNv
	 9ghrAX6eCRf2paamqfOetfYMNLv2BESfvNc6wzDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0714/1067] smb: client: fix overflow in passthrough ioctl bounds check
Date: Tue, 21 Jul 2026 17:21:55 +0200
Message-ID: <20260721152440.562053716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 65a6bd18a604b3..a256a3ede7542e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1690,8 +1690,8 @@ smb2_ioctl_query_info(const unsigned int xid,
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



