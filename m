Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DB51BC9E3;
	Tue, 27 Aug 2024 15:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771561; cv=none; b=H87SkgfxKmqD/BhvCYwG6PuL/r2qbnKh21SEcUtioF2JBzWR6DoensdN9w8WNMVvDTeQkPWFqtQ2Rva11iOHyQs8YuA6X9F7Uj1Z7u2Zfg9d+pjq3DsJPR48tKdiLh/mDGAmKD9gq6e4qdlWYdF3JUdr2xSUCTwqm6b+wp1XAT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771561; c=relaxed/simple;
	bh=y19mRIT2Lj3nrlpdd3KfMRu1+wNnKConr8ghTfw1354=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktV3gi/t1OMtqAQ9PhJe5Jip83vcujWEYddvfcGNnNho/dDrl4nGEsA55yAHZgNgWiog5IOHZIXowMLKa28OZB3i/4bb7AhO78LcqxMsdgzNnb21d6ist6knNn0OGwPNmPPUfJqXSs9oLVBVwunG29eS2jLkoGdJ8CQSVhglioU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AF1cwWea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AF1cwWea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E62C61042;
	Tue, 27 Aug 2024 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771561;
	bh=y19mRIT2Lj3nrlpdd3KfMRu1+wNnKConr8ghTfw1354=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AF1cwWea9p9pZEc+J3L6891sxfKlsalirb/8HcdPv3w+NyQXeG5U/8ZPmBEIgfZMI
	 Bv/zeulirubqBEX1bSCKtaBRW+mt/OlC8HnpWl9MheiAxVxk/7qD3n1f8gs7r98TxO
	 wqk1ime8JdPO3sikXFcuuifXQPDBV39RFAN1+vHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 225/273] ksmbd: the buffer of smb2 query dir response has at least 1 byte
Date: Tue, 27 Aug 2024 16:39:09 +0200
Message-ID: <20240827143841.968719369@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

commit ce61b605a00502c59311d0a4b1f58d62b48272d0 upstream.

When STATUS_NO_MORE_FILES status is set to smb2 query dir response,
->StructureSize is set to 9, which mean buffer has 1 byte.
This issue occurs because ->Buffer[1] in smb2_query_directory_rsp to
flex-array.

Fixes: eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4406,7 +4406,8 @@ int smb2_query_dir(struct ksmbd_work *wo
 		rsp->OutputBufferLength = cpu_to_le32(0);
 		rsp->Buffer[0] = 0;
 		rc = ksmbd_iov_pin_rsp(work, (void *)rsp,
-				       sizeof(struct smb2_query_directory_rsp));
+				       offsetof(struct smb2_query_directory_rsp, Buffer)
+				       + 1);
 		if (rc)
 			goto err_out;
 	} else {


