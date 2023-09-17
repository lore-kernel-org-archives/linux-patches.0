Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642B46FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EFAC433C7;
	Sun, 17 Sep 2023 19:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980354;
	bh=4oJYQ35F2v7UIfOP1/cHFn9VMwePAX92lHb0B+Rpjgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhFf0CdfsP4C8fOqvKPbvLqW/v4b1aLgKQaiPo71gjlxqlx0FKG9woJvtHdy+AQtO
	 RSK9ZUgNeByRHfGEbcQy1K6WJsD/PMpYS7x28MgHM5f3D1nXbb7ibXEd/0pMJGXlNX
	 DhVrOYQ9Hhpv0OMGT1YN5JeP1lxELBQgybafBzLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 139/285] kcm: Destroy mutex in kcm_exit_net()
Date: Sun, 17 Sep 2023 21:12:19 +0200
Message-ID: <20230917191056.481511968@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 6ad40b36cd3b04209e2d6c89d252c873d8082a59 ]

kcm_exit_net() should call mutex_destroy() on knet->mutex. This is especially
needed if CONFIG_DEBUG_MUTEXES is enabled.

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Link: https://lore.kernel.org/r/20230902170708.1727999-1-syoshida@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 393f01b2a7e6d..4580f61426bb8 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1859,6 +1859,8 @@ static __net_exit void kcm_exit_net(struct net *net)
 	 * that all multiplexors and psocks have been destroyed.
 	 */
 	WARN_ON(!list_empty(&knet->mux_list));
+
+	mutex_destroy(&knet->mutex);
 }
 
 static struct pernet_operations kcm_net_ops = {
-- 
2.40.1



