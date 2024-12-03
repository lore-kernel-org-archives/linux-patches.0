Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FC11EE00B;
	Tue,  3 Dec 2024 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242654; cv=none; b=UwHakh6BjBJzOe8NvlCndg7tjx8OMhaEFm4KhQ1sH6x89YQkCJfBfCVYnystnagju1zWqj4ygom+1HfpBKluuQhtuC7SyaMCS0bf7pjoz3uPff4tV5WUowBzhECXrLiSf1K4Pay1KFZFMl1Tns5+fkLQaNpkNxqaxAEAMYsVZUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242654; c=relaxed/simple;
	bh=J0zhvZQO9vHFYyKPPrLuDoUHcggAqMugTQGSxwNvQp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqlitO37vY3ShvVBxNmroG4wAYAmPnGFQLsO9Uu2b/8ETxgViL3WeSud6ojxJMfZE54108AXY6aPln33b723qfZw36qm6O4b7g+J6OyBFkT5q/VFU1yF0/0mQaNxdFsp3H7pVRRW7nnQ9YsxRGElZp+E5KiNsh8xU1LVYUMxMuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IESEXvWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IESEXvWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764DCC4CECF;
	Tue,  3 Dec 2024 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242653;
	bh=J0zhvZQO9vHFYyKPPrLuDoUHcggAqMugTQGSxwNvQp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IESEXvWlA0ahzzEOINP4YFlZvIOPm6Fdtx6ivc9StoW7QS3hs/TKRy8DeU3DS0sq9
	 ivihDmLcfMx6AFGv0URVLSllX4s5Cx/d3p2iibYHRCBpZmqWxilgJuelBkZRzuLDD0
	 Hl2mFzYpYPnZ+WxLrEnSSuhaqqGw2W0dwRHO3GI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 751/826] smb3: request handle caching when caching directories
Date: Tue,  3 Dec 2024 15:47:58 +0100
Message-ID: <20241203144813.058814558@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4080,7 +4080,7 @@ map_oplock_to_lease(u8 oplock)
 	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
 		return SMB2_LEASE_WRITE_CACHING_LE | SMB2_LEASE_READ_CACHING_LE;
 	else if (oplock == SMB2_OPLOCK_LEVEL_II)
-		return SMB2_LEASE_READ_CACHING_LE;
+		return SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE;
 	else if (oplock == SMB2_OPLOCK_LEVEL_BATCH)
 		return SMB2_LEASE_HANDLE_CACHING_LE | SMB2_LEASE_READ_CACHING_LE |
 		       SMB2_LEASE_WRITE_CACHING_LE;


