Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7BA44331B;
	Thu, 30 Jul 2026 15:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424904; cv=none; b=R9uK/Lq5sHxeYXjmBTyxxAX2OTgbPeoltuH14TjFnYZ46TeZAc+GWGy3EATFuS/0Ec35Nq2GTf+EbPY3KIelIR4M3d3WGcleI2OvviVLY9/cx8WSqeJ+hZP96qSg7v1oQVr45O44VOPWAS631LRinA7iSqichOBxAzlNvwqJ1TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424904; c=relaxed/simple;
	bh=Dnre8HVa9kbGIJViOpm9Q0bcDNrZ08dni7VwzQJwuZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSCjCRULXqTc7o2C/f5gtyKVChDa7FJuvXxQFPouEBoed9CJawWbewK+Upo6tIiZQ+dPF9kN+w73pMrtFbP1tJ7m/srERQcrVFIYsUqDai45Qab8mFFgtSzcihyAad0Ov77/q3h6yaYqdbCnrPkVe/7P4ipuqdyNHPi0fwvyyT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFPrB1Kc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFPrB1Kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA931F000E9;
	Thu, 30 Jul 2026 15:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424903;
	bh=MzWSR3NtF6t/aF8+mqUI4lpFtSHWfwBPR4+NfKswFR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFPrB1KcHE2e2O01IFbiqS3PJUzmP850fLuTeedYG+74pYXn/C//u3QWZMQv+JbHm
	 4PfvjpNt99H38WvsJTzXMmg4B2ccehnA45DhrMyZIrpH1pRxrJZNPnyK8KdqMwtsh0
	 G195Wi92vskMoY0a9eGgAltx6WUB7GAXEBFzy9uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Carl Johnson <carl@jpartners.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 550/675] smb: client: handle STATUS_STOPPED_ON_SYMLINK responses without a symlink target
Date: Thu, 30 Jul 2026 16:14:40 +0200
Message-ID: <20260730141456.830087069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carl Johnson <carl@jpartners.org>

commit 2eb74eef4b7eda8df593d22fb48e94ef959ec8a5 upstream.

The macOS built-in SMB server returns STATUS_STOPPED_ON_SYMLINK for a
CREATE on a path whose final component is a symlink, but it does not
include a Symbolic Link Error Response in the error data: both
ErrorContextCount and ByteCount are zero, so the symlink target is not
present in the response at all.  Per [MS-SMB2] section 2.2.2 such a
response should carry a valid Symbolic Link Error Response, so this is a
server bug, but the target can still be retrieved with
FSCTL_GET_REPARSE_POINT.

Frame from a capture against macOS 26.5.2 (build 25F84):

    SMB2 hdr : Status=0x8000002d STATUS_STOPPED_ON_SYMLINK, Cmd=Create
    Error Rsp: StructureSize=0x0009
               Error Context Count: 0
               Byte Count: 0
               Error Data: 00

symlink_data() cannot find a struct smb2_symlink_err_rsp in such a
response and returns -EINVAL, which parse_create_response() propagates,
so smb2_query_path_info() bails out at

	if (rc || !data->reparse_point)
		goto out;

before it can retry with SMB2_OP_GET_REPARSE.  stat(), readlink() and ls
of any server-side symlink then fail with -EINVAL:

  $ ls -la Config
  l????????? ? ? ? ? ? Config.json
  $ stat Config/Config.json
  stat: cannot statx 'Config/Config.json': Invalid argument

A 5.10 client resolves these symlinks correctly against the same server
and share, so this is a regression for Apple SMB servers.

Handle it in several places:

 - symlink_data() detects the empty response (ErrorContextCount and
   ByteCount both zero) and returns a distinct -ENODATA, so that "server
   did not send the target" can be told apart from a genuinely malformed
   response and only this case is worked around.

 - parse_create_response() treats -ENODATA like
   STATUS_IO_REPARSE_TAG_NOT_HANDLED, which does not carry the target
   either: leave the reparse tag unset and clear rc, so the existing
   SMB2_OP_GET_REPARSE path retrieves the target.

 - smb2_query_path_info() only fixes up the symlink target type when the
   target is already known.  SMB2_OP_GET_REPARSE sets data->reparse.tag
   but does not parse the target out of the reparse buffer; that happens
   later, in reparse_info_to_fattr().  Without this check
   smb2_fix_symlink_target_type() is called with a NULL target and
   returns -EIO.  This could not happen with servers that send the target
   inline and therefore skip SMB2_OP_GET_REPARSE.

 - smb2_open_file() maps -ENODATA to -EIO, matching
   STATUS_IO_REPARSE_TAG_NOT_HANDLED, so its callers retrieve the target
   with SMB2_OP_GET_REPARSE as well.

