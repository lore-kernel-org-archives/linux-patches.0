Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EEF6FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F22DC433C8;
	Sun, 17 Sep 2023 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979588;
	bh=8TP2iaUc9cTKXkntsWmM5rP48P+nXWlRUj7X35WoNIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJiHYDwLLqTX9u6kqszO0SMCWrGlMhqpjZd/+1GcDtWAwVZ2ePjyR6febHx6ge4rP
	 lnFxqi4sKdHoHIA15oIN9x1d+DL5tc1rgIwgRjd8gtyrxUcd2NKG6Zbdh+/IRsZjFv
	 dtzOfBb3K2F0S1ePuecp75et8vanLaIbmpdw2diA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 356/406] kcm: Destroy mutex in kcm_exit_net()
Date: Sun, 17 Sep 2023 21:13:30 +0200
Message-ID: <20230917191110.678554902@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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
index 32b516ab9c475..71608a6def988 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1982,6 +1982,8 @@ static __net_exit void kcm_exit_net(struct net *net)
 	 * that all multiplexors and psocks have been destroyed.
 	 */
 	WARN_ON(!list_empty(&knet->mux_list));
+
+	mutex_destroy(&knet->mutex);
 }
 
 static struct pernet_operations kcm_net_ops = {
-- 
2.40.1



