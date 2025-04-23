Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F7227EC73;
	Wed, 23 Apr 2025 15:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421296; cv=none; b=jN9DgI38iXzbNuNLz2mCdxTWn6z5pKTznJjT1DkO3PDMMBrIP/LdeHBzShB64GqVyzLbXQ6xeEVB0EOtsT8GSM5ePqCMnp20hBaOxlmApSIkT4ALrQJ83k3ZtusTswkBmcEOSBEKPUGj9COuJkuInnU+XBSpTPiBdd2MBhvFw5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421296; c=relaxed/simple;
	bh=C4IAmXgWl4UX10ntt6hsnfxI9H4Q5SO2lzHVjsGSd8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFcIJ+K8s0gdeWizkuSbqJov4Yk4ONpyP1nBOLtL6y7EUpICG7Du5P79TiLUfgMMXqNtwehy4jdQiOJ9rDgW7VxRC2k7JPdwUHfnJzezG6ot0z8lV3S0MgkM17n+QGlqPt2eKKvMAn/HNr8Nvm63pw5CdEEvZLdlhF+IFva7nlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6jwPqEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6jwPqEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA7CC4CEE2;
	Wed, 23 Apr 2025 15:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421296;
	bh=C4IAmXgWl4UX10ntt6hsnfxI9H4Q5SO2lzHVjsGSd8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6jwPqEQwYh735Jrt9Hr092AEuB9qmJS/KqdYZM18HM7JEQXvG34YjECzBMETsxLX
	 EMK5FBRH38MDTPdfAkohnQQ7GFerXefZ8vjvpZTGRMnBMZBBCAAoZQqoqT5ywWVZsq
	 sFwnMrGnzBBZNSWeLA6fG9AaHQVJ0jJOLxrGqTo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 166/393] smb311 client: fix missing tcon check when mounting with linux/posix extensions
Date: Wed, 23 Apr 2025 16:41:02 +0200
Message-ID: <20250423142650.226459200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit b365b9d404b7376c60c91cd079218bfef11b7822 upstream.

When mounting the same share twice, once with the "linux" mount parameter
(or equivalently "posix") and then once without (or e.g. with "nolinux"),
we were incorrectly reusing the same tree connection for both mounts.
This meant that the first mount of the share on the client, would
cause subsequent mounts of that same share on the same client to
ignore that mount parm ("linux" vs. "nolinux") and incorrectly reuse
the same tcon.

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2488,6 +2488,8 @@ static int match_tcon(struct cifs_tcon *
 		return 0;
 	if (tcon->nodelete != ctx->nodelete)
 		return 0;
+	if (tcon->posix_extensions != ctx->linux_ext)
+		return 0;
 	return 1;
 }
 