Tested on Debian 13, kernel 6.18.38 (armv7), against macOS 26.5.2:
symlinks now resolve, including relative, parent-traversing and directory
symlinks, and reads through symlinks succeed.

Cc: stable@vger.kernel.org
Co-developed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Carl Johnson <carl@jpartners.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2file.c  |   21 +++++++++++++++++++++
 fs/smb/client/smb2inode.c |   23 ++++++++++++++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -30,6 +30,19 @@ static struct smb2_symlink_err_rsp *syml
 	u8 *end = (u8 *)err + iov->iov_len;
 	u32 len;
 
+	/*
+	 * Per [MS-SMB2] section 2.2.2, a STATUS_STOPPED_ON_SYMLINK response has to
+	 * carry a Symbolic Link Error Response, so ByteCount cannot be zero.  Some
+	 * servers (e.g. the macOS built-in SMB server) violate this and return an
+	 * empty error response, with both ErrorContextCount and ByteCount set to
+	 * zero, i.e. without the symlink target.  Detect this and return -ENODATA
+	 * so that callers can tell "server did not send the target" apart from a
+	 * malformed response, and retrieve the target with FSCTL_GET_REPARSE_POINT
+	 * instead.
+	 */
+	if (!err->ErrorContextCount && !le32_to_cpu(err->ByteCount))
+		return ERR_PTR(-ENODATA);
+
 	if (err->ErrorContextCount) {
 		struct smb2_error_context_rsp *p;
 
@@ -200,6 +213,14 @@ int smb2_open_file(const unsigned int xi
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
 							 oparms->path,
 							 &data->symlink_target);
+			/*
+			 * If smb2_parse_symlink_response returned -ENODATA then the
+			 * symlink_target was not sent. Treat this as if the SMB2_open()
+			 * failed with STATUS_IO_REPARSE_TAG_NOT_HANDLED status, which is
+			 * indicated by the -EIO errno.
+			 */
+			if (rc == -ENODATA)
+				rc = -EIO;
 			if (!rc) {
 				memset(smb2_data, 0, sizeof(*smb2_data));
 				oparms->create_options |= OPEN_REPARSE_POINT;
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -896,9 +896,19 @@ static int parse_create_response(struct
 		rc = smb2_parse_symlink_response(cifs_sb, iov,
 						 full_path,
 						 &data->symlink_target);
-		if (rc)
+		if (rc != 0 && rc != -ENODATA)
 			return rc;
-		tag = IO_REPARSE_TAG_SYMLINK;
+		/*
+		 * -ENODATA means that the response was parsed but did not contain
+		 * the symlink target at all (see symlink_data()).  Treat it like
+		 * STATUS_IO_REPARSE_TAG_NOT_HANDLED, which does not contain it
+		 * either: leave the tag unset and clear rc, so that the caller
+		 * retrieves the target with SMB2_OP_GET_REPARSE.
+		 */
+		if (rc == -ENODATA)
+			rc = 0;
+		else
+			tag = IO_REPARSE_TAG_SYMLINK;
 		reparse_point = true;
 		break;
 	case STATUS_SUCCESS:
@@ -1091,7 +1101,14 @@ int smb2_query_path_info(const unsigned
 				rc = -EOPNOTSUPP;
 		}
 
-		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
+		/*
+		 * If the symlink was already parsed in create response then it is needed to fix
+		 * its type now (after the second call with OPEN_REPARSE_POINT which filled the
+		 * data->fi.Attributes). If the symlink was not parsed in create response then
+		 * the data->symlink_target was not filled yet and then the type will be fixed
+		 * later after data->symlink_target is filled.
+		 */
+		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc && data->symlink_target) {
 			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
 			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
 		}


