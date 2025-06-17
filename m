Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F46622FF2B;
	Tue, 17 Jun 2025 16:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177182; cv=none; b=Lp3gB0iORBlTVUE1/Y+YE2U/l8r4gQoE0NJ4CCl4jfx1EPJTk7mHKnfGpW3lMSLrrNVEURDI/qE34sidhSYpiPOr92rE8o72Zu2kD5YMYjBa/B3pTVdfS4tOLMVqjkLyhlQfXZo9Te904tBI1JkYidvB3JN29uqovLypVSbEzEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177182; c=relaxed/simple;
	bh=jUSFWYZzE3i5bK62/4OVdoDu82r5TUE/SijGCVHsdbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ImTOeqxW6l1FLMIc1It6g88mBsYD8N29RjXVy+CEpdKMg0UEryfElgla8NC5qNVmrFlT6i2co2ePHUcKSbHIXPAMKPgCtWd6GDCnOyFqYotpRdMyawjff4+BBwQmnakXLM2fQ4wxfBjoMYjFiYJ/+plD9lF6Fkwj5whoM8v9xPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7Oe3vjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7Oe3vjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2849C4CEE3;
	Tue, 17 Jun 2025 16:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177182;
	bh=jUSFWYZzE3i5bK62/4OVdoDu82r5TUE/SijGCVHsdbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7Oe3vjweyzQf7ARz53/VUFlVMKjN/Xe17bC3IOSF+uNN7drGi3IVogamgKz4I2P1
	 A80MzLPvSm5rMPsDD8PNISf0kZOniZ7zRY+LOGZsLOS2X0hVFPX+Ty7LqE/JpzSLNG
	 tZm33XNvWg82yJtwwn+jQsnLNsNYCpD4JbvDaP78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 304/512] cifs: Fix validation of SMB1 query reparse point response
Date: Tue, 17 Jun 2025 17:24:30 +0200
Message-ID: <20250617152431.918593308@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 56e84c64fc257a95728ee73165456b025c48d408 ]

Validate the SMB1 query reparse point response per [MS-CIFS] section
2.2.7.2 NT_TRANSACT_IOCTL.

NT_TRANSACT_IOCTL response contains one word long setup data after which is
ByteCount member. So check that SetupCount is 1 before trying to read and
use ByteCount member.

Output setup data contains ReturnedDataLen member which is the output
length of executed IOCTL command by remote system. So check that output was
not truncated before transferring over network.

Change MaxSetupCount of NT_TRANSACT_IOCTL request from 4 to 1 as io_rsp
structure already expects one word long output setup data. This should
prevent server sending incompatible structure (in case it would be extended
in future, which is unlikely).

Change MaxParameterCount of NT_TRANSACT_IOCTL request from 2 to 0 as
NT IOCTL does not have any documented output parameters and this function
does not parse any output parameters at all.

Fixes: ed3e0a149b58 ("smb: client: implement ->query_reparse_point() for SMB1")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 8667f403a0ab6..cf8d9de2298fc 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2780,10 +2780,10 @@ int cifs_query_reparse_point(const unsigned int xid,
 
 	io_req->TotalParameterCount = 0;
 	io_req->TotalDataCount = 0;
-	io_req->MaxParameterCount = cpu_to_le32(2);
+	io_req->MaxParameterCount = cpu_to_le32(0);
 	/* BB find exact data count max from sess structure BB */
 	io_req->MaxDataCount = cpu_to_le32(CIFSMaxBufSize & 0xFFFFFF00);
-	io_req->MaxSetupCount = 4;
+	io_req->MaxSetupCount = 1;
 	io_req->Reserved = 0;
 	io_req->ParameterOffset = 0;
 	io_req->DataCount = 0;
@@ -2810,6 +2810,22 @@ int cifs_query_reparse_point(const unsigned int xid,
 		goto error;
 	}
 
+	/* SetupCount must be 1, otherwise offset to ByteCount is incorrect. */
+	if (io_rsp->SetupCount != 1) {
+		rc = -EIO;
+		goto error;
+	}
+
+	/*
+	 * ReturnedDataLen is output length of executed IOCTL.
+	 * DataCount is output length transferred over network.
+	 * Check that we have full FSCTL_GET_REPARSE_POINT buffer.
+	 */
+	if (data_count != le16_to_cpu(io_rsp->ReturnedDataLen)) {
+		rc = -EIO;
+		goto error;
+	}
+
 	end = 2 + get_bcc(&io_rsp->hdr) + (__u8 *)&io_rsp->ByteCount;
 	start = (__u8 *)&io_rsp->hdr.Protocol + data_offset;
 	if (start >= end) {
-- 
2.39.5



