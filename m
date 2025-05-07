Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1711E22E9;
	Wed,  7 May 2025 19:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644899; cv=none; b=jlq1senj5+zypLIXtKCcZwIUyz0Yz/1GTMciPZ8dRGOuEckgCRshdyLCMzAeVQ+K5FuvIkBFahMP5RpBOfL450bctA93IJzQmuxFiBqGn6OvWCu36qdSsBdMIkZH4PXmUzqOxXp/5STZxF5/z8Pe4Y8hneVWPaiOT84tPfiQfCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644899; c=relaxed/simple;
	bh=3SK/jtf/zwgmqIo6scVF8M31VOZ+urbHIzKCNTVBd3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFSeI3F7dSahtHSmpgFIS6ny2nVD1HUg0AvX4xvb5FY1WeN2VgNMYsmBVEdA7u+om6atQBNZcPeeFOnN/87IBKJ0gG3dSHuYJqgOPqTDmzqWGL/ihOwhhJUhiWumbEX9iTJ6+n7o/hLzAFuuoYStClcgyBf4bitcQJljq9sAqGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6b9oq57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6b9oq57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A93C4CEE2;
	Wed,  7 May 2025 19:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644899;
	bh=3SK/jtf/zwgmqIo6scVF8M31VOZ+urbHIzKCNTVBd3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6b9oq57dHSXYdFryQOtQlt/lt/FH9jDnhhgEf5tynV2tOEH7BAkI2IuOAM+O0qCI
	 bi1Po760x/rjWVGQ2d52WaoJs0/sujgQ8ci+Exh2oqw8RpKeRGeULbRL+tlJ1H+pyw
	 JQLVUHHLFlAUcwd0KQ77NguDVTcgeN8/15kL62sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jethro Donaldson <devel@jro.nz>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 029/129] smb: client: fix zero length for mkdir POSIX create context
Date: Wed,  7 May 2025 20:39:25 +0200
Message-ID: <20250507183814.708888097@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2932,6 +2932,7 @@ replay_again:
 		req->CreateContextsOffset = cpu_to_le32(
 			sizeof(struct smb2_create_req) +
 			iov[1].iov_len);
+		le32_add_cpu(&req->CreateContextsLength, iov[n_iov-1].iov_len);
 		pc_buf = iov[n_iov-1].iov_base;
 	}
 


