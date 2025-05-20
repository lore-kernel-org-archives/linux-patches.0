Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1CC24A056;
	Tue, 20 May 2025 14:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750199; cv=none; b=HLpBJrYRxR0UKf9uibiJEzaMYHXlMncAchk+v/IyBe5wzui0XbKFusCFu73oeuB2+ldXbNJSOfWLsQrBXiVx+5rjB/8QfZSSUfOwXmWNTif7ZA7hjSXze0zClj4XSTIPtw8CX/wV5OxzEzcYaGtZf3iQYmtVCbmUcXqPI85cHMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750199; c=relaxed/simple;
	bh=jNNqcFm4v/uU2dC75mSiIkbEuHnXaoADElSzId11wJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbuxZv/mAcSoXpzuWy5PZ5gIMO3tZrX6RIDe7fg0i23mr3fqTbmnuYLmkfTfaUuxH68/qUgbRBh2qGdE6fg/zAW1BjYgzrkJBTZdCS8dLQjN8MRWRbzPzfi2oiG8pSsfSKg4gPwBP4cVmQZNQw2pCBpVOAkcW+x1euTGLEEouPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZ4VVPxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZ4VVPxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483C6C4CEE9;
	Tue, 20 May 2025 14:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750199;
	bh=jNNqcFm4v/uU2dC75mSiIkbEuHnXaoADElSzId11wJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZ4VVPxVvxkhdeGRDhLNMu6fT9R9SyRtT2WjPp63ZsDSZQFGBPOMsQdXPHAVY98Fj
	 lQIeesyNqc70eRAJhAdDhwKaX/myuWMEc5Kj3ZSBj9MTHl0bdmjHglTHzjbgDHjy5a
	 Ru/Rp8X/TUsQtx1L0m+F29DopnVm1OUJNP8Xeg4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Joe Damato <jdamato@fastly.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/143] tests/ncdevmem: Fix double-free of queue array
Date: Tue, 20 May 2025 15:49:58 +0200
Message-ID: <20250520125811.743776061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 97c4e094a4b2edbb4fffeda718f8e806f825a18f ]

netdev_bind_rx takes ownership of the queue array passed as parameter
and frees it, so a queue array buffer cannot be reused across multiple
netdev_bind_rx calls.

This commit fixes that by always passing in a newly created queue array
to all netdev_bind_rx calls in ncdevmem.

Fixes: 85585b4bc8d8 ("selftests: add ncdevmem, netcat for devmem TCP")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250508084434.1933069-1-cratiu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/ncdevmem.c | 55 +++++++++++---------------
 1 file changed, 22 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/net/ncdevmem.c b/tools/testing/selftests/net/ncdevmem.c
index 7c671b246d80f..8617e6d7698de 100644
--- a/tools/testing/selftests/net/ncdevmem.c
+++ b/tools/testing/selftests/net/ncdevmem.c
@@ -342,6 +342,22 @@ static int parse_address(const char *str, int port, struct sockaddr_in6 *sin6)
 	return 0;
 }
 
+static struct netdev_queue_id *create_queues(void)
+{
+	struct netdev_queue_id *queues;
+	size_t i = 0;
+
+	queues = calloc(num_queues, sizeof(*queues));
+	for (i = 0; i < num_queues; i++) {
+		queues[i]._present.type = 1;
+		queues[i]._present.id = 1;
+		queues[i].type = NETDEV_QUEUE_TYPE_RX;
+		queues[i].id = start_queue + i;
+	}
+
+	return queues;
+}
+
 int do_server(struct memory_buffer *mem)
 {
 	char ctrl_data[sizeof(int) * 20000];
@@ -359,7 +375,6 @@ int do_server(struct memory_buffer *mem)
 	char buffer[256];
 	int socket_fd;
 	int client_fd;
-	size_t i = 0;
 	int ret;
 
 	ret = parse_address(server_ip, atoi(port), &server_sin);
@@ -379,16 +394,7 @@ int do_server(struct memory_buffer *mem)
 
 	sleep(1);
 
-	queues = malloc(sizeof(*queues) * num_queues);
-
-	for (i = 0; i < num_queues; i++) {
-		queues[i]._present.type = 1;
-		queues[i]._present.id = 1;
-		queues[i].type = NETDEV_QUEUE_TYPE_RX;
-		queues[i].id = start_queue + i;
-	}
-
-	if (bind_rx_queue(ifindex, mem->fd, queues, num_queues, &ys))
+	if (bind_rx_queue(ifindex, mem->fd, create_queues(), num_queues, &ys))
 		error(1, 0, "Failed to bind\n");
 
 	tmp_mem = malloc(mem->size);
@@ -453,7 +459,6 @@ int do_server(struct memory_buffer *mem)
 			goto cleanup;
 		}
 
-		i++;
 		for (cm = CMSG_FIRSTHDR(&msg); cm; cm = CMSG_NXTHDR(&msg, cm)) {
 			if (cm->cmsg_level != SOL_SOCKET ||
 			    (cm->cmsg_type != SCM_DEVMEM_DMABUF &&
@@ -541,10 +546,8 @@ int do_server(struct memory_buffer *mem)
 
 void run_devmem_tests(void)
 {
-	struct netdev_queue_id *queues;
 	struct memory_buffer *mem;
 	struct ynl_sock *ys;
-	size_t i = 0;
 
 	mem = provider->alloc(getpagesize() * NUM_PAGES);
 
@@ -552,38 +555,24 @@ void run_devmem_tests(void)
 	if (configure_rss())
 		error(1, 0, "rss error\n");
 
-	queues = calloc(num_queues, sizeof(*queues));
-
 	if (configure_headersplit(1))
 		error(1, 0, "Failed to configure header split\n");
 
-	if (!bind_rx_queue(ifindex, mem->fd, queues, num_queues, &ys))
+	if (!bind_rx_queue(ifindex, mem->fd,
+			   calloc(num_queues, sizeof(struct netdev_queue_id)),
+			   num_queues, &ys))
 		error(1, 0, "Binding empty queues array should have failed\n");
 
-	for (i = 0; i < num_queues; i++) {
-		queues[i]._present.type = 1;
-		queues[i]._present.id = 1;
-		queues[i].type = NETDEV_QUEUE_TYPE_RX;
-		queues[i].id = start_queue + i;
-	}
-
 	if (configure_headersplit(0))
 		error(1, 0, "Failed to configure header split\n");
 
-	if (!bind_rx_queue(ifindex, mem->fd, queues, num_queues, &ys))
+	if (!bind_rx_queue(ifindex, mem->fd, create_queues(), num_queues, &ys))
 		error(1, 0, "Configure dmabuf with header split off should have failed\n");
 
 	if (configure_headersplit(1))
 		error(1, 0, "Failed to configure header split\n");
 
-	for (i = 0; i < num_queues; i++) {
-		queues[i]._present.type = 1;
-		queues[i]._present.id = 1;
-		queues[i].type = NETDEV_QUEUE_TYPE_RX;
-		queues[i].id = start_queue + i;
-	}
-
-	if (bind_rx_queue(ifindex, mem->fd, queues, num_queues, &ys))
+	if (bind_rx_queue(ifindex, mem->fd, create_queues(), num_queues, &ys))
 		error(1, 0, "Failed to bind\n");
 
 	/* Deactivating a bound queue should not be legal */
-- 
2.39.5



