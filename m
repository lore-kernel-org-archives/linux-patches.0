Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368A418E35B;
	Mon, 28 Oct 2024 06:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097737; cv=none; b=deyB7MzLzN4hWRSwGPsJt5sgWuxpxbh9Gm5Atsk0wCr/v8CgynY8eMm0+9E8NdN+KJKQiohZAn0Q5rJv5MTCSQARfT8ZXUG4xnxcQrXEcokK/PWTbY4TixcXTlW8C6jVhvNxakftJ4zOGMszbvs94uDSYBk1l3x63BkcqglSsLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097737; c=relaxed/simple;
	bh=uPMIAKQRYG+QBxoqw4WMMnKN0iSfV6gkB3cJ7sea2Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cK0UL4xM5hy+vFkLpblMalCuNtQkL2sGDkvpOacboZFXk7VOqA9cA/0G3ByyDTM02t0y3c5O9Kjv+hLXxKqhI5Wao2YdfvQvZ3/Df9F7pTddGgPCA0bgxzVYuIMqc32F3dawSLeHZUSHlQM/WFVOwYBWbVbfHHEyngKDyDNtVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L58AJur4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L58AJur4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A95DC4CEC3;
	Mon, 28 Oct 2024 06:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097736;
	bh=uPMIAKQRYG+QBxoqw4WMMnKN0iSfV6gkB3cJ7sea2Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L58AJur4JG622hpDjHtm5DhUy5JLuOmU2CqU/y6Nu4E8rCy4HMG2UYB/XSnvej+xF
	 pDr/qPk1a6twQm9kB+3JwefTA8rnRUrEdat3CXMXusCkhr786VXiCE0PsQ9S/EtDno
	 oeLQBIVt1IZ+f5Ni7b72UdnPqmryToOE/TII9we8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/208] cifs: Validate content of NFS reparse point buffer
Date: Mon, 28 Oct 2024 07:25:05 +0100
Message-ID: <20241028062309.722982486@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 556ac52bb1e76cc28fd30aa117b42989965b3efd ]

Symlink target location stored in DataBuffer is encoded in UTF-16. So check
that symlink DataBuffer length is non-zero and even number. And check that
DataBuffer does not contain UTF-16 null codepoint because Linux cannot
process symlink with null byte.

DataBuffer for char and block devices is 8 bytes long as it contains two
32-bit numbers (major and minor). Add check for this.

DataBuffer buffer for sockets and fifos zero-length. Add checks for this.

Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index ad0e0de9a165d..7429b96a6ae5e 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -330,6 +330,18 @@ static int parse_reparse_posix(struct reparse_posix_data *buf,
 
 	switch ((type = le64_to_cpu(buf->InodeType))) {
 	case NFS_SPECFILE_LNK:
+		if (len == 0 || (len % 2)) {
+			cifs_dbg(VFS, "srv returned malformed nfs symlink buffer\n");
+			return -EIO;
+		}
+		/*
+		 * Check that buffer does not contain UTF-16 null codepoint
+		 * because Linux cannot process symlink with null byte.
+		 */
+		if (UniStrnlen((wchar_t *)buf->DataBuffer, len/2) != len/2) {
+			cifs_dbg(VFS, "srv returned null byte in nfs symlink target location\n");
+			return -EIO;
+		}
 		data->symlink_target = cifs_strndup_from_utf16(buf->DataBuffer,
 							       len, true,
 							       cifs_sb->local_nls);
@@ -340,8 +352,19 @@ static int parse_reparse_posix(struct reparse_posix_data *buf,
 		break;
 	case NFS_SPECFILE_CHR:
 	case NFS_SPECFILE_BLK:
+		/* DataBuffer for block and char devices contains two 32-bit numbers */
+		if (len != 8) {
+			cifs_dbg(VFS, "srv returned malformed nfs buffer for type: 0x%llx\n", type);
+			return -EIO;
+		}
+		break;
 	case NFS_SPECFILE_FIFO:
 	case NFS_SPECFILE_SOCK:
+		/* DataBuffer for fifos and sockets is empty */
+		if (len != 0) {
+			cifs_dbg(VFS, "srv returned malformed nfs buffer for type: 0x%llx\n", type);
+			return -EIO;
+		}
 		break;
 	default:
 		cifs_dbg(VFS, "%s: unhandled inode type: 0x%llx\n",
-- 
2.43.0



