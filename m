Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1380B20969B;
	Thu, 12 Dec 2024 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020255; cv=none; b=uIuXDQW3ivmJi/EOY9toVT7lgShkZeD7D3KZ3M8cGYtPRaZ6g4+cRmWNCYA6RrJCygLcy7xAvIbrTv6BzXIzNFdRwpt+9Tbi/ZU0ljrd7lfFDx9QzDznH3TiIL9hEx2Qp77ueAb6r3HYPTbovCE7dDqwj1q4dRbmvQ2Mvw9TSVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020255; c=relaxed/simple;
	bh=L2903mfWrq13r50pM+Ao4M9RYiqNxQibWDdUe57ii3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruPl3CLUE7rMY89WczppYKWS6xBAC3A6sb//yeOfOJkj3CPUR8Vv0+GCMCIdjgPsP8JiGcBoMiSNzQ0TEkGuitMcq9GX33xmRdZxA5ZBDk40rMHkVD/LaVlNNVALrQNUppK/Q6qydaFlRQjZb4Ia53HyiJsqQlYx1Vpy2Kmr9Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiqTw/1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiqTw/1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BA3C4CECE;
	Thu, 12 Dec 2024 16:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020254;
	bh=L2903mfWrq13r50pM+Ao4M9RYiqNxQibWDdUe57ii3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiqTw/1t8KaGpjzGcjr/cAmodSGZVuyoACW8LukQHCi6RnZNcMMJRlJKtIek8PITI
	 lt7WcC3ExnCytaVgyZ5MIWRmbNA5Qoay8W0AfvTojLruEiuV2lRVNKsOXqb1rRARQO
	 GTIQtAYvt+OBgFbVNkQzQhQVIqEmnKMGjE20vlKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 417/772] smb3: request handle caching when caching directories
Date: Thu, 12 Dec 2024 15:56:02 +0100
Message-ID: <20241212144407.145887909@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
@@ -4260,7 +4260,7 @@ map_oplock_to_lease(u8 oplock)
 	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
 		return SMB2_LEASE_WRITE_CACHING_LE | SMB2_LEASE_READ_CACHING_LE;
 	else if (oplock == SMB2_OPLOCK_LEVEL_II)
-		return SMB2_LEASE_READ_CACHING_LE;
+		return SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE;
 	else if (oplock == SMB2_OPLOCK_LEVEL_BATCH)
 		return SMB2_LEASE_HANDLE_CACHING_LE | SMB2_LEASE_READ_CACHING_LE |
 		       SMB2_LEASE_WRITE_CACHING_LE;


