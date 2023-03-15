Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A764431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C393C433D2;
	Wed, 15 Mar 2023 12:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883543;
	bh=TaF1KHDUjsWtGvQLL8vjzm97oh8qj2p4XYNNXrqoO50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhePuWY/hJYK5XJ6AvnpoNLe5VBCvpWbfqW2nrj9YcL4dlhHqoH35nySz3x7jg3nC
	 TYbHeydSc8uiuzNVM6wz+AadpLG5LNLcuhhEfRoQw4amLyAXUbmOqREdjDldjVwRLD
	 A8CX5vdXMtcIJsecJ4qPYh+Zvt220eX5yNBtvffo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/143] fs: dlm: be sure to call dlm_send_queue_flush()
Date: Wed, 15 Mar 2023 13:12:04 +0100
Message-Id: <20230315115741.670936435@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 7354fa4ef697191effedc2ae9a8293427708bbf5 ]

If we release a midcomms node structure, there should be nothing left
inside the dlm midcomms send queue. However, sometimes this is not true
because I believe some DLM_FIN message was not acked... if we run
into a shutdown timeout, then we should be sure there is no pending send
dlm message inside this queue when releasing midcomms node structure.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/midcomms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index b53d7a281be93..d976c2009b185 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1367,6 +1367,7 @@ static void midcomms_node_release(struct rcu_head *rcu)
 	struct midcomms_node *node = container_of(rcu, struct midcomms_node, rcu);
 
 	WARN_ON_ONCE(atomic_read(&node->send_queue_cnt));
+	dlm_send_queue_flush(node);
 	kfree(node);
 }
 
-- 
2.39.2



