Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B94171C3
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Q+QMnK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623DFC433C7;
	Mon, 23 Oct 2023 11:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061840;
	bh=or01qtOxVnDE9jHLe/bCd2pe4zGCTIpumROle9MLUC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Q+QMnK0jD8g8LLpEQ7hv2qXKoYnIJshwyaxdCzSNxZd4rerIiqh3FK7+bIb85bOP
	 wfp9nrCkNcR9xFAAkjvEqnVtH9zsCA030vLLf9CfuCAHEq3SENbe21GHcIYj4j2QyZ
	 SxoAHgb+IIrp3uwY21/l0PZBjGmE9bdx8qVgWmaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/202] overlayfs: set ctime when setting mtime and atime
Date: Mon, 23 Oct 2023 12:57:42 +0200
Message-ID: <20231023104831.046066971@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 03dbab3bba5f009d053635c729d1244f2c8bad38 ]

Nathan reported that he was seeing the new warning in
setattr_copy_mgtime pop when starting podman containers. Overlayfs is
trying to set the atime and mtime via notify_change without also
setting the ctime.

POSIX states that when the atime and mtime are updated via utimes() that
we must also update the ctime to the current time. The situation with
overlayfs copy-up is analogies, so add ATTR_CTIME to the bitmask.
notify_change will fill in the value.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Christian Brauner <brauner@kernel.org>
Acked-by: Amir Goldstein <amir73il@gmail.com>
Message-Id: <20230913-ctime-v1-1-c6bc509cbc27@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 7ef3c87f8a23d..65ac504595ba4 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -243,7 +243,7 @@ static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *stat)
 {
 	struct iattr attr = {
 		.ia_valid =
-		     ATTR_ATIME | ATTR_MTIME | ATTR_ATIME_SET | ATTR_MTIME_SET,
+		     ATTR_ATIME | ATTR_MTIME | ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_CTIME,
 		.ia_atime = stat->atime,
 		.ia_mtime = stat->mtime,
 	};
-- 
2.40.1



