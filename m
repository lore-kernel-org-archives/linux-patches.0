Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81093158215;
	Tue, 23 Jul 2024 18:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759415; cv=none; b=CVhlHtA0JJZxY1ss0Q4/OFgRRK9fVI/QOAczD6QZKlFNui+WpZrsuVUAgTJMT2MgPk6auR1jpYK3nBP7tIII7q5FACsaNOQX4FEht3c4aaHRo37ZQuVVgIhVeYV9LcZSWaOEMxXbuf8pQhaM+8J/zn4MkXJnqYf5dGGTGluydv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759415; c=relaxed/simple;
	bh=2vVNVK/gkweRWimQm947hgccmthPABL2PR+H7IUJntE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE9lHjQ/TWGaOFKbzE29xFb9S+vsXyvExzVeFg/UU6u8Io2ohq5htEqLX4b9fMYeMys0xDBLXp/NYZ1X+c0QgqM+jO/+E+2uQ/zOYimblMBd22nJljhK83yfkwNPdoSZtC5oHSmfGEXcn/luqpi1hoQxsyrNmz3yP5ieXklXMbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGponjVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGponjVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC14C4AF09;
	Tue, 23 Jul 2024 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759415;
	bh=2vVNVK/gkweRWimQm947hgccmthPABL2PR+H7IUJntE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGponjVMYL7M7a2h3hZRgJEosBjN0LHhbV6Q4QlDdJZEZoKat35qY3yvCpC+dzv9g
	 rgRc/451PxXYxjLHF32FD+B2/ZXDv5p/+ewfnI6MPu1r3uvqMavuutwnUtJuhZFJWJ
	 fA06h8AjwZ7F3LLlQKi2yIKBmi0BPhK68A2UGC0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 097/105] cifs: fix noisy message on copy_file_range
Date: Tue, 23 Jul 2024 20:24:14 +0200
Message-ID: <20240723180406.982857640@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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
@@ -1397,7 +1397,7 @@ ssize_t cifs_file_copychunk_range(unsign
 	target_tcon = tlink_tcon(smb_file_target->tlink);
 
 	if (src_tcon->ses != target_tcon->ses) {
-		cifs_dbg(VFS, "source and target of copy not on same server\n");
+		cifs_dbg(FYI, "source and target of copy not on same server\n");
 		goto out;
 	}
 


