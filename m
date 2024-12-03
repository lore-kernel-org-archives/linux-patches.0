Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0242500DA;
	Tue,  3 Dec 2024 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239841; cv=none; b=TLGrK/aHGx/h1SzjZ+xWvl9ctmuYFftEj/6XPRaruAKX64S6rltObqfAKQwuUOVWlchOtYyEMnsTePvMENbf3XHQBindmMm5v+6RyQcrV1eyrwwamoCn26QtkHsjpS+QGIu0CFjqUct+0L4P0YZSe+uChUCDxpXhEbJu8RHp0q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239841; c=relaxed/simple;
	bh=FdyV5JA3T37IR2lSEGY6k8EsNFfbVeAMd7HmcCX7RZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SY8jECttYr7q+GBkLLKwGqzuupePVj9ChFihq14n36hPAKGkZAEShdoCseawOcXUBAFtxRtuWgPyh+S9GAtE8A9y/k7Ij6g9Z7qVI6ZeOMcEOIqH3fflemtI3zISY6Xqxd/kph++ylpso4hHLPfVNY39/N7U4ItJErBCI3Yxqkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFlaf7Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFlaf7Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B301C4CECF;
	Tue,  3 Dec 2024 15:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239841;
	bh=FdyV5JA3T37IR2lSEGY6k8EsNFfbVeAMd7HmcCX7RZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFlaf7MbM9Xb8KHyV+UiFvVv5FoJu2rxePJgWDVQyRkcb+LCslQi1q9xEkhH8NyiW
	 tZ+hRHHfxVlM5hw7040yCDlb2fMCFDXlXioxkc5WysVVb9/vJO8nknwE9gvsrH+3Hc
	 sYVGtpbI8wBAJubnQ0LgO+XmrZK6FT4mLLGLa2Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.11 745/817] smb3: request handle caching when caching directories
Date: Tue,  3 Dec 2024 15:45:17 +0100
Message-ID: <20241203144025.077911147@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 9ed9d83a51a9636d367c796252409e7b2f4de4d4 upstream.

This client was only requesting READ caching, not READ and HANDLE caching
in the LeaseState on the open requests we send for directories.  To
delay closing a handle (e.g. for caching directory contents) we should
be requesting HANDLE as well as READ (as we already do for deferred
close of files).   See MS-SMB2 3.3.1.4 e.g.

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4078,7 +4078,7 @@ map_oplock_to_lease(u8 oplock)
 	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
 		return SMB2_LEASE_WRITE_CACHING_LE | SMB2_LEASE_READ_CACHING_LE;
 	else if (oplock == SMB2_OPLOCK_LEVEL_II)
-		return SMB2_LEASE_READ_CACHING_LE;
+		return SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE;
 	else if (oplock == SMB2_OPLOCK_LEVEL_BATCH)
 		return SMB2_LEASE_HANDLE_CACHING_LE | SMB2_LEASE_READ_CACHING_LE |
 		       SMB2_LEASE_WRITE_CACHING_LE;


