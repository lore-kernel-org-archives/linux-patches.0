Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4468495C2;
	Thu, 30 Nov 2023 16:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TViEKA6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3021EC433C7;
	Thu, 30 Nov 2023 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361612;
	bh=Bxul39rimGG2XsP6wocYmqsd3e5zh5tQ9/9LfM65hKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TViEKA6LJCBOhfMUxYHUWtKemgbnXM1tCzRfKNaFhQGGBsnQ/3VA7+sx83GHmEACH
	 FiEN+IOk/gFlKi7WmkQwgSa5pSzvwO9zBCDpEKBTVZQ8rT1CUzafuJQEV8dHwQ+FiL
	 Ov9rSIyn9TxyynhjhiG7jw+RLfkbx5r5Fyt4xC6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/112] cifs: fix leak of iface for primary channel
Date: Thu, 30 Nov 2023 16:22:18 +0000
Message-ID: <20231130162143.220767690@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 29954d5b1e0d67a4cd61c30c2201030c97e94b1e ]

My last change in this area introduced a change which
accounted for primary channel in the interface ref count.
However, it did not reduce this ref count on deallocation
of the primary channel. i.e. during umount.

Fixing this leak here, by dropping this ref count for
primary channel while freeing up the session.

Fixes: fa1d0508bdd4 ("cifs: account for primary channel in the interface list")
Cc: stable@vger.kernel.org
Reported-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index a9632c060bceb..d517651d7bcea 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2034,6 +2034,12 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 		}
 	}
 
+	/* we now account for primary channel in iface->refcount */
+	if (ses->chans[0].iface) {
+		kref_put(&ses->chans[0].iface->refcount, release_iface);
+		ses->chans[0].server = NULL;
+	}
+
 	sesInfoFree(ses);
 	cifs_put_tcp_session(server, 0);
 }
-- 
2.42.0



