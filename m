Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1530614F138;
	Tue, 23 Jul 2024 11:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721735542; cv=none; b=IpDTYt4UKAaovKfYP2NQyTPca6qpZk0Cc5LAKsMXiVbRcIqVpn0EdzegO45n5dNOP0aU0Si/W78PPicZavbQuqsPnRYKWSgU5nuejHOY/gajRFA91sJz11xdRQfHlCPdwU1Y81Ry5aYhw83XY7DyblRW3uBPwez42ow4PzpYD5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721735542; c=relaxed/simple;
	bh=loBTzAl6ZaDPBpOThZdo9odtvFkB7pTioDF5QEQUtcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/NuqiFr0aa/a+5mWGslkT53E6DNRad3LUXvubFplY4vNO7qeZPAuefnh0UOfxBlwdDTtvqAQb0eq0qzjIhyt0YuKL/QYbtV9WjOTFncl8SUEDkDnJ3CEVi3ZF41PIET/JbmHI7tr+5Zld/oWcl25OUVDmSFFRrViE11c3DLZ0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4qDRLcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4qDRLcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FC2C4AF09;
	Tue, 23 Jul 2024 11:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721735541;
	bh=loBTzAl6ZaDPBpOThZdo9odtvFkB7pTioDF5QEQUtcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4qDRLcD1XXbxacwf5pUxLT/nq/+3lzZDI/Z8yGpevVjlzu0Wm4O8azK56FmCLGml
	 Vvn4LuJ3AvE49wIu0eTR5GVkT0DnZeILJoT9GICqjqc2ThKudTcm4JHpQf+Ey1oObc
	 +6189YZlCGa2ZN1ITKj7Jv0ENUhJbu3wSWfvzfF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 4/9] cifs: fix noisy message on copy_file_range
Date: Tue, 23 Jul 2024 13:51:58 +0200
Message-ID: <20240723114047.443482253@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723114047.281580960@linuxfoundation.org>
References: <20240723114047.281580960@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit ae4ccca47195332c69176b8615c5ee17efd30c46 upstream.

There are common cases where copy_file_range can noisily
log "source and target of copy not on same server"
e.g. the mv command across mounts to two different server's shares.
Change this to informational rather than logging as an error.

A followon patch will add dynamic trace points e.g. for
cifs_file_copychunk_range

Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1359,7 +1359,7 @@ ssize_t cifs_file_copychunk_range(unsign
 	target_tcon = tlink_tcon(smb_file_target->tlink);
 
 	if (src_tcon->ses != target_tcon->ses) {
-		cifs_dbg(VFS, "source and target of copy not on same server\n");
+		cifs_dbg(FYI, "source and target of copy not on same server\n");
 		goto out;
 	}
 


