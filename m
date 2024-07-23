Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B3A158211;
	Tue, 23 Jul 2024 18:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759820; cv=none; b=Jc0hJDicNfD5MSnyzDHV6GEe2sFRziHKjgeKQwpuM34+LWW+Ofnj4sbwM186jEDfEski9D6g1Z8xKpIouI97Xq/db8kITK8w/zkVqxGSzWzrkoyM57i86vvwRlaqeJo/YoR9X0v6QWKSNDPmX+xG1MT75ijPgsichWj3rmiryXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759820; c=relaxed/simple;
	bh=KRiGaO3BtOU3MUtky8F05Z6LKP48wKjsjrjNhE2JsFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCv+Pc1gLQdou/4VfqVGMAnq26Q2ghtp4hZvwkNaPKBZ2qOYVNm68lNjZbTQaZj9nD8Ogx8mPqEKTD7tV17l+S7415f51mpxGhO5tk0EWZ9mK9DW3y8rNdk/8NIzfq2NtXLPGRct4+wdJTtvaE0X2jcvYTewfClvaes8loKF2d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oo2/6uA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oo2/6uA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DFCC4AF0A;
	Tue, 23 Jul 2024 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759819;
	bh=KRiGaO3BtOU3MUtky8F05Z6LKP48wKjsjrjNhE2JsFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oo2/6uA0iA7xbPsvO7UpbTe3Hlhg9l6usYvcM8UDFXBh5ygM7TSwaX1CHIUpulFrv
	 52QlRT6aXFs3ybUfAL+MA0xAKAhjSWOENYQ/hjA6y3xWgs7PTzbbcWUnDd90mGnX1B
	 /1S2kAZ1mHbf2UwA+GSlK0+zvJS0GfGsfxuslv+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.9 001/163] cifs: fix noisy message on copy_file_range
Date: Tue, 23 Jul 2024 20:22:10 +0200
Message-ID: <20240723180143.521664524@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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
@@ -1409,7 +1409,7 @@ ssize_t cifs_file_copychunk_range(unsign
 	target_tcon = tlink_tcon(smb_file_target->tlink);
 
 	if (src_tcon->ses != target_tcon->ses) {
-		cifs_dbg(VFS, "source and target of copy not on same server\n");
+		cifs_dbg(FYI, "source and target of copy not on same server\n");
 		goto out;
 	}
 


