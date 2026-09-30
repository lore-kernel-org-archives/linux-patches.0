Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEA34E1C76;
	Wed, 30 Sep 2026 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785718; cv=none; b=E6KvXKq5l9KPcW0GDx0NfxrDx3oyvra4kMpjU23mXTlwHT5HltgUjRBv76qKOzF7pc8Iaf+iYyvQPpyoP7er94KzD0CMOSrj+Mn/ecKBe8c5DzwaNselRUcqjK7phl5OL+ZJCrG70Ds8j6EYaB8SBmuh3KzMgeax2CzeE7lcuCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785718; c=relaxed/simple;
	bh=EeNIRMVV4NSz2zSyujNfXwx1HNjzJHtq32JPd6P0nZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgggC3pb+6CiMDAERBZGqgaHRkMV/o7zOz/Y3sd91JheM0zvh0YvCtj6S8NS4ySoCca+SenUWaRjGLLOZjRH0ifnsyTITidOZ8dhKxXzIWgsfKY4tMIzrdONLaMq5wQN9mwdO/gj0a8tHEzNKGhlMDZidKOv2A/7k54Ff8/COoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WStgEwNl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WStgEwNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1171F000FF;
	Wed, 30 Sep 2026 16:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785716;
	bh=ptD2TCqY8OH/cVHUMtgXDcfp77OuK+uPZvcg8XO+1oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WStgEwNlKslfkRcePEtNmKLLOJ9Jt6QwBYvMixOuRf/W3u6wVnbXV++JyhcTPPaSi
	 K5IgiLJcLlO29zRoQFsIjsElGhG25f2TZV1Bj9gxCa/etiHmnrMqyYJwQZUAvs46fK
	 +isnVC0y4i0BRnF4syF6CIRcZH+sj8nHDOiA1P14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 608/982] RDMA/mad: Fix receive buffer leak when PKey enforcement fails
Date: Wed, 30 Sep 2026 17:22:24 +0200
Message-ID: <20260930152429.838611178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 3476c28c9addfa253f505e6bd87f1f5598b961d0 ]

ib_mad_complete_recv() initializes mad_recv_wc->rmpp_list and then runs
ib_mad_enforce_security() before linking recv_buf onto that list.  On
failure it calls ib_free_recv_mad(), which only walks rmpp_list and frees
the ib_mad_private of every buffer found there.  As the list is still
empty at that point, nothing is freed at all.

The caller cannot clean up either: ib_mad_recv_done() sets recv to NULL
right after ib_mad_complete_recv() returns, assuming the MAD layer took
ownership of the buffer.  Every MAD that fails the PKey check therefore
leaks one ib_mad_private (about 300 bytes per IB port MAD, ~2K for OPA),
and a remote node can trigger this repeatedly by sending MADs with a
wrong PKey.

Link recv_buf onto rmpp_list right after the list is initialized, so the
error path has something to free.

Fixes: 47a2b338fe63 ("IB/core: Enforce security on management datagrams")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260826073216.2367-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index bddb1c607aff6..4347b3af13119 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1805,6 +1805,8 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	int ret;
 
 	INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
+	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
+
 	ret = ib_mad_enforce_security(mad_agent_priv,
 				      mad_recv_wc->wc->pkey_index);
 	if (ret) {
@@ -1813,7 +1815,6 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 		return;
 	}
 
-	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
 	if (is_kernel_rmpp_data_response(mad_agent_priv, mad_recv_wc)) {
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
-- 
2.53.0



