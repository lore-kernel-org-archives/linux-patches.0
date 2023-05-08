Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8014168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FF4C433EF;
	Mon,  8 May 2023 10:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541024;
	bh=YksyGS8yB78+EFik0EvampFDW9G5JSdNNIX4pgl8cAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aai8p7ti0NmXVUNv2xW9ka2hlqiP7BMV1pWVWKGayfDUeodc3Fv+vxbSxyAHMPltz
	 GhvXIMRUIe+hpojSiNe8Mp8WWC5DWI784Vp5U8zEpyn+H1yI6UsLFM22/wM+cyxCjd
	 knL+DhmRQhuzfGfbfROz6RIw9yxRa4ZmnvCi1jjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 556/611] afs: Fix updating of i_size with dv jump from server
Date: Mon,  8 May 2023 11:46:38 +0200
Message-Id: <20230508094440.059674538@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Dionne <marc.dionne@auristor.com>

[ Upstream commit d7f74e9a917503ee78f2b603a456d7227cf38919 ]

If the data version returned from the server is larger than expected,
the local data is invalidated, but we may still want to note the remote
file size.

Since we're setting change_size, we have to also set data_changed
for the i_size to get updated.

Fixes: 3f4aa9818163 ("afs: Fix EOF corruption")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 6d3a3dbe49286..52d040ffde35f 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -230,6 +230,7 @@ static void afs_apply_status(struct afs_operation *op,
 			set_bit(AFS_VNODE_ZAP_DATA, &vnode->flags);
 		}
 		change_size = true;
+		data_changed = true;
 	} else if (vnode->status.type == AFS_FTYPE_DIR) {
 		/* Expected directory change is handled elsewhere so
 		 * that we can locally edit the directory and save on a
-- 
2.39.2



