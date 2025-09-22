Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53F3285C92;
	Mon, 22 Sep 2025 19:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569844; cv=none; b=c3rBuErxkzwISRXWwLV2N68xcirt8MSO2SRiFpEcdO3zmQ01tRhtRBFp/AE2TIr311YQBQul6Seqm8tDR5w5AgftS3GwRePkbeSpZw85H7CAGjvylRgluwInHC+y7gy/bR1watgycu1NS1LgUY+ZnPkFkP5KPRZASQK3Mv3Lxlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569844; c=relaxed/simple;
	bh=LW7hCxJ+/v0BQ5mMASXQh+Y2lcx0nXn/EFxkJVC4fyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+q04mMW9GaSFpPZzwgLxhfMi3PnZ1jjJbMR7uQCSlzJF90FpodWtXBxmU33s8jKM8faaNj+FMpNqZoOEz9mQgcQUIMRmPjhQ2b6nDtd+6v/MPnRQMMz65JNHquZdYDjRwAd1euzOhWgiKjLg42GFNIO0WtQxynE5RBzSJ1wLhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEs1210m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEs1210m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4A6C4CEF0;
	Mon, 22 Sep 2025 19:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569844;
	bh=LW7hCxJ+/v0BQ5mMASXQh+Y2lcx0nXn/EFxkJVC4fyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEs1210mPOKTsotsGx6rvCoqXrgFgzmg1Yd1KUtDnrjn+D5+aaP61sWDKk6DB0GdV
	 liwdrteaim4nBkaA6kIyNP4p1BZc+nh+k9HUKvbuQVLbmRrMGuCMVKUKPBtc4Q+SQt
	 yEdvD6BlOLmkSLcMzTw46EI7jUfCrHGfV1idBS2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/105] um: Fix FD copy size in os_rcv_fd_msg()
Date: Mon, 22 Sep 2025 21:28:53 +0200
Message-ID: <20250922192409.168954642@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit df447a3b4a4b961c9979b4b3ffb74317394b9b40 ]

When copying FDs, the copy size should not include the control
message header (cmsghdr). Fix it.

Fixes: 5cde6096a4dd ("um: generalize os_rcv_fd")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index f1d03cf3957fe..62c176a2c1ac4 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -556,7 +556,7 @@ ssize_t os_rcv_fd_msg(int fd, int *fds, unsigned int n_fds,
 	    cmsg->cmsg_type != SCM_RIGHTS)
 		return n;
 
-	memcpy(fds, CMSG_DATA(cmsg), cmsg->cmsg_len);
+	memcpy(fds, CMSG_DATA(cmsg), cmsg->cmsg_len - CMSG_LEN(0));
 	return n;
 }
 
-- 
2.51.0



