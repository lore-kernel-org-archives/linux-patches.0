Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716298837;
	Mon, 28 Oct 2024 06:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098332; cv=none; b=cnOYXSWpVJfM7McjY4Q1+p1Gk94twAH1rZ4HUuDyU8xuh6PzoDUXgxzQWYbsFNiDli9pP/By7Wv1v4k/URZ2zOrq05KHhdkYkm4U8JiFfnNGHCcxD3nx69PHdhPJJdTqHQf5M/Nn0jq+SeBD80gfnc2DkaI5okFUf2UcrN0Y70w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098332; c=relaxed/simple;
	bh=fODLZpMmttmYPCf8AhVs5HJpCUbn2uO9gIGq7htEQKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k+Ij57mUW0zefWMVq3nwPBK1peZcm5gFlUNgd0Z0SMjWsTUPFbJslWfPh2v3LxgRYY4ggMFYcZv1YFE/59EkyUGyWSfUuQf8hQqX+Nh2pgTT0+2jKoDWJYkfwVs5mGJ+NxZquTFEngnqtTZpkdDIQC3amomqNmGC5hOp9FHDfA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1ujzd7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1ujzd7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1D0C4CEC3;
	Mon, 28 Oct 2024 06:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098332;
	bh=fODLZpMmttmYPCf8AhVs5HJpCUbn2uO9gIGq7htEQKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1ujzd7timzRq/p0w/fmJi1G77OJiHrEsks0NU+Dtsq9fYtk3djjfz6pL5j/VupVM
	 oIXfhlDvPsen2EdRf1GFvv2IQPgMq2cqYyM3UnodBl3ik8QroTIC2SxrPHwhZ2eau4
	 6I5+tiYgmiHEYCZq+izS1IoyiiSi/K+n3GXMm/cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 134/261] cifs: Validate content of NFS reparse point buffer
Date: Mon, 28 Oct 2024 07:24:36 +0100
Message-ID: <20241028062315.401367597@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



