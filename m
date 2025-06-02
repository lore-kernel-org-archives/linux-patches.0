Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7781C5D72;
	Mon,  2 Jun 2025 14:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874687; cv=none; b=RhJdiEaXJUpzW6G1Z7AhvtiPY4TA3rZoUPXUQHEOoDhvwCh59X3xk3up5bDzgMocUN+B7AV33g7FqfeSYXZG9N/2kzDFg/layiPvN3aG7Dtam8F+nH6SbGww9MZW0OvZ3JuJUStZrnRdzH9QXLC0NnMpTRiwRWMpFrmXdxW6rTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874687; c=relaxed/simple;
	bh=i7MCvsjisZJXpAesjJhSWyvLCY6nD2FvOd2AGsd0xLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuR/uQftYs8t3LHGhbceFb9vmxVwR7gOuUqikzmP6N+uEuEISXnyLM5W5jKjWThSeIPCpYO6BwbQjG+V1e+lcsppAKNiMDkPH5e0YtHeG42iEjhWrCglkLIPi/xyVDk81Cm++l4I7zi7cnThbhGPCsTkBKzAmkWzCrKVsYJ15GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9+fk6Ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9+fk6Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C818C4CEEE;
	Mon,  2 Jun 2025 14:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874686;
	bh=i7MCvsjisZJXpAesjJhSWyvLCY6nD2FvOd2AGsd0xLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9+fk6KaJMhCKe//wfyDXgSaIe8USr/fGMvV8zmjx+4983f1WglL5avWx+d2bBSb8
	 LrFEmZvPM1C7ZipSoXolhxiJ4NZ7oYICERDbEAWl/unjLCYYe1wX9INZ4qjCRNPpkG
	 ktsXMOmdHtWFZC43C674WT4I3y9rKSvIK7pX3twU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/204] btrfs: send: return -ENAMETOOLONG when attempting a path that is too long
Date: Mon,  2 Jun 2025 15:47:15 +0200
Message-ID: <20250602134259.669998744@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a77749b3e21813566cea050bbb3414ae74562eba ]

When attempting to build a too long path we are currently returning
-ENOMEM, which is very odd and misleading. So update fs_path_ensure_buf()
to return -ENAMETOOLONG instead. Also, while at it, move the WARN_ON()
into the if statement's expression, as it makes it clear what is being
tested and also has the effect of adding 'unlikely' to the statement,
which allows the compiler to generate better code as this condition is
never expected to happen.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e1063ef3dece5..b0933d9525939 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -397,10 +397,8 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	if (p->buf_len >= len)
 		return 0;
 
-	if (len > PATH_MAX) {
-		WARN_ON(1);
-		return -ENOMEM;
-	}
+	if (WARN_ON(len > PATH_MAX))
+		return -ENAMETOOLONG;
 
 	path_len = p->end - p->start;
 	old_buf_len = p->buf_len;
-- 
2.39.5



