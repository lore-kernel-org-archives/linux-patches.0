Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC931428E9;
	Thu, 13 Jun 2024 11:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279623; cv=none; b=O64PemsREV79XOAmGxgrwe8Oel33tkmZOCUBYszICpXF682vCqkw5wgSLpbFFMALkFgove1UpwrJDg4XoURLXCye/NykSgsWcR0MT7dOHvNsFGf+YHNVVReQ4PJaMfnYi45LfNY1WEfOCc4UdvJAGlyVnr6bjYTNCqX0kYk1gGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279623; c=relaxed/simple;
	bh=pWhYWekmSgoyWwuryQVdULOJVSxt7YJyIMnMmA3a0rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+9zIM3vZxfdES8RHGJTZW5XbD11zMTfFm8L69i+x74E91nnZkIZr6mYfry3ZLZbf1VtAfo/I7cfn0xmYkJ9qfZ3jmYy2mtV7ifIgQbD/puIaA0JJyv3gvtlCXGHvdjedCkR+c7qsuS8RESwZD3FHWQCFw3IKRWDEWQKIABwvfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbSmnZvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbSmnZvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BE1C2BBFC;
	Thu, 13 Jun 2024 11:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279622;
	bh=pWhYWekmSgoyWwuryQVdULOJVSxt7YJyIMnMmA3a0rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbSmnZvm00U97jVQvd7en2B0Pr09L6Rzn10MiPqk5qw3YVXx1xK8Ctdc3CLOupq5X
	 hHLIJSSKgeKugKLzJtqkCBEPYnJXW2r9T3iXJsrB+rI8U+IokOIX/TNeKhJ17J8PMN
	 TPuBbrHy6PILvx1IbDNQKYvkA+ZEgevFT2jbqsss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.9 139/157] cifs: fix creating sockets when using sfu mount options
Date: Thu, 13 Jun 2024 13:34:24 +0200
Message-ID: <20240613113232.780922597@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 518549c120e671c4906f77d1802b97e9b23f673a upstream.

When running fstest generic/423 with sfu mount option, it
was being skipped due to inability to create sockets:

  generic/423  [not run] cifs does not support mknod/mkfifo

which can also be easily reproduced with their af_unix tool:

  ./src/af_unix /mnt1/socket-two bind: Operation not permitted

Fix sfu mount option to allow creating and reporting sockets.

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifspdu.h |    2 +-
 fs/smb/client/inode.c   |    4 ++++
 fs/smb/client/smb2ops.c |    3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2574,7 +2574,7 @@ typedef struct {
 
 
 struct win_dev {
-	unsigned char type[8]; /* IntxCHR or IntxBLK or LnxFIFO*/
+	unsigned char type[8]; /* IntxCHR or IntxBLK or LnxFIFO or LnxSOCK */
 	__le64 major;
 	__le64 minor;
 } __attribute__((packed));
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -591,6 +591,10 @@ cifs_sfu_type(struct cifs_fattr *fattr,
 				mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
 				fattr->cf_rdev = MKDEV(mjr, mnr);
 			}
+		} else if (memcmp("LnxSOCK", pbuf, 8) == 0) {
+			cifs_dbg(FYI, "Socket\n");
+			fattr->cf_mode |= S_IFSOCK;
+			fattr->cf_dtype = DT_SOCK;
 		} else if (memcmp("IntxLNK", pbuf, 7) == 0) {
 			cifs_dbg(FYI, "Symlink\n");
 			fattr->cf_mode |= S_IFLNK;
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4996,6 +4996,9 @@ static int __cifs_sfu_make_node(unsigned
 		pdev.major = cpu_to_le64(MAJOR(dev));
 		pdev.minor = cpu_to_le64(MINOR(dev));
 		break;
+	case S_IFSOCK:
+		strscpy(pdev.type, "LnxSOCK");
+		break;
 	case S_IFIFO:
 		strscpy(pdev.type, "LnxFIFO");
 		break;


