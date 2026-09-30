Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7683624BF;
	Wed, 30 Sep 2026 16:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787275; cv=none; b=K1CQdgbwBmY6HqDJyBAtl8JsdUTyICgRlT1c4dWQXhHZ24LKLDle1kvBxqI7J6irMu9eST7A2JrAoQ3f9zXpEnPwB2R+Np49uApJzyt2u3sw6MLDCw4jAwanZJle7J0Jb0WAB89gpgoq24yf5Ql7IpuAQA0CXU8JkjWRsCC8+yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787275; c=relaxed/simple;
	bh=0MpoHmIXiGfJ6hl4J+KgCLWkdmhUVnFPZOY+qzbWnME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVlEJU927Fz6Jkmjs0gqvOO1aH3osZVwDYs9NOeubhaHicxe5rmrp7jFaJp3d6wNX03rO3L6Ej9eBFQiE+uSvTzp+hpNGgEuLE+8E60UMFIq+wOgkMJrsL//AtIqhG5dM3z0EY9on8w4PhWKGyC2bKZcefvpEArSvWkF0bAgPYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzuPZuts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzuPZuts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93F41F000FF;
	Wed, 30 Sep 2026 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787274;
	bh=ruX6LNh34aq0RaaMMtq3E8NyhUcEK0cdlhp2+plyP/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzuPZutsyYC/Vt4AMmzKxIxojTqlCHanVbk9IxDHuiDl2rL2RYEgfGrosT/uEClrK
	 i/zdb8dHsa1dXahYiiag2Df2KOh7xrAmWXZFiSTW7mdIcSFMooeQCt8KAzKoBRJU8w
	 3GuHidtwGCnZx+6fxE/FaA7cI3pgHSlOHnGlqfQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Gellermann <christian.gellermann@codasip.com>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 173/457] selftests/nci: Fix out-of-bounds store on thread join
Date: Wed, 30 Sep 2026 17:24:38 +0200
Message-ID: <20260930152349.787184521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Gellermann <christian.gellermann@codasip.com>

[ Upstream commit 6be581aeffc215bfc77939cd59902b0dbc4af23e ]

The NCI test collects the exit status of its helper threads by passing
the address of an int to pthread_join():

	int status;
	...
	pthread_join(thread_t, (void **) &status);

pthread_join() stores a void pointer to the memory location. On 64-bit
systems, a void pointer is wider than an int, so the store overruns the
4 bytes of space allocated on the stack for the integer and corrupts the
adjacent stack. On our CHERI system, this caused a fault due to a
capability bounds violation.

Fix this by introducing a helper that joins a thread through a void
pointer and converts the result back to an integer, which is what the
helper threads return.

While here, also fix the logic in disconnect_tag() if the helper thread
creation failed. Previously, it would have joined a thread that was
never created when pthread_create() failed.

Fixes: f595cf1242f3 ("selftests: Add nci suite")
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260904095915.3372241-1-christian.gellermann@codasip.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nci/nci_dev.c | 31 +++++++++++++++++----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 23fd38acfcf42..07427fa42888d 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -8,6 +8,7 @@
 
 #include <stdlib.h>
 #include <errno.h>
+#include <stdint.h>
 #include <string.h>
 #include <sys/ioctl.h>
 #include <fcntl.h>
@@ -87,6 +88,16 @@ struct msgtemplate {
 	char buf[MAX_MSG_SIZE];
 };
 
+static int join_thread_status(pthread_t thread)
+{
+	void *thread_ret = NULL;
+
+	if (pthread_join(thread, &thread_ret))
+		return -1;
+
+	return (int)(intptr_t)thread_ret;
+}
+
 static int create_nl_socket(void)
 {
 	int fd;
@@ -444,7 +455,7 @@ FIXTURE_SETUP(NCI)
 			       NFC_CMD_DEV_UP, self->dev_idex);
 	EXPECT_EQ(rc, 0);
 
-	pthread_join(thread_t, (void **)&status);
+	status = join_thread_status(thread_t);
 	ASSERT_EQ(status, 0);
 	self->open_state = true;
 }
@@ -514,7 +525,7 @@ FIXTURE_TEARDOWN(NCI)
 				       NFC_CMD_DEV_DOWN, self->dev_idex);
 		EXPECT_EQ(rc, 0);
 
-		pthread_join(thread_t, (void **)&status);
+		status = join_thread_status(thread_t);
 		ASSERT_EQ(status, 0);
 	}
 
@@ -585,7 +596,6 @@ int start_polling(int dev_idx, int proto, int virtual_fd, int sd, int fid, int p
 	void *nla_start_poll_data[2] = {&dev_idx, &proto};
 	int nla_start_poll_len[2] = {4, 4};
 	pthread_t thread_t;
-	int status;
 	int rc;
 
 	rc = pthread_create(&thread_t, NULL, virtual_poll_start,
@@ -598,14 +608,12 @@ int start_polling(int dev_idx, int proto, int virtual_fd, int sd, int fid, int p
 	if (rc != 0)
 		return rc;
 
-	pthread_join(thread_t, (void **)&status);
-	return status;
+	return join_thread_status(thread_t);
 }
 
 int stop_polling(int dev_idx, int virtual_fd, int sd, int fid, int pid)
 {
 	pthread_t thread_t;
-	int status;
 	int rc;
 
 	rc = pthread_create(&thread_t, NULL, virtual_poll_stop,
@@ -618,8 +626,7 @@ int stop_polling(int dev_idx, int virtual_fd, int sd, int fid, int pid)
 	if (rc != 0)
 		return rc;
 
-	pthread_join(thread_t, (void **)&status);
-	return status;
+	return join_thread_status(thread_t);
 }
 
 TEST_F(NCI, start_poll)
@@ -834,8 +841,10 @@ int disconnect_tag(int nfc_sock, int virtual_fd)
 		return status;
 
 	close(nfc_sock);
-	pthread_join(thread_t, (void **)&status);
-	return status;
+	if (status)
+		return -1;
+
+	return join_thread_status(thread_t);
 }
 
 TEST_F(NCI, t4t_tag_read)
@@ -882,7 +891,7 @@ TEST_F(NCI, deinit)
 			       NFC_CMD_DEV_DOWN, self->dev_idex);
 	EXPECT_EQ(rc, 0);
 
-	pthread_join(thread_t, (void **)&status);
+	status = join_thread_status(thread_t);
 	self->open_state = 0;
 	ASSERT_EQ(status, 0);
 
-- 
2.53.0



