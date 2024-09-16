Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDF715665C;
	Mon, 16 Sep 2024 11:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726487959; cv=none; b=tMkAwOFPD6z2BN+eJAztBV18eOSxgcliwMRtZUr7AwBLZHmsf1LwYjmadCmFN+AEgXPR2Gz0dvGCqcFKqdZfmZWQAdRBhhMp0I9LJ24YHPBZgqwP3YfXxJisjXDxZc8rljFQ0R2faQTYRpPibi6wQb112rLf7JJdgi7l5vTIUv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726487959; c=relaxed/simple;
	bh=9bryp0z+hLPGKWjhTFi2nyL8V6GMCopvI3gjgu0CQLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsQECG6PX3f3KORa9mJn0rFKeKrQh/zBchfYSqOXoawlUL0sdcIAVbS6Zq5BTg5vq38XLgpnahjJ/CA3j14Gs6omzT3IxQTZRXYxOiC8JwJkvqkEdwVVowWz7w3f2zbRlxYodihCrWN6oAJw32l+DPjtb0WBo86InWQek5EfS+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrIrZ4US; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrIrZ4US"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E3EC4CEC4;
	Mon, 16 Sep 2024 11:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726487959;
	bh=9bryp0z+hLPGKWjhTFi2nyL8V6GMCopvI3gjgu0CQLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrIrZ4USpjpOqaVCZMAjlrOQGAaHEmNMQs85d9EgxMOtS5bGeWL4bNWYSfNuVOzCu
	 TbQNaL42UWjJtyPOi1o09KERaWgZznik5xGhRcUQ4Rm75by0FaysJN278izlNe0IXE
	 iCVY6Ct43F0yc7ErEu/gB/9yyCGPKKapvGFq0NJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangsoo Lee <constant.lee@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/63] ksmbd: override fsids for smb2_query_info()
Date: Mon, 16 Sep 2024 13:43:41 +0200
Message-ID: <20240916114221.106361043@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 386f1f039883..808c62d7ff3e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5326,6 +5326,11 @@ int smb2_query_info(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "GOT query info request\n");
 
+	if (ksmbd_override_fsids(work)) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
@@ -5344,6 +5349,7 @@ int smb2_query_info(struct ksmbd_work *work)
 			    req->InfoType);
 		rc = -EOPNOTSUPP;
 	}
+	ksmbd_revert_fsids(work);
 
 	if (!rc) {
 		rsp->StructureSize = cpu_to_le16(9);
@@ -5353,6 +5359,7 @@ int smb2_query_info(struct ksmbd_work *work)
 					le32_to_cpu(rsp->OutputBufferLength));
 	}
 
+err_out:
 	if (rc < 0) {
 		if (rc == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-- 
2.43.0



