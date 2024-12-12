Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF836217F46;
	Thu, 12 Dec 2024 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017897; cv=none; b=kBD69yuWd21YC9VK3dJUcFNBXoVTVTlTIbH2ObmxEVBblX5KtpCtJip58U2uKXm+3oqWQ0WtzWC5YoSpQ4AFf8R0QX7sy2OeyG8l3R4o9yOx9RahqVXlNZSNi/vDmv8/19ihAcnhosOgBNZMcLtLMDPd/EMleWCRi0jk8+teSGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017897; c=relaxed/simple;
	bh=BLrQJikhizs2thdn9Qi3PG2Yn+2PpEEExr5OnyAZANc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bzu77NpZgp1lueA5Vcoo04p2XiOItziqf2BZVrHSMjxPsJR3fd6tdzAyf5KtEFHTvSMh9WfCYefLTgK/SgbZS0VEnPQmgrow/tRSvOA6ljC/drq99y3Zd7OEPuqiHDg7Xu02FSzu6cmYCm5+HIzhuMT5uULRb3/hAX9InB7FDsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UX0YIToL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UX0YIToL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CD7C4CECE;
	Thu, 12 Dec 2024 15:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017897;
	bh=BLrQJikhizs2thdn9Qi3PG2Yn+2PpEEExr5OnyAZANc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UX0YIToL2dQl1Mu48inN9TbVJ/T72OCxENGR1L0eOqhfqfLlZTjTyfu8hWATTE3S/
	 Nk02ka59S7GAO46/DqP7Ku1n40VZUWN+Vv/uN/PnVyr32hzgTsiJiPWCaNa0KUAKeV
	 pPRwt0Nh9WDKPdVNu+RpidsHJgnHPjYw2dvnCe/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordy Zomer <jordyzomer@google.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 142/356] ksmbd: fix Out-of-Bounds Write in ksmbd_vfs_stream_write
Date: Thu, 12 Dec 2024 15:57:41 +0100
Message-ID: <20241212144250.251156011@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Jordy Zomer <jordyzomer@google.com>

commit 313dab082289e460391c82d855430ec8a28ddf81 upstream.

An offset from client could be a negative value, It could allows
to write data outside the bounds of the allocated buffer.
Note that this issue is coming when setting
'vfs objects = streams_xattr parameter' in ksmbd.conf.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6869,6 +6869,8 @@ int smb2_write(struct ksmbd_work *work)
 	}
 
 	offset = le64_to_cpu(req->Offset);
+	if (offset < 0)
+		return -EINVAL;
 	length = le32_to_cpu(req->Length);
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||


