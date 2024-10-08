Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F541DE4CC;
	Tue,  8 Oct 2024 12:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391412; cv=none; b=KXpCySTILiqiGjZbs2IZk0mHGxsPN637CV5+2ehI17mivAnhkJRJ1GQSVaTYRzuq/907XHInIKvHUbZZDR7eTydtRZZ1HhBW9fUBBlPLoKNXpWUEYr6E3ArYaaTc4Rv1FmBNhiME/ppwjfpUJaKx+qUg74wNRXMclTjo6UmB/qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391412; c=relaxed/simple;
	bh=HdPjLOhquK225fDe9clDI6LfwMDYoQ+RY2vdNqzpBAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pqcpichrcAVapicIHSgWvvc5SIuMpnHqlgjzKjSjo6lQ5UoHy1Ek6rkHFkJwsLorRx4bq7vfe0a51jmRSvb5PUW8GNMz9JDqDCQyuQPf0Ae6d3UPzbUYvbAK7fDBLRj14LiZDSX41FpfRLX8hh6EYv62F6yRNG+MHpTQCgEGa28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGvi5GI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGvi5GI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACE6C4CEC7;
	Tue,  8 Oct 2024 12:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391412;
	bh=HdPjLOhquK225fDe9clDI6LfwMDYoQ+RY2vdNqzpBAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGvi5GI7YRbn0TP90n1wIUGQ6aXadPIGSkk5y/O9imTdtm20wnEjzM6Pw/nY7oDW2
	 7LCqG+k3HCnM99wJn7kdRgdurrXJLgqLs1/Z/vAiq5gYUWsr7ROKKeCBZlzUmF6KeN
	 HC2L13rfJg1eFRCJNiERERirE2dADVjPYlBxivD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 074/558] cifs: Fix buffer overflow when parsing NFS reparse points
Date: Tue,  8 Oct 2024 14:01:44 +0200
Message-ID: <20241008115705.129976654@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

[ Upstream commit e2a8910af01653c1c268984855629d71fb81f404 ]

ReparseDataLength is sum of the InodeType size and DataBuffer size.
So to get DataBuffer size it is needed to subtract InodeType's size from
ReparseDataLength.

Function cifs_strndup_from_utf16() is currentlly accessing buf->DataBuffer
at position after the end of the buffer because it does not subtract
InodeType size from the length. Fix this problem and correctly subtract
variable len.

Member InodeType is present only when reparse buffer is large enough. Check
for ReparseDataLength before accessing InodeType to prevent another invalid
memory access.

Major and minor rdev values are present also only when reparse buffer is
large enough. Check for reparse buffer size before calling reparse_mkdev().

Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 48c27581ec511..cfa03c166de8c 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -320,9 +320,16 @@ static int parse_reparse_posix(struct reparse_posix_data *buf,
 	unsigned int len;
 	u64 type;
 
+	len = le16_to_cpu(buf->ReparseDataLength);
+	if (len < sizeof(buf->InodeType)) {
+		cifs_dbg(VFS, "srv returned malformed nfs buffer\n");
+		return -EIO;
+	}
+
+	len -= sizeof(buf->InodeType);
+
 	switch ((type = le64_to_cpu(buf->InodeType))) {
 	case NFS_SPECFILE_LNK:
-		len = le16_to_cpu(buf->ReparseDataLength);
 		data->symlink_target = cifs_strndup_from_utf16(buf->DataBuffer,
 							       len, true,
 							       cifs_sb->local_nls);
@@ -482,12 +489,18 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	u32 tag = data->reparse.tag;
 
 	if (tag == IO_REPARSE_TAG_NFS && buf) {
+		if (le16_to_cpu(buf->ReparseDataLength) < sizeof(buf->InodeType))
+			return false;
 		switch (le64_to_cpu(buf->InodeType)) {
 		case NFS_SPECFILE_CHR:
+			if (le16_to_cpu(buf->ReparseDataLength) != sizeof(buf->InodeType) + 8)
+				return false;
 			fattr->cf_mode |= S_IFCHR;
 			fattr->cf_rdev = reparse_nfs_mkdev(buf);
 			break;
 		case NFS_SPECFILE_BLK:
+			if (le16_to_cpu(buf->ReparseDataLength) != sizeof(buf->InodeType) + 8)
+				return false;
 			fattr->cf_mode |= S_IFBLK;
 			fattr->cf_rdev = reparse_nfs_mkdev(buf);
 			break;
-- 
2.43.0



