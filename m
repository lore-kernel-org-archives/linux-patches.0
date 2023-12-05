Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0380D6AC2;
	Tue,  5 Dec 2023 03:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3rFQHn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F720C433C8;
	Tue,  5 Dec 2023 03:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747830;
	bh=z9pWUbwYU4Vu1rIjelc+T1c2KFAh05O9Y20FWGV4aqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3rFQHn46JjrFialJr9YGWlgfSHq9c/11gHExF6lTj0OAWBSjHjAYWLRotEi1hu9/
	 sqfDQHbSlJ7YLupnbeLKoPHPNX87ybAxShSeMxoSMVgmpgnm9/LXHUrSeb41xlgNY5
	 aGesbiPU7Au6LYllWGiLyx3w9nedKlxZY9gIaRyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Suvanto <markus.suvanto@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/94] afs: Make error on cell lookup failure consistent with OpenAFS
Date: Tue,  5 Dec 2023 12:16:32 +0900
Message-ID: <20231205031523.103588046@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2a4ca1b4b77850544408595e2433f5d7811a9daa ]

When kafs tries to look up a cell in the DNS or the local config, it will
translate a lookup failure into EDESTADDRREQ whereas OpenAFS translates it
into ENOENT.  Applications such as West expect the latter behaviour and
fail if they see the former.

This can be seen by trying to mount an unknown cell:

   # mount -t afs %example.com:cell.root /mnt
   mount: /mnt: mount(2) system call failed: Destination address required.

Fixes: 4d673da14533 ("afs: Support the AFS dynamic root")
Reported-by: Markus Suvanto <markus.suvanto@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216637
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dynroot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index f07e53ab808e3..45007d96a402d 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -38,8 +38,8 @@ static int afs_probe_cell_name(struct dentry *dentry)
 
 	ret = dns_query(net->net, "afsdb", name, len, "srv=1",
 			NULL, NULL, false);
-	if (ret == -ENODATA)
-		ret = -EDESTADDRREQ;
+	if (ret == -ENODATA || ret == -ENOKEY)
+		ret = -ENOENT;
 	return ret;
 }
 
-- 
2.42.0



