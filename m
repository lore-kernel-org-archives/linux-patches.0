Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C5633CFD;
	Fri, 24 Nov 2023 18:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dp00yDBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55DFC433C7;
	Fri, 24 Nov 2023 18:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852298;
	bh=yd/rUkNNx8aS3LixTyTa1QyBqy+akpzxQO8LsCKOZvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dp00yDBS1eWY0tkX82cquUN7vjXlMekArcswNepGejJjdXnuh0IuRby5nN7JpcdeU
	 ScYzmiOrEYjzbBxaOMFUuOfPl7U4CRmaK3eQB3mKPVxpNYSNPvlN3VjPXCaGnXJg+Y
	 JbuXyjdecsF4SZIjRVLMzeZQeQvCe+rDl4ed5g84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 275/372] cifs: do not reset chan_max if multichannel is not supported at mount
Date: Fri, 24 Nov 2023 17:51:02 +0000
Message-ID: <20231124172019.626206117@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit 6e5e64c9477d58e73cb1a0e83eacad1f8df247cf upstream.

If the mount command has specified multichannel as a mount option,
but multichannel is found to be unsupported by the server at the time
of mount, we set chan_max to 1. Which means that the user needs to
remount the share if the server starts supporting multichannel.

This change removes this reset. What it means is that if the user
specified multichannel or max_channels during mount, and at this
time, multichannel is not supported, but the server starts supporting
it at a later point, the client will be capable of scaling out the
number of channels.

Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -186,7 +186,6 @@ int cifs_try_adding_channels(struct cifs
 	}
 
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
-		ses->chan_max = 1;
 		spin_unlock(&ses->chan_lock);
 		cifs_server_dbg(VFS, "no multichannel support\n");
 		return 0;


