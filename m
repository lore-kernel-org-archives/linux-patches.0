Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4941B158215;
	Tue, 23 Jul 2024 18:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759763; cv=none; b=ekdNK2yIdhwyZ2oddYnw/L+1+x/ldbaK0OJE/hryU6pZPLXY95Nl7Q38jBf1dXoYZPutL3M48rL58GLWEwarg6PMgS1E66HXTlFLAYt8w0yvKUYsrLC9DPNw1LuT5z9IDDEze+bCQ2XlTIP0DFKv1OZ/9NAMWbrsHr6D8BJmhtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759763; c=relaxed/simple;
	bh=ejfqUEs+rJePaR33QOdCDf9dl5KtK+MGNdWx+ngWVao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dp3fdJACXFs/xqJHJnDC8dldx880MJ+77FyLOTNLcpypTrFLaVClCoK+p/mftt9Q5StplLiZfKcDNmr7TRxtkscoSVXmlJiVtcWVAfQkOCtUm8GVTYPWfbw/sNxwIIv3cZXeRYR5tTqEC8kpyBjpNismLhTowmN7G3JUs1wYwRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjRkvZfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjRkvZfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6FBC4AF0A;
	Tue, 23 Jul 2024 18:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759763;
	bh=ejfqUEs+rJePaR33QOdCDf9dl5KtK+MGNdWx+ngWVao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjRkvZfgxIpBBXconEUQu+QIxKwNfso3EjfW9Ghejl7Pr16+JUPLsMJkjnpVqsEls
	 1IIQdByHaWwrms9EMFgDx5jVUWqhZQgovxI7V0Oj50FCzMfW0yw0Yeg9N3Df/nQIoZ
	 jzRA0UeDH9vWirDkr1AQ+Edo6DVdmDAyUq1qI3bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 119/129] cifs: fix noisy message on copy_file_range
Date: Tue, 23 Jul 2024 20:24:27 +0200
Message-ID: <20240723180409.387861980@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1404,7 +1404,7 @@ ssize_t cifs_file_copychunk_range(unsign
 	target_tcon = tlink_tcon(smb_file_target->tlink);
 
 	if (src_tcon->ses != target_tcon->ses) {
-		cifs_dbg(VFS, "source and target of copy not on same server\n");
+		cifs_dbg(FYI, "source and target of copy not on same server\n");
 		goto out;
 	}
 


