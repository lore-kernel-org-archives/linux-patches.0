Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C08C168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C96FC433EF;
	Mon,  8 May 2023 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545237;
	bh=47pz8tUPNS6mWB5xe9KYIq/u3NKRof1lxwUts2DVKt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGQxdO7T/00tiQUsDETgWVZTzBsjSgQ+i1nekmCJVvyV5pcSJdKVlsOhSX8DxGDmH
	 JigSWNra534hx/tbevQm3V5brEG6wia694FLsrCYdA252UBN6ZtpBDaViW13qyeMjw
	 dJTJE4+gVmDlMEgtW5nvNSpLw7RjC6EfB3YZlZno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 669/694] afs: Fix updating of i_size with dv jump from server
Date: Mon,  8 May 2023 11:48:24 +0200
Message-Id: <20230508094457.836144619@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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
index 0167e96e51986..790cca53c1453 100644
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



