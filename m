Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB89A93C;
	Tue, 13 Feb 2024 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845865; cv=none; b=QTCv0SmAs9yd0Ta5c7Eyx7cYIRhVeUKtYnhGjxgIV2mPoOuu4XxXcVMQ9Bg8lgh7eBBYKqkpf23AhUwYOb+qUmXP3pz4fisVHdNwP844ahV4jrciZP9gtZX8tqSQLW95neKi5Saao2FdJ9AHJ19a0yI7eHEBn6QPTaoq7FUhm+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845865; c=relaxed/simple;
	bh=s6hPUiXo93quv15tVP/37Q+VMaMbOWDwernpWy3RX4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzpGFjb/paLuWBGgVyeNSeXN8J4flzRMHF+aEAPn3gghC47kWEyEd6aiyd8lyWWfb4AD+FG2Oyzi8btB3n19I6f5uHj4MwWCwBKKYQyIjO9t4GN0RqCEdAzVz7b/WsaWNsFQI7BeDI6whtwliLuJx43zhHh/1cil0qy6Dnmr8Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkU6yxJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkU6yxJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3331AC433C7;
	Tue, 13 Feb 2024 17:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845865;
	bh=s6hPUiXo93quv15tVP/37Q+VMaMbOWDwernpWy3RX4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkU6yxJMIyZ1W3IMjaLBAm/tXDmmmabtaf+4oQHjpyKyaojg//R9l+egWcIzxq076
	 VvE3G9vh7B6BmG6txJCGIovjYLA7aLCuvWHW9nnpj8cahzq3VmAQI97AM3RUDnP8cj
	 LV5H5svtPxMcZKAXQKV7gV6esFeTBzdxfaj8Rrqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 079/124] libceph: rename read_sparse_msg_*() to read_partial_sparse_msg_*()
Date: Tue, 13 Feb 2024 18:21:41 +0100
Message-ID: <20240213171856.044012375@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit ee97302fbc0c98a25732d736fc73aaf4d62c4128 ]

These functions are supposed to behave like other read_partial_*()
handlers: the contract with messenger v1 is that the handler bails if
the area of the message it's responsible for is already processed.
This comes up when handling short reads from the socket.

[ idryomov: changelog ]

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 8e46a2d068c9 ("libceph: just wait for more data to be available on the socket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/messenger_v1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index f9a50d7f0d20..4cb60bacf5f5 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -991,7 +991,7 @@ static inline int read_partial_message_section(struct ceph_connection *con,
 	return read_partial_message_chunk(con, section, sec_len, crc);
 }
 
-static int read_sparse_msg_extent(struct ceph_connection *con, u32 *crc)
+static int read_partial_sparse_msg_extent(struct ceph_connection *con, u32 *crc)
 {
 	struct ceph_msg_data_cursor *cursor = &con->in_msg->cursor;
 	bool do_bounce = ceph_test_opt(from_msgr(con->msgr), RXBOUNCE);
@@ -1026,7 +1026,7 @@ static int read_sparse_msg_extent(struct ceph_connection *con, u32 *crc)
 	return 1;
 }
 
-static int read_sparse_msg_data(struct ceph_connection *con)
+static int read_partial_sparse_msg_data(struct ceph_connection *con)
 {
 	struct ceph_msg_data_cursor *cursor = &con->in_msg->cursor;
 	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
@@ -1043,7 +1043,7 @@ static int read_sparse_msg_data(struct ceph_connection *con)
 							 con->v1.in_sr_len,
 							 &crc);
 		else if (cursor->sr_resid > 0)
-			ret = read_sparse_msg_extent(con, &crc);
+			ret = read_partial_sparse_msg_extent(con, &crc);
 
 		if (ret <= 0) {
 			if (do_datacrc)
@@ -1254,7 +1254,7 @@ static int read_partial_message(struct ceph_connection *con)
 			return -EIO;
 
 		if (m->sparse_read)
-			ret = read_sparse_msg_data(con);
+			ret = read_partial_sparse_msg_data(con);
 		else if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE))
 			ret = read_partial_msg_data_bounce(con);
 		else
-- 
2.43.0



