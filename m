Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD717183CDB;
	Tue, 30 Jul 2024 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357498; cv=none; b=X1k/dc4Ikd/5QDC3/qiJ7PX74P4ko9qHfJ5MMv/jYXimSCLhO4ll6NT8s8dDJBoJxdQLFt0E/F6llMTP3RxgkwGYB2TH+ae0fw8lmk2dUuI+uFgjrODWVbXluxZSV0ycgxPLYZEGdHzXMBaoyBnLpwS2cK/Iba4/eQqw8HflPKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357498; c=relaxed/simple;
	bh=6JQwwHVNK9kvcJhQODhXsQK6Is2jnZ481j59kzoQVMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cl8L2zpkfGP5ouD0RVZJYwz6RDG2kDv0Yw5zOqa6rylfzmomrN8Eb8QX38y0GcfTvEP3hnRac/OmM8Wwl266hhdMwvJgTTwp8xHCuaZ3H5Om4M0uN46w4yZK+9NIfVNMNuQsrGSS1bbAnJ6kdyu7a40tXKCm6Csr5YPY5/cOMdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veQQNDKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veQQNDKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45591C4AF0E;
	Tue, 30 Jul 2024 16:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357498;
	bh=6JQwwHVNK9kvcJhQODhXsQK6Is2jnZ481j59kzoQVMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=veQQNDKldOhAEIJrk065SewynHSRqgpQl1S7yFg87T7LF51hS9v1HtBKr/1CI0y98
	 EfPFrXWh15tPT0o2aWOwnjebj72AJd78pKOUbzvsmxFECdB3AEc4iqXOSwhrfIyoSV
	 Xmxm5C4BVndVnj+dsREcRc5poEnjOicDZJp4gFYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowell@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 298/440] cifs: mount with "unix" mount option for SMB1 incorrectly handled
Date: Tue, 30 Jul 2024 17:48:51 +0200
Message-ID: <20240730151627.467521270@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 0e314e452687ce0ec5874e42cdb993a34325d3d2 upstream.

Although by default we negotiate CIFS Unix Extensions for SMB1 mounts to
Samba (and they work if the user does not specify "unix" or "posix" or
"linux" on mount), and we do properly handle when a user turns them off
with "nounix" mount parm.  But with the changes to the mount API we
broke cases where the user explicitly specifies the "unix" option (or
equivalently "linux" or "posix") on mount with vers=1.0 to Samba or other
servers which support the CIFS Unix Extensions.

 "mount error(95): Operation not supported"

and logged:

 "CIFS: VFS: Check vers= mount option. SMB3.11 disabled but required for POSIX extensions"

even though CIFS Unix Extensions are supported for vers=1.0  This patch fixes
the case where the user specifies both "unix" (or equivalently "posix" or
"linux") and "vers=1.0" on mount to a server which supports the
CIFS Unix Extensions.

Cc: stable@vger.kernel.org
Reviewed-by: David Howells <dhowell@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2592,6 +2592,13 @@ cifs_get_tcon(struct cifs_ses *ses, stru
 			cifs_dbg(VFS, "Server does not support mounting with posix SMB3.11 extensions\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
+		} else if (ses->server->vals->protocol_id == SMB10_PROT_ID)
+			if (cap_unix(ses))
+				cifs_dbg(FYI, "Unix Extensions requested on SMB1 mount\n");
+			else {
+				cifs_dbg(VFS, "SMB1 Unix Extensions not supported by server\n");
+				rc = -EOPNOTSUPP;
+				goto out_fail;
 		} else {
 			cifs_dbg(VFS, "Check vers= mount option. SMB3.11 "
 				"disabled but required for POSIX extensions\n");


