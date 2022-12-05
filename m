Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAB515C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E740EC433D6;
	Mon,  5 Dec 2022 19:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268353;
	bh=uGmvIs16xQjjxsbrDA/CCWLXtt539onbBbl9Qrc/2d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyDy2cWcOqJA0ZrmDJ9jfWc5ZIc5DyTkr8UenfhvTqeyozO+fUfugr9kfA8x5G7c0
	 AB8v6jJV0k33t7UQ/SBTJmF2BRX8Ld0Ra+0+OnUh4XsNlUMOpKshnBMV4lhSGYQQ4q
	 655AFNyY5PjD32P9gaLxY2e6z6icYSD7yNdOHcUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 071/124] afs: Fix server->active leak in afs_put_server
Date: Mon,  5 Dec 2022 20:09:37 +0100
Message-Id: <20221205190810.440842142@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

[ Upstream commit ef4d3ea40565a781c25847e9cb96c1bd9f462bc6 ]

The atomic_read was accidentally replaced with atomic_inc_return,
which prevents the server from getting cleaned up and causes rmmod
to hang with a warning:

    Can't purge s=00000001

Fixes: 2757a4dc1849 ("afs: Fix access after dec in put functions")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20221130174053.2665818-1-marc.dionne@auristor.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/server.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/server.c b/fs/afs/server.c
index 4981baf97835..b5237206eac3 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -406,7 +406,7 @@ void afs_put_server(struct afs_net *net, struct afs_server *server,
 	if (!server)
 		return;
 
-	a = atomic_inc_return(&server->active);
+	a = atomic_read(&server->active);
 	zero = __refcount_dec_and_test(&server->ref, &r);
 	trace_afs_server(debug_id, r - 1, a, reason);
 	if (unlikely(zero))
-- 
2.35.1



