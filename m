Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441681A76BC;
	Tue, 30 Jul 2024 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360070; cv=none; b=CYm03dZ8Q8yAnAPQGW1r3+QfuBe557ZmHJ1Zkz9ZQq7d25n5tlMAISyU6jO5CehRlj/Odt4Mdw2JqWwnDwXc+pxy+B5cBl0TEZDJA0nY07oxJUGYICZ8TQmICaomRr05kFlX8fZ+epjNK+wXGWXUxT+urBs+1nBbidgSdyKI3bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360070; c=relaxed/simple;
	bh=Sso6/lc+sc6aARTAtSnjVAWFaxMRpsXhuh/NP7Y80+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRzi5TFaRklMhEG84sUnFzjNoI5KQE24I369y0t6mK9EzRXPL2QPFCKj/Cc7kBl1bYNDKSGNjeMyHcgCHhB95IHgTr5Cekqm6Kk5X/+70e1nsjv6sYpTgJlL5iDYwUnjbHNZUzLzKvAyMls8X1drIS+I+XDNfswS0rck+FVX6Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxeTWrGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxeTWrGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8642C32782;
	Tue, 30 Jul 2024 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360070;
	bh=Sso6/lc+sc6aARTAtSnjVAWFaxMRpsXhuh/NP7Y80+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxeTWrGcqf37Gn4ZCMi3LuHyRBy7W+m5UNrJeiQJI8Z/hg1b0DHOr49qa471snAYZ
	 bL34Q0f0SwUCrvq5lRzRDesLlspeU7dHYol3pmmk7HhuwJ8waPCgMK3sGy5/AYSfF1
	 Fes+hy3BEO6MjxCvSTuC2SByaB54bHIXBu8Ig5kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowell@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 586/809] cifs: mount with "unix" mount option for SMB1 incorrectly handled
Date: Tue, 30 Jul 2024 17:47:42 +0200
Message-ID: <20240730151747.975057032@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
@@ -2614,6 +2614,13 @@ cifs_get_tcon(struct cifs_ses *ses, stru
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
 			cifs_dbg(VFS,
 				"Check vers= mount option. SMB3.11 disabled but required for POSIX extensions\n");


