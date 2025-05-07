Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB631FF5EC;
	Wed,  7 May 2025 18:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643870; cv=none; b=DFNlm52+HOMor1ldJwja/0zBKCsEPwC3AmPfJUpXXODfXr6900KyoXeEOXt612degvZqf6DmHWme5e+m9dzfvjktK6VQW8eJdo1X61A60xurI1SwMyLpGsQTBWRoDv0sAf00iFe5OBE5qS3AwWOzxoeFfQQe+8bTnEG2dcAk2F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643870; c=relaxed/simple;
	bh=SASuT1U3xMsatLMwdPVEk+xgnyzrACHLLRcjbkxgnOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abMljhxs2SHgieNuNg+9c5gnlUlaD9c0yPWXhgDjkIsveoJYfL8dL+cd5qKT3UOTSZoHfRjkc8uGcttP51S75p7Y5kU3x/mxhuQ6iuYnd2lLGi6a+iV6FDkbVc6gXygwMfXccdPpA61Sxw3W48pxlzew4W3MMTYOwYOwdYE7bWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwgSoDbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwgSoDbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0BCC4CEEB;
	Wed,  7 May 2025 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643869;
	bh=SASuT1U3xMsatLMwdPVEk+xgnyzrACHLLRcjbkxgnOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwgSoDbHp/VCRWIwUwRZ7zIhz5Hd5BKnFMaFkxxuJX13xTvh10dDRatwXHuvuSoo7
	 DncKlpn3Bp6BbnfxuzijiNLPNr8dzDTdVl+8DGF2+D8GGTfLkfOOF1KM63h+2jIWF2
	 XZGvMcFXoqeuD323Y/zzC9rSVdPxPSovZzFxKZXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jethro Donaldson <devel@jro.nz>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 043/183] smb: client: fix zero length for mkdir POSIX create context
Date: Wed,  7 May 2025 20:38:08 +0200
Message-ID: <20250507183826.437919980@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jethro Donaldson <devel@jro.nz>

commit 74c72419ec8da5cbc9c49410d3c44bb954538bdd upstream.

SMB create requests issued via smb311_posix_mkdir() have an incorrect
length of zero bytes for the POSIX create context data. ksmbd server
rejects such requests and logs "cli req too short" causing mkdir to fail
with "invalid argument" on the client side.  It also causes subsequent
rmmod to crash in cifs_destroy_request_bufs()

Inspection of packets sent by cifs.ko using wireshark show valid data for
the SMB2_POSIX_CREATE_CONTEXT is appended with the correct offset, but
with an incorrect length of zero bytes. Fails with ksmbd+cifs.ko only as
Windows server/client does not use POSIX extensions.

Fix smb311_posix_mkdir() to set req->CreateContextsLength as part of
appending the POSIX creation context to the request.

Signed-off-by: Jethro Donaldson <devel@jro.nz>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2920,6 +2920,7 @@ replay_again:
 		req->CreateContextsOffset = cpu_to_le32(
 			sizeof(struct smb2_create_req) +
 			iov[1].iov_len);
+		le32_add_cpu(&req->CreateContextsLength, iov[n_iov-1].iov_len);
 		pc_buf = iov[n_iov-1].iov_base;
 	}
 


