Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEE32210E3;
	Thu, 12 Dec 2024 15:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018893; cv=none; b=KMTpGEZh+/48Ozokv1NbQjBtkDI/9LMWhOtYY9AWPqvkV+vdCpbbu3y1h3zIeSBPhTFP0y/RtKTSMak7ocoKlSzISBrLXX60jgpFZ9Jq5t+3KGdFPdOBQ8ytZgp8/dy0H4SFqImuY+2rsvvOto4pGSFROB1XrHfzMVk+M4SIp7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018893; c=relaxed/simple;
	bh=wDvI/2zqUDx0GvN/4P3K54RO83Q6Z49DeUdyFlFDhMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qz28j24eguyLVa9z2KXTC9f67VLM2jOXIzyGVSleQMlT1gmsTyRnCWdJV4xa2nnJzl7z/kN8vMQEAJmT/pV9tbQqnVxh0kwyaNslpy7QxvNUP3ab5HPan5OmArrGbhUdlecDcZ6sgXqUVzJmzpSLXtF+JttRNfmtMslE03ViJog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVYxO995; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVYxO995"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93830C4CECE;
	Thu, 12 Dec 2024 15:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018893;
	bh=wDvI/2zqUDx0GvN/4P3K54RO83Q6Z49DeUdyFlFDhMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVYxO995DpAdsce19qvLYVNbbCZzDKaFBzwNbjWSNaLy6OgzkBN2iEHd+bHh9vSZF
	 J+5LjMGYLcRjq+lENgecXpcOuq4LnyDZPYHyjJVd245UaBriiXjbt/OqkzFLjF8IGi
	 C5kR3Zmb/DlBmks7EMmYWO7vUVHRBSdTc55gh0yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Mahmoud Adam <mngyadam@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/772] cifs: Fix buffer overflow when parsing NFS reparse points
Date: Thu, 12 Dec 2024 15:49:38 +0100
Message-ID: <20241212144351.312907093@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

commit e2a8910af01653c1c268984855629d71fb81f404 upstream.

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
[use variable name symlink_buf, the other buf->InodeType accesses are
not used in current version so skip]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d1e5ff9a3cd39..fcfbc096924a8 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2897,6 +2897,12 @@ parse_reparse_posix(struct reparse_posix_data *symlink_buf,
 
 	/* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
 	len = le16_to_cpu(symlink_buf->ReparseDataLength);
+	if (len < sizeof(symlink_buf->InodeType)) {
+		cifs_dbg(VFS, "srv returned malformed nfs buffer\n");
+		return -EIO;
+	}
+
+	len -= sizeof(symlink_buf->InodeType);
 
 	if (le64_to_cpu(symlink_buf->InodeType) != NFS_SPECFILE_LNK) {
 		cifs_dbg(VFS, "%lld not a supported symlink type\n",
-- 
2.43.0



