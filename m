Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F72E35CB60;
	Fri,  7 Aug 2026 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117069; cv=none; b=izIfCNr6tBAfeIz6tTJezIZSIhgbsnEJ92+cgZNk8XTyKLdc5FfHR2/A/scRSJRFU08KYhySB9or1WRid9jMsZ+GSh02H/fMkG0RO9Ie5o91RIQMdh6cvuATiTASaZ9Ohe5EYV1H9QB3E7J0f1mlUh4fI8fxBTDTCMWooxe+LEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117069; c=relaxed/simple;
	bh=UNbqIMteRRtSMOQOxxzorPBKCgqu9kjQSyrCcE1YcVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sd6NqhlCr1gS8YFYo4qw6zfGcPTu1MGMf9cV2kER0ZvqJW8B0iY5z9pqhb4tBfVT1xiaLV4L0OyEDPkR47xB6oWPt6515BNqtVn05yQtvvln6YcGdhufXb1Jz4kDYw5dV+X5KXay7Mr1HwYLe3HKxVLX4udtqMSXZ6gonYGsoQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHDpvE6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHDpvE6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B681F000E9;
	Fri,  7 Aug 2026 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117067;
	bh=sUkqZwhGBhCZoqPOdcoSupTHydRLLr4hPjQZzvYog60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eHDpvE6F5QWpuurDgkTyZ39uOdOkxroJuKZBnx2Zivd+l4H8TrkqLg16Xlrys6kUP
	 HUi7HmDNZZsQAacqGFhsRzhQU0bTK3u+kdEhjiRNgmD2l7+8+1VluUMXk0wdea4vAR
	 lkhglDu2FR1a0vzZDF3j4DpGgZvq+32DKvpNBzAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samu <nomomentomori@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 189/438] ksmbd: use memcmp() to compare ClientGUIDs
Date: Fri,  7 Aug 2026 16:36:25 +0200
Message-ID: <20260807143432.061465928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e8bb506e6ef749ac0336f3e579d8d02396b7d832 ]

ClientGUID is a fixed-size binary value and can contain embedded NUL
bytes. strncmp() stops comparing at the first NUL byte, so different
ClientGUID values can incorrectly be treated as equal.

Use memcmp() in SMB3 multichannel session binding and
FSCTL_VALIDATE_NEGOTIATE_INFO to compare all SMB2_CLIENT_GUID_SIZE
bytes.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Samu <nomomentomori@gmail.com>
Suggested-by: Samu <nomomentomori@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c29850170b315..5df4a8cc4d2e6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1792,7 +1792,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (strncmp(conn->ClientGUID, sess->ClientGUID,
+		if (memcmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
 			goto out_err;
@@ -8186,7 +8186,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 		goto err_out;
 	}
 
-	if (strncmp(neg_req->Guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)) {
+	if (memcmp(neg_req->Guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)) {
 		ret = -EINVAL;
 		goto err_out;
 	}
-- 
2.53.0



