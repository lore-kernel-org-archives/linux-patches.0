Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215697;
	b=qlnZSAXcMIgIB1Bx5E/Vo/v8fluttwyE/NCsug1L3Fums9UhFO2SR70O30jnpnxpVhLl
	 S7hNYQyVjERCDVY2FJaLCvCjjvjEq/TUJNidhRFNjcj7ic4GTBjbz3/lc4Im5qAYaxvFI
	 f1rnx5LFe2/NAfipFTMiheLyBwuRqlf/foHKPsV3jDyc06nR6sSqmBN/SzixGaZVqEwE+
	 sh4dlo9TlC3qEFmKZHpRywSiEEiCwRnnb/89D9zDfuRNwafOmgxeW3yL3giwx+T1ln6rC
	 JjZjBtiBSLlvg0kDbHpMHPyoTBitY/PmdV7B8MrsLp/X3qWA0Yv+A1K5fYZWl7Z4UOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RoyokC/o/tUOj9xPLfhK4Fspi6G+hI53QnZ9Jg4ViTo=;
	b=3/xQfZQGemOy6Lo7pGqyu5GXf4TiHrX16uPzNKDQzJ18OO5eppUqeLtWx0htYmjfcXoZ
	 YDqRwUjwM5Te/DjdUxVFP9QZJkN0jl5VF10z92T7jNpK+c+YIPipUNiE91pyufw2tWUzI
	 ZHOQB2JpEYiQLME+xA0YcPKcfz2S1XvjpxtbqVfG9mbHWlgYAWqm43yLziqsp7Z6eQLJ/
	 eJA3LkbCqgIwKx+LU7DQNViVWpJkAhUUOzLgKlz70yrdRf/s4CpjcgyAB6DGKZIF6QKUJ
	 k0BF93OsmajAmHsGpvYCcbs6v+wNBVhrSNoMR6Gr6UFrHNC9id1gqio99Kv3rKcEv2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4+Wwy5k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56497606A31A;
	Wed, 28 Oct 2026 19:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D4+Wwy5k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77EB1F01828;
	Wed, 28 Oct 2026 19:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215697;
	bh=RoyokC/o/tUOj9xPLfhK4Fspi6G+hI53QnZ9Jg4ViTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4+Wwy5k+L89oit2gKkhxuY0V+KWb7QtoHfOA1LbtVqAfLgYElYSKSQW2TM2dQaEt
	 Z9AlWOqAUpFeOClUXnVeRZlUZxOaZt5Ld7OCP4QCpX0tkLWX0hRlSBHLYqWvMKnEt6
	 uGW6nfWfMXi8tmN9101ggOiCyI49V0Z38ipmP+K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1274/1887] dlm: fix add msg handle in send_queue ordered
Date: Wed, 28 Oct 2026 17:56:10 +0100
Message-ID: <20261028170528.412758540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit d2248cb70c070f8f04762872772e155b59016f17 ]

In a benchmark scenario triggering a lot of requests that triggers a lot
of DLM messages on the network it can be that the mh->seq is not ordered
according the oldest seq number. This ordering is required by
dlm_receive_ack as "before(mh->seq, seq)" will stop to check for older
sequence numbers that are ordered in the tail of "node->send_queue".

The side effects of not having it correct ordered regarding
"before(mh->seq, seq)" are refcounting issues and use-after free.

I only was able to reproduce this issue in a experimental DLM branch
and a user space DLM benchmark that uses io_uring. After changing this I
don't experienced any refcounting with the sending buffer issues anymore.

Fixes: 489d8e559c659 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/midcomms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 71e426da48c3d..42d54196e766f 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1040,10 +1040,10 @@ static void midcomms_new_msg_cb(void *data)
 	atomic_inc(&mh->node->send_queue_cnt);
 
 	spin_lock(&mh->node->send_queue_lock);
+	/* need to be locked with list_add_tail_rcu() because list is ordered */
+	mh->seq = mh->node->seq_send++;
 	list_add_tail_rcu(&mh->list, &mh->node->send_queue);
 	spin_unlock(&mh->node->send_queue_lock);
-
-	mh->seq = mh->node->seq_send++;
 }
 
 static struct dlm_msg *dlm_midcomms_get_msg_3_2(struct dlm_mhandle *mh, int nodeid,
-- 
2.53.0



