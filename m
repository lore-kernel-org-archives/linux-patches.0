Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6BE371049;
	Wed, 30 Sep 2026 19:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796812; cv=none; b=OyZe7CH7WjGqOL9deS8NHbkn9OU3EPbDViaje4YtlpDpg6+Xmgdlron/XKjoLa1bLmnn80za8tDwChP0i97LmH4grQq3ipzCEMy+9QQ9wtbcXFNULFY66Vd5Qo253INbruUxtqqaqQUgr8W0XfQg43j1jz5rohWz0LGo9qW7n9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796812; c=relaxed/simple;
	bh=baw6HXGZqObpBR4meTdSOk8ELphLzKWbivm/NOjeSgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToOqPC3t1cMLyscZFUoeZpFKflSprr6epISIoSfBPtWvNDI3RcUErxy13BAQ8Eq4LBKm4J6+J/o067WFELBVSHPjzxVCdRtsNf6fcf2bcNmS8nqEw3kyE/VRd4k1dtOuhaEYqLDUpkuCkpBSPVYQfbTWtDKust5+7mYSWVHb/g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuS+Rol3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuS+Rol3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6A91F000FF;
	Wed, 30 Sep 2026 19:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796811;
	bh=/nvFWE5S5PjNZ5mNa6Ep2jJXEBce+m0K3cKr1iMf3aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuS+Rol3EpByls4Pctk6ENv5xJ9jK1YlPqZ1pfSuslhhGxLjEe6e8Eia9GWSPtfbH
	 LY4u1O/Rmvj8inzvmIMn2Uzskx28IbaQPeXqJNmPPVRsEa4rMDyH0eVeqOHKHjf5ca
	 bIGQTHYSE3en5W0dF/UBCMqWD/9iMJVgtvzAz4pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Gellermann <christian.gellermann@codasip.com>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1043/1193] selftests/nci: Fix out-of-bounds store on thread join
Date: Wed, 30 Sep 2026 17:28:47 +0200
Message-ID: <20260930152457.392544494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2a96ca0a9fb1b..ab34e08c64d60 100644
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



