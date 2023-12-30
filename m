Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B548BED;
	Sat, 30 Dec 2023 12:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziQadWJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCAEC433C8;
	Sat, 30 Dec 2023 12:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938131;
	bh=3vWqmNRSn9XnJR4BEfFR/25jMetXpydKcvY/1Nubhdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziQadWJ/ZBTv9yBO9tXBI90IfUxV9xmXBLsnm9atj/iq6frMgouSo1Rr72UsEUdi5
	 33imlahCVd77/VApbc9NRW8oaBQNwsB56mklrJyHqiRjuKF/xoHQSxsMvzkQ9fv4LE
	 lIBWkpIcqE/uB/2mF+gNTzCmVu2yZ4BGsa1KvSfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Anastasia Belova <abelova@astralinux.ru>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	lvc-project@linuxtesting.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/112] afs: Fix overwriting of result of DNS query
Date: Sat, 30 Dec 2023 11:59:12 +0000
Message-ID: <20231230115807.992037374@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit a9e01ac8c5ff32669119c40dfdc9e80eb0b7d7aa ]

In afs_update_cell(), ret is the result of the DNS lookup and the errors
are to be handled by a switch - however, the value gets clobbered in
between by setting it to -ENOMEM in case afs_alloc_vlserver_list()
fails.

Fix this by moving the setting of -ENOMEM into the error handling for
OOM failure.  Further, only do it if we don't have an alternative error
to return.

Found by Linux Verification Center (linuxtesting.org) with SVACE.  Based
on a patch from Anastasia Belova [1].

Fixes: d5c32c89b208 ("afs: Fix cell DNS lookup")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Anastasia Belova <abelova@astralinux.ru>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: lvc-project@linuxtesting.org
Link: https://lore.kernel.org/r/20231221085849.1463-1-abelova@astralinux.ru/ [1]
Link: https://lore.kernel.org/r/1700862.1703168632@warthog.procyon.org.uk/ # v1
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 988c2ac7cecec..926cb1188eba6 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -409,10 +409,12 @@ static int afs_update_cell(struct afs_cell *cell)
 		if (ret == -ENOMEM)
 			goto out_wake;
 
-		ret = -ENOMEM;
 		vllist = afs_alloc_vlserver_list(0);
-		if (!vllist)
+		if (!vllist) {
+			if (ret >= 0)
+				ret = -ENOMEM;
 			goto out_wake;
+		}
 
 		switch (ret) {
 		case -ENODATA:
-- 
2.43.0



