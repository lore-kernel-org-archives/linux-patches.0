Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C79A27701;
	Mon, 24 Feb 2025 14:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408765; cv=none; b=WCgBU29ZS2o0pRWoHMMEzur12xlWjaHK2qswlcY3UesSHsb59CrxkLwVJ+0+Tdqs5Djq2hVJn2iCw/UF+td5V3E7Dz+qkFLLNT0HvumwwTa9XCUruUCuNdDVBGxEZUXgitdumZ+TNt8sb1kLipsqSTHep2ZhSI70SjlrCekukNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408765; c=relaxed/simple;
	bh=/h3YdYjTco52b16FBC375zgpccEM3Qkz5eheT7nLPcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Reev9XEko6rNSl6IwcFcc3bpFaydqOAEz5xk4CMrrwF4eIjnTmE9qbxypSu4QULtpJ6WmxVQuspYuaUTUt0nP+E+A12ao4Gr3YytPvDyw91NGKMtZJjj0ReOTkY5AXMSCTd08WqLzKk0nE6MUmasq0bULrV7fqTTTDAz622jxKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKFrR8MQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKFrR8MQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BF1C4CED6;
	Mon, 24 Feb 2025 14:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408765;
	bh=/h3YdYjTco52b16FBC375zgpccEM3Qkz5eheT7nLPcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKFrR8MQeg7r01Hie7a5H0rzVKPCPrmOv8b8wVKZATo5eKxywQfnfgHrwWwy7ZFkH
	 NIYaBUmwN6kQNZc4fTKglBpMaLcw/6eitbGFY22Oka8Yk3D3b/qlV5WPNS1dzV00Jc
	 O2bUO1LynZkFQXeBQpnr5m5blq0WfBCtJhOqZY7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horst Reiterer <horst.reiterer@fabasoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 126/154] smb: client: fix chmod(2) regression with ATTR_READONLY
Date: Mon, 24 Feb 2025 15:35:25 +0100
Message-ID: <20250224142611.985559560@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 654292a0b264e9b8c51b98394146218a21612aa1 upstream.

When the user sets a file or directory as read-only (e.g. ~S_IWUGO),
the client will set the ATTR_READONLY attribute by sending an
SMB2_SET_INFO request to the server in cifs_setattr_{,nounix}(), but
cifsInodeInfo::cifsAttrs will be left unchanged as the client will
only update the new file attributes in the next call to
{smb311_posix,cifs}_get_inode_info() with the new metadata filled in
@data parameter.

Commit a18280e7fdea ("smb: cilent: set reparse mount points as
automounts") mistakenly removed the @data NULL check when calling
is_inode_cache_good(), which broke the above case as the new
ATTR_READONLY attribute would end up not being updated on files with a
read lease.

Fix this by updating the inode whenever we have cached metadata in
@data parameter.

Reported-by: Horst Reiterer <horst.reiterer@fabasoft.com>
Closes: https://lore.kernel.org/r/85a16504e09147a195ac0aac1c801280@fabasoft.com
Fixes: a18280e7fdea ("smb: cilent: set reparse mount points as automounts")
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1381,7 +1381,7 @@ int cifs_get_inode_info(struct inode **i
 	struct cifs_fattr fattr = {};
 	int rc;
 
-	if (is_inode_cache_good(*inode)) {
+	if (!data && is_inode_cache_good(*inode)) {
 		cifs_dbg(FYI, "No need to revalidate cached inode sizes\n");
 		return 0;
 	}
@@ -1480,7 +1480,7 @@ int smb311_posix_get_inode_info(struct i
 	struct cifs_fattr fattr = {};
 	int rc;
 
-	if (is_inode_cache_good(*inode)) {
+	if (!data && is_inode_cache_good(*inode)) {
 		cifs_dbg(FYI, "No need to revalidate cached inode sizes\n");
 		return 0;
 	}


