Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981E45FF0A;
	Tue, 13 Feb 2024 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845495; cv=none; b=hyQV+JPVqHlak58iMb5/kMY3yh9bpEn4CwLnWOscqezScyciasDImwHSmLFV/nkODLkIIhM3PcX5gtf/dqlabV/lk9PeGevizOJAu//TOPRYjyhD3sTqkAPX98KZweefO9PTsUHOI6D5C0k8PuOtHP8UlWZT4xjxl8sOuek9CEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845495; c=relaxed/simple;
	bh=3tSHqSU+kLM19rQ0N6CpIWLRYMHB24LHK8mAaF+LJ30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpKYh+MAf6FBrXymMuhv2mGSZMvElVWS1uC91PwIRTCWi1zl7zGbLXWB7VwiYyEkFfoFMi6VbuA4wBpM/SPWzuxqe70hA7IEo/78wuLZOCiSlDmRcqc2kVpjZubqpY5wZ4Ei7pQOAY1GkzgOfsF2aoJ1sOsb4lmXM7qHbqJTSqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/O/XDEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/O/XDEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0223C433F1;
	Tue, 13 Feb 2024 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845495;
	bh=3tSHqSU+kLM19rQ0N6CpIWLRYMHB24LHK8mAaF+LJ30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/O/XDEeu+zmOwyhoO1olEhg9MOAP6QJ8jF3MHkcwpB8GJ46jNCvurH0RYL26sZI1
	 r17VaojRb20d11h0NBg9mVUdJqhtSoiLEwyqV/Z2skkd5f/czpSPc4jo3ClSRZ3JCW
	 1w3H/eoxQOHZ8k1uMFSt62lKnxxQlnQPc7DJq5sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/121] libceph: rename read_sparse_msg_*() to read_partial_sparse_msg_*()
Date: Tue, 13 Feb 2024 18:21:43 +0100
Message-ID: <20240213171855.736007006@linuxfoundation.org>
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



