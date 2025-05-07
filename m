Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCADF28C024;
	Wed,  7 May 2025 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644451; cv=none; b=GqvTFUX20a6yhILE6vWuotFuTeTQtl7N7Cw+Yc9reU7z8h1Qmf91nWyRrMYezu3QBOwaKy4pfOpkPofQqm5VvoiuI4DLgi4NbcmiWrzLa1YHjoE7zUO+Qrs8I7kC2D2mbzHsyQsOwSwgdb2SQyYSbdsPdoJ9flCXM+DMnf7N02k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644451; c=relaxed/simple;
	bh=M/12NhyTffxYmWzqr4kuj8mznLwl5tuA449y70eFf8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pR+nusS4C3nF54hzUHBrNzFUY7X4qLmyvfDUGCgk9V0CExbD0mQ3SeG07T0vxz52349HyDiN1J9/3Q5ldM20oHmY5V6N1TU3qO2IotbS4LyX9vZ2jra/3M9kbh/Z0fGrByxSd+23c2mfnCObwSrtIJiZnHW1L95XEPQexiEO2dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppRry1nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppRry1nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC746C4CEE2;
	Wed,  7 May 2025 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644451;
	bh=M/12NhyTffxYmWzqr4kuj8mznLwl5tuA449y70eFf8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppRry1njcufYzvw5gVnYgWaqKKmVQFU1kX052rI1bJ92FDL2QEVnDNtUlQ9fI5zJz
	 8AoSc4/DgEdqZIdwrSKeR70x5PQK7rYMr0D554Wmdlhk+NSJ+bzjG2WjNBeDyrYGnh
	 buGRB4MB6QWSqK2RVP6iTksDTfhFamUZgPv9usZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jethro Donaldson <devel@jro.nz>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 047/164] smb: client: fix zero length for mkdir POSIX create context
Date: Wed,  7 May 2025 20:38:52 +0200
Message-ID: <20250507183822.786353644@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2938,6 +2938,7 @@ replay_again:
 		req->CreateContextsOffset = cpu_to_le32(
 			sizeof(struct smb2_create_req) +
 			iov[1].iov_len);
+		le32_add_cpu(&req->CreateContextsLength, iov[n_iov-1].iov_len);
 		pc_buf = iov[n_iov-1].iov_base;
 	}
 


