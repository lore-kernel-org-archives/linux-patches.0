Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2CB4E77FD;
	Wed, 30 Sep 2026 18:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792589; cv=none; b=VPgIWR8CpvJDS6R54Yq8wcNJZj7Cj/FZMTznXDWVRBJc581gBacaf0d2HG80Ie/oGG64VTTqdasu9n6uo4iQO+lRtyfO6Nu9kTpTeYyUjTqctYp5oNXsC2qdKsxYdrUq0ea3Olm1NlZ8x2xj7XttNUm8/vCwSD+G73mreVkIRBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792589; c=relaxed/simple;
	bh=XEodgNSIsmpmZb7j8j5KZPzFoUoWTkixJ6dC8Ysmro0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADQywmFrk+CIpA/vlZvEocetwmQri8vTh46PxAQikjwbMvfkgCFLXyi3frNm2/yv1lyM/jyar/AhJaSiFk9y+26W5ICd0xjQBWJnbZj6nmYT05UGnYuM5G1ZfpM0Lr3se6tRhzs6VGDxzrFMOPCymTh3BDcZO4fFdywjYlH4CkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4QN5aD6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4QN5aD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2435F1F000FF;
	Wed, 30 Sep 2026 18:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792587;
	bh=BDYyJJxtrLumwZE8vai1dNL2DQgGunoVkX0ui7C4qzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4QN5aD6SGwCFw83E00XoB41oLy2vt1TFWjNrGxK8iRww4vSBTrqRL+mT4mfUeIV7
	 dh7CRCM7OCz+vZBtjss7PiyXVGoM3brNVkA27TzE2lQfuncsIIGAlIhFZhfN7gEpUy
	 DS3oRGNBU2hFvNA0YAWNZjUCAQhjeNw6m6z9dTQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Zhu <zhulei@kylinos.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 652/752] selftests: nci: Correct pthread_create return value check
Date: Wed, 30 Sep 2026 17:28:42 +0200
Message-ID: <20260930152412.368843846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Zhu <zhulei@kylinos.cn>

[ Upstream commit 3d8afc5243ea2ee803d98e69eb4a01748167ac1b ]

The pthread_create() functions returns 0 on success and a positive value on
failure. Modify the return value check to correctly detect failure cases.

Fixes: 72696bd8a09d ("selftests: nci: Extract the start/stop discovery function")
Signed-off-by: Lei Zhu <zhulei@kylinos.cn>
Link: https://patch.msgid.link/20260729072426.303484-1-zhulei_szu@163.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nci/nci_dev.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 162c41e9bcae8..6f571e3c21c09 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -438,7 +438,7 @@ FIXTURE_SETUP(NCI)
 	else
 		rc = pthread_create(&thread_t, NULL, virtual_dev_open,
 				    (void *)&self->virtual_nci_fd);
-	ASSERT_GT(rc, -1);
+	ASSERT_EQ(rc, 0);
 
 	rc = send_cmd_with_idx(self->sd, self->fid, self->pid,
 			       NFC_CMD_DEV_UP, self->dev_idex);
@@ -509,7 +509,7 @@ FIXTURE_TEARDOWN(NCI)
 			rc = pthread_create(&thread_t, NULL, virtual_deinit,
 					    (void *)&self->virtual_nci_fd);
 
-		ASSERT_GT(rc, -1);
+		ASSERT_EQ(rc, 0);
 		rc = send_cmd_with_idx(self->sd, self->fid, self->pid,
 				       NFC_CMD_DEV_DOWN, self->dev_idex);
 		EXPECT_EQ(rc, 0);
@@ -590,7 +590,7 @@ int start_polling(int dev_idx, int proto, int virtual_fd, int sd, int fid, int p
 
 	rc = pthread_create(&thread_t, NULL, virtual_poll_start,
 			    (void *)&virtual_fd);
-	if (rc < 0)
+	if (rc)
 		return rc;
 
 	rc = send_cmd_mt_nla(sd, fid, pid, NFC_CMD_START_POLL, 2, nla_start_poll_type,
@@ -610,7 +610,7 @@ int stop_polling(int dev_idx, int virtual_fd, int sd, int fid, int pid)
 
 	rc = pthread_create(&thread_t, NULL, virtual_poll_stop,
 			    (void *)&virtual_fd);
-	if (rc < 0)
+	if (rc)
 		return rc;
 
 	rc = send_cmd_with_idx(sd, fid, pid,
@@ -830,6 +830,8 @@ int disconnect_tag(int nfc_sock, int virtual_fd)
 
 	status = pthread_create(&thread_t, NULL, virtual_deactivate_proc,
 				(void *)&virtual_fd);
+	if (status)
+		return status;
 
 	close(nfc_sock);
 	pthread_join(thread_t, (void **)&status);
@@ -874,7 +876,7 @@ TEST_F(NCI, deinit)
 	else
 		rc = pthread_create(&thread_t, NULL, virtual_deinit,
 				    (void *)&self->virtual_nci_fd);
-	ASSERT_GT(rc, -1);
+	ASSERT_EQ(rc, 0);
 
 	rc = send_cmd_with_idx(self->sd, self->fid, self->pid,
 			       NFC_CMD_DEV_DOWN, self->dev_idex);
-- 
2.53.0



