Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EA22192EC;
	Mon, 23 Jun 2025 22:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717282; cv=none; b=QLfmO3L12QSHnsQpQwp91ZYnDwLBoE+IXSWtbCMub3Y3WSgK+K84dUqwUUJS0dK6Sb64ewo2ne7n8Rc3O/D70TX0/QDY6s1RC1w8RN/R2GzUp5ix8vx51ZezH5NyUcJqd3Xzgo9cyNxzPP4plE/uyD/JltdSYO/++k2H5rqfdGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717282; c=relaxed/simple;
	bh=R83DXez0/BevVHHBAnJUScvQYbamP9INLpsRwC7o1Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDxRzAI2Kv5EjfvwJXiyVCrnsVlJRh8j1YylL7DstnF+5ZRaXk03WCIIF0oCH1a4RG8h7T6O9u0/YR6OO9YoQ8RXnJq6dJE1xLpAOaBYDa3S65Y5JytHypF739c6QQpLR/gEBrj1y9+6Qvw7FrM5CYMG9aXjgHFnNz9uhm1to9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUW74p2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUW74p2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF361C4CEED;
	Mon, 23 Jun 2025 22:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717282;
	bh=R83DXez0/BevVHHBAnJUScvQYbamP9INLpsRwC7o1Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUW74p2WBQ5FZFO1lmLTqo7x0ixfojbnMc2rMTPYGyBtBl5ku4xPk0knJ96ZmBpST
	 Uz6zLGk+NrJBxIxTcvFtwtSrEJWfWr/wPw9kBr11j/6ZBWQOhmWs+nnCmZxmqmkvjU
	 rIwwI26mlFbNWJQQN7JHXvIy4NpbM4x3Occ7I5ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	xfuren <xfuren@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 352/414] smb: fix secondary channel creation issue with kerberos by populating hostname when adding channels
Date: Mon, 23 Jun 2025 15:08:09 +0200
Message-ID: <20250623130650.774601200@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Bharath SM <bharathsm@microsoft.com>

commit 306cb65bb0cb243389fcbd0a66907d5bdea07d1e upstream.

When mounting a share with kerberos authentication with multichannel
support, share mounts correctly, but fails to create secondary
channels. This occurs because the hostname is not populated when
adding the channels. The hostname is necessary for the userspace
cifs.upcall program to retrieve the required credentials and pass
it back to kernel, without hostname secondary channels fails
establish.

Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reported-by: xfuren <xfuren@gmail.com>
Link: https://bugzilla.samba.org/show_bug.cgi?id=15824
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -526,8 +526,7 @@ cifs_ses_add_channel(struct cifs_ses *se
 	ctx->domainauto = ses->domainAuto;
 	ctx->domainname = ses->domainName;
 
-	/* no hostname for extra channels */
-	ctx->server_hostname = "";
+	ctx->server_hostname = ses->server->hostname;
 
 	ctx->username = ses->user_name;
 	ctx->password = ses->password;


