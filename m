Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4896154C04;
	Mon, 16 Sep 2024 12:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488492; cv=none; b=gYWYVswKCnKY4XuB7HXh0ChWJ4khE5ckmBb7qrYwHfOxahBvOT+FQLXquJjrMXrjaR4m9cgo5C9uKUSOrZbIZMYi5zF2ELxYi/2Ci3torHBeWfc/Ubri4MBnX7uFiOy0J5oPUYFOItB9Vi3HMb5clnVs5NmlZSyOoSt7MYbEw78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488492; c=relaxed/simple;
	bh=B3fdbKgdkOQ/yAjUzBb0DXybWRFfNE2VMcqQ5OciJEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyMja7GRlHi31c3fEwCdsV4H2oMs84OjNjHHF4kKosJWA/yr36WW1b49WcgQh5ZdQiVLrmJfPTYRgH8RmcOrs3qoIkEqURBIv4Vmzw4tTAYASLiom6CPVfiWlnTlL3dcpRb98/jgO72LEJAXZ3qOECaK1Qhr9gJC2j2EIkqHTtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFYl5TyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFYl5TyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9FAC4CEC4;
	Mon, 16 Sep 2024 12:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488492;
	bh=B3fdbKgdkOQ/yAjUzBb0DXybWRFfNE2VMcqQ5OciJEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFYl5TyY7+LZBC+aUNsIkT6yRDbSjU+scG8EeJ+qvA/rr6//ba4xdARC2HVpSY949
	 BVLkbDeZw/EHAgufR64BwpV72KrcJjiA/GgN4p7LSM1XwsvUpHDm1E0XXkHAOsJsZP
	 D1lUA2v3jGyJlVjK5f39KNZ31Qbq4Xm0LpG2cnrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangsoo Lee <constant.lee@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 11/91] ksmbd: override fsids for smb2_query_info()
Date: Mon, 16 Sep 2024 13:43:47 +0200
Message-ID: <20240916114224.908360754@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ac6068c50cc..c527050bc981 100644
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



