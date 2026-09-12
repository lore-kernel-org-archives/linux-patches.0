Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2F4373BF3;
	Sat, 12 Sep 2026 09:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204046; cv=none; b=LwuuHGDAEM/iQxAXQhZMiKjZlgmybFAEQRuV039sEZYLg+AY92slMGWb+y6OjgnEKD7XZuTl4GOZUxqIgGUDVIHXCRQMUML6yKJakWhZaj+124KjrFrOzb6vSqxaH/D+dNGLWAX4MtC5uGR09ThrNsjPjDLnYMIpPnEw+5NCA9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204046; c=relaxed/simple;
	bh=lZIIbvqp9H1FreFt6HmdaLHcOd+JcjqCn0SCnfyxEzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XN5DYP25fRYSCXTNlrGDzZsm2dKdlXBvKIgexde3IL5RB/1I2w90v/xJma1KUkRBmIX2u9eHxaIrAa14wvyYKFE+/oV5/8hrkIFrpQYYBnFYz/aq48ej7CWsOg0rfKOHZ3PZEhfY7qazAXYFPrv6WFKElM6L9xy9iU6NyIvs+Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRBOJ0w6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRBOJ0w6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00ED1F000FF;
	Sat, 12 Sep 2026 09:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204045;
	bh=b3/pl1XofoadYLFT8AfZHjDIncYrFe3EJwzPpvgVCKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRBOJ0w6E9kDUW6/6viLuqQU8r0fr9yMX7W2eTplOcOsKrGG1ZgpUgKqzFemjbBoz
	 gyYyxT71u5RnOUBBfWAfsLwbPYOHTzEug+teVOWtTu1vJ9djN3Mx/DZo/U3BS4X3DR
	 GBA3PCCir4Yj4N09GsQH+tsQBI/1buGRfrUDuZQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1532/1815] ksmbd: validate SMB2 write offsets
Date: Sat, 12 Sep 2026 08:54:42 +0200
Message-ID: <20260912065724.969677850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit df35438ba9d5687335a405418772b6cd30383687 ]

An SMB2 WRITE request with a negative offset returns -EINVAL directly
from smb2_write(). This bypasses the common error response path, leaving
the client waiting until the request times out.

ksmbd also allows nonempty writes at or beyond MAXFILESIZE as defined by
[MS-FSA]. Writes beyond the limit must fail with
STATUS_INVALID_PARAMETER. Writes ending at the limit fail with
STATUS_DISK_FULL, while a zero-length write remains valid.

Route negative offsets through the common error path and validate the end
offset of nonempty writes against MAXFILESIZE.

This fixes smb2.rw.invalid.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 2cbd4a8bf460 ("ksmbd: fix encrypted request lookup on bound channels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 534416e2b599c..acf664a5183da 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -64,6 +64,9 @@ static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
 /* Windows reports automatic write-time updates at roughly 15 ms resolution. */
 #define KSMBD_WRITE_TIME_RESOLUTION	(15ULL * 10000)
 
+/* MAXFILESIZE in [MS-FSA] 2.1.5.3 Server Requests a Write. */
+#define SMB2_MAX_FILE_SIZE		0xfffffff0000ULL
+
 /**
  * check_session_id() - check for valid session id in smb header
  * @conn:	connection instance
@@ -8159,8 +8162,10 @@ int smb2_write(struct ksmbd_work *work)
 	}
 
 	offset = le64_to_cpu(req->Offset);
-	if (offset < 0)
-		return -EINVAL;
+	if (offset < 0) {
+		err = -EINVAL;
+		goto out;
+	}
 	length = le32_to_cpu(req->Length);
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
@@ -8174,6 +8179,19 @@ int smb2_write(struct ksmbd_work *work)
 		length = le32_to_cpu(req->RemainingBytes);
 	}
 
+	if (length) {
+		u64 end = (u64)offset + length;
+
+		if (end > SMB2_MAX_FILE_SIZE) {
+			err = -EINVAL;
+			goto out;
+		}
+		if (end == SMB2_MAX_FILE_SIZE) {
+			err = -EFBIG;
+			goto out;
+		}
+	}
+
 	if (is_rdma_channel == true) {
 		unsigned int ch_offset = le16_to_cpu(req->WriteChannelInfoOffset);
 
-- 
2.53.0



