Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66845FF0B;
	Tue, 13 Feb 2024 17:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845499; cv=none; b=F+KRNIRWjudBkjr/h3tbIUl/VoZ2q/TgYBRcMZWiCcqa6GuH3Twy1YHLTg9ceuw4E+B3KjzgqQZImch825zDck4ewZE38vgMy+nPWefYDqicI5+2TBRMnbYOekaWFVXML5SZKo+e6dQ2aWgtG1khp1k2HzdklugSxO337oHJ1+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845499; c=relaxed/simple;
	bh=GCVKmxmfukvh7U8b6hM2SfjtJdSyYqNg5JHgJXW6d5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0QHUenEI7AIWysf32ai/radt0vE+ZQpVjfGEzrQH8WzCWq82TjUCxXYo6WH3HyqEEdh3uNQGV5Ju6JMBgODSQRbTQuBKjY9I5r6yy+Ko2bF9C5Ue3vINpotszBa/jyhl0V0KKYUOS6gMkktsV8nerbMuO45B2BlOHr7mCSSVq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOnzWwGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOnzWwGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8B8C433C7;
	Tue, 13 Feb 2024 17:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845498;
	bh=GCVKmxmfukvh7U8b6hM2SfjtJdSyYqNg5JHgJXW6d5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOnzWwGb5sbhlZYD1MQ1VeVysaeM0tC/IwKhQm1AIHeVt/EzoYUuMEWoYsQiBIipw
	 TkChaXcPqecZN/JS8XVIRNHby0p4EhzeWmOUQkwOodSqkZGIzlrLVeX+Yb2+CG9ZQq
	 3Sh3bJ/zyoFkfcGQ70OMsZooMPdsw3ZR5Ajl+KgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/121] libceph: just wait for more data to be available on the socket
Date: Tue, 13 Feb 2024 18:21:44 +0100
Message-ID: <20240213171855.765448267@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 8e46a2d068c92a905d01cbb018b00d66991585ab ]

A short read may occur while reading the message footer from the
socket.  Later, when the socket is ready for another read, the
messenger invokes all read_partial_*() handlers, including
read_partial_sparse_msg_data().  The expectation is that
read_partial_sparse_msg_data() would bail, allowing the messenger to
invoke read_partial() for the footer and pick up where it left off.

However read_partial_sparse_msg_data() violates that and ends up
calling into the state machine in the OSD client.  The sparse-read
state machine assumes that it's a new op and interprets some piece of
the footer as the sparse-read header and returns bogus extents/data
length, etc.

To determine whether read_partial_sparse_msg_data() should bail, let's
reuse cursor->total_resid.  Because once it reaches to zero that means
all the extents and data have been successfully received in last read,
else it could break out when partially reading any of the extents and
data.  And then osd_sparse_read() could continue where it left off.

[ idryomov: changelog ]

Link: https://tracker.ceph.com/issues/63586
Fixes: d396f89db39a ("libceph: add sparse read support to msgr1")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ceph/messenger.h |  2 +-
 net/ceph/messenger_v1.c        | 25 +++++++++++++------------
 net/ceph/messenger_v2.c        |  4 ++--
 net/ceph/osd_client.c          |  9 +++------
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 2eaaabbe98cb..1717cc57cdac 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -283,7 +283,7 @@ struct ceph_msg {
 	struct kref kref;
 	bool more_to_follow;
 	bool needs_out_seq;
-	bool sparse_read;
+	u64 sparse_read_total;
 	int front_alloc_len;
 
 	struct ceph_msgpool *pool;
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 4cb60bacf5f5..0cb61c76b9b8 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -160,8 +160,9 @@ static size_t sizeof_footer(struct ceph_connection *con)
 static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
 {
 	/* Initialize data cursor if it's not a sparse read */
-	if (!msg->sparse_read)
-		ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
+	u64 len = msg->sparse_read_total ? : data_len;
+
+	ceph_msg_data_cursor_init(&msg->cursor, msg, len);
 }
 
 /*
@@ -1036,7 +1037,7 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
 	if (do_datacrc)
 		crc = con->in_data_crc;
 
-	do {
+	while (cursor->total_resid) {
 		if (con->v1.in_sr_kvec.iov_base)
 			ret = read_partial_message_chunk(con,
 							 &con->v1.in_sr_kvec,
@@ -1044,23 +1045,23 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
 							 &crc);
 		else if (cursor->sr_resid > 0)
 			ret = read_partial_sparse_msg_extent(con, &crc);
-
-		if (ret <= 0) {
-			if (do_datacrc)
-				con->in_data_crc = crc;
-			return ret;
-		}
+		if (ret <= 0)
+			break;
 
 		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
 		ret = con->ops->sparse_read(con, cursor,
 				(char **)&con->v1.in_sr_kvec.iov_base);
+		if (ret <= 0) {
+			ret = ret ? ret : 1;  /* must return > 0 to indicate success */
+			break;
+		}
 		con->v1.in_sr_len = ret;
-	} while (ret > 0);
+	}
 
 	if (do_datacrc)
 		con->in_data_crc = crc;
 
-	return ret < 0 ? ret : 1;  /* must return > 0 to indicate success */
+	return ret;
 }
 
 static int read_partial_msg_data(struct ceph_connection *con)
@@ -1253,7 +1254,7 @@ static int read_partial_message(struct ceph_connection *con)
 		if (!m->num_data_items)
 			return -EIO;
 
-		if (m->sparse_read)
+		if (m->sparse_read_total)
 			ret = read_partial_sparse_msg_data(con);
 		else if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE))
 			ret = read_partial_msg_data_bounce(con);
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index d09a39ff2cf0..a901cae2f106 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -1132,7 +1132,7 @@ static int decrypt_tail(struct ceph_connection *con)
 	struct sg_table enc_sgt = {};
 	struct sg_table sgt = {};
 	struct page **pages = NULL;
-	bool sparse = con->in_msg->sparse_read;
+	bool sparse = !!con->in_msg->sparse_read_total;
 	int dpos = 0;
 	int tail_len;
 	int ret;
@@ -2064,7 +2064,7 @@ static int prepare_read_tail_plain(struct ceph_connection *con)
 	}
 
 	if (data_len(msg)) {
-		if (msg->sparse_read)
+		if (msg->sparse_read_total)
 			con->v2.in_state = IN_S_PREPARE_SPARSE_DATA;
 		else
 			con->v2.in_state = IN_S_PREPARE_READ_DATA;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index d3a759e052c8..8d9760397b88 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5510,7 +5510,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	}
 
 	m = ceph_msg_get(req->r_reply);
-	m->sparse_read = (bool)srlen;
+	m->sparse_read_total = srlen;
 
 	dout("get_reply tid %lld %p\n", tid, m);
 
@@ -5777,11 +5777,8 @@ static int prep_next_sparse_read(struct ceph_connection *con,
 	}
 
 	if (o->o_sparse_op_idx < 0) {
-		u64 srlen = sparse_data_requested(req);
-
-		dout("%s: [%d] starting new sparse read req. srlen=0x%llx\n",
-		     __func__, o->o_osd, srlen);
-		ceph_msg_data_cursor_init(cursor, con->in_msg, srlen);
+		dout("%s: [%d] starting new sparse read req\n",
+		     __func__, o->o_osd);
 	} else {
 		u64 end;
 
-- 
2.43.0



