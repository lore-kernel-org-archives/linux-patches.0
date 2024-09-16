Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A19155335;
	Mon, 16 Sep 2024 12:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488150; cv=none; b=pz2vBT0K87EP5YyfK951uDSyb7zBd8DRIFJioW95pfpH0QgBtWYhliWCy1hV061uhZRSH+l53tejOPcBW8BnUclwvHqxYwM9tGtDfhvPeQAeYSfgeKBaNX7H1fKZp5Wov2C65uFqc86NExOPeljduWmj+TYAHmve8LTVGiYL3/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488150; c=relaxed/simple;
	bh=20Zr6FceFWLzTFEQS+oxv1+XWtQHcwxfaK09McK/pUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELXMWfLxnsHfm747kkwgE+qIur7ux+s7F3zlQtfzSpfaoQwEpcQBvKY3MxLIImbIJfBBYahs0lwnWYSfwkNoBBAU1YDTv1bbRhT2zA5O43fASoLt3dnNLLZMUgPcPbMJaDH0R0LH5/elg/DbQ3vbB/6SQC+cvK9uhhuUoBi0XY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLoBjE0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLoBjE0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC89C4CEC4;
	Mon, 16 Sep 2024 12:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488150;
	bh=20Zr6FceFWLzTFEQS+oxv1+XWtQHcwxfaK09McK/pUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLoBjE0oDNkfEKLhNKvpJLcR1kWjgTXJRP/CyttBdyKV3yHYwawSrEIcN0WLVbBt2
	 wZD81FI/9YnlTiruxgvg6CzPPTSQaFKAqGfLrmNT36auJIdb+DwOSanfGBlLy+1Pf0
	 TvKjisbvuYaXHRrhtFpd8xodBhmIWvs+QF/AgVt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangsoo Lee <constant.lee@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 005/121] ksmbd: override fsids for smb2_query_info()
Date: Mon, 16 Sep 2024 13:42:59 +0200
Message-ID: <20240916114229.111835503@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f6bd41280a44dcc2e0a25ed72617d25f586974a7 ]

Sangsoo reported that a DAC denial error occurred when accessing
files through the ksmbd thread. This patch override fsids for
smb2_query_info().

Reported-by: Sangsoo Lee <constant.lee@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 65cb35ed36c6..0687083bcc3f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5601,6 +5601,11 @@ int smb2_query_info(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "GOT query info request\n");
 
+	if (ksmbd_override_fsids(work)) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
@@ -5619,6 +5624,7 @@ int smb2_query_info(struct ksmbd_work *work)
 			    req->InfoType);
 		rc = -EOPNOTSUPP;
 	}
+	ksmbd_revert_fsids(work);
 
 	if (!rc) {
 		rsp->StructureSize = cpu_to_le16(9);
@@ -5628,6 +5634,7 @@ int smb2_query_info(struct ksmbd_work *work)
 					le32_to_cpu(rsp->OutputBufferLength));
 	}
 
+err_out:
 	if (rc < 0) {
 		if (rc == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-- 
2.43.0



