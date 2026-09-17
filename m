Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B7E4ED187;
	Thu, 17 Sep 2026 15:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660565; cv=none; b=n9EwMnhYKKWip21CDVk4ibSKwa+Q55UGol4A4/udQlvN1kraklIMNPRQkgU26DJIKVcAqX3gZolVSLxvYtRxt9jc4+AgTMCnxIxXd3FM2kPGUDgqU7fr3vPNTWe8QRphG2LfUq4Qr3ypciDNET4hT1cb4aDNEj5t0fl7rj0UyuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660565; c=relaxed/simple;
	bh=lHvV6GeSu7cnyMoHeCmZRyWhMD4WJL22q7zVMC47WUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqhIXL0Ah/6FJtO7p0foV8/OXWaOX2NeQ+srP0xqrDwuRx2wLMVZ94P137eqcRCXAdJWrvjCHHXKK81KFvoBd6a1UiiXZzNwM2mAliWSTYNYk0VzmhEq3ir1oAnW6LzDYcAZsffj7ZMftH7yy3QAwO9E48FP7VmcLuWG6z5+oqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vueWaeBD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vueWaeBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6AC1F000FF;
	Thu, 17 Sep 2026 15:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660564;
	bh=V9cObQvWUtheVHlCF/NUOjaWaTILMSvjl1ImTmya9NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vueWaeBDk346h8LwumfpztChF0sMpUi4e/fFhYrzb6dBZ7cLjpVCDtqS2KSpIGf7M
	 SicBdhh/c8xJItZj+paSaGb5u9rYl5pqdQc4w2hzPZP6GM9W4fSKOoomKPsYL5w314
	 2t0CLWo/UfAez9/+UsRjo+HKasgpti7r7oB7OHog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 635/733] smb: client: fix file type corruption in posix_reparse_to_fattr()
Date: Thu, 17 Sep 2026 16:15:43 +0100
Message-ID: <20260917151408.401655606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 65d5dbdc089be42fc48a6f77bc6b648307f34b17 upstream.

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFCHR == S_IFLNK).

Use a local ftype variable to collect the new file type and apply it
after validation succeeds, clearing S_IFMT and setting the new type in
a single assignment.  This avoids stripping cf_mode on malformed
reparse points where the function returns false early.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1212,6 +1212,7 @@ static bool posix_reparse_to_fattr(struc
 				   struct cifs_open_info_data *data)
 {
 	struct reparse_nfs_data_buffer *buf = (struct reparse_nfs_data_buffer *)data->reparse.buf;
+	umode_t ftype;
 
 	if (buf == NULL)
 		return true;
@@ -1227,7 +1228,7 @@ static bool posix_reparse_to_fattr(struc
 			WARN_ON_ONCE(1);
 			return false;
 		}
-		fattr->cf_mode |= S_IFCHR;
+		ftype = S_IFCHR;
 		fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 		break;
 	case NFS_SPECFILE_BLK:
@@ -1235,22 +1236,23 @@ static bool posix_reparse_to_fattr(struc
 			WARN_ON_ONCE(1);
 			return false;
 		}
-		fattr->cf_mode |= S_IFBLK;
+		ftype = S_IFBLK;
 		fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 		break;
 	case NFS_SPECFILE_FIFO:
-		fattr->cf_mode |= S_IFIFO;
+		ftype = S_IFIFO;
 		break;
 	case NFS_SPECFILE_SOCK:
-		fattr->cf_mode |= S_IFSOCK;
+		ftype = S_IFSOCK;
 		break;
 	case NFS_SPECFILE_LNK:
-		fattr->cf_mode |= S_IFLNK;
+		ftype = S_IFLNK;
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		return false;
 	}
+	fattr->cf_mode = (fattr->cf_mode & ~S_IFMT) | ftype;
 	return true;
 }
 


