Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58139248F71;
	Tue, 20 May 2025 14:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750190; cv=none; b=lZFa7CodxL2WP2rulsYgiTP1FcySanpfScL7nC2HoSGKvtB6Jv8ujdOzxp77NwQh9CUe0kBHx2wCEDBpmINdA2B5cAVt7n8KvRDIpggVh4G++pFjnFSXkBXRclOeFUhN/6vWLeTSIFfMo1Hv6z6R41VPZUFvIY72hF6uW/tluAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750190; c=relaxed/simple;
	bh=bnNtpdaYhSTu0AHgTNIQQgd5EocLQ1oPFbjp6LL9e8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo3KrFwVma5opAXR2GX6hkIz82cbtSBVrCxZa4ogmdynV+gkI1WLTkoViLnBYI4TCHbh1C7b4z5lSgCKMXsuSJLpGDnrOMmM2RvOZqBh7LwhXCPBMB+iqw5OeIjw+NXvE2l2YpZlnBG/RGzY4tYyzFbxFNIbfD0xReCBkomH5aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgVy6s2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgVy6s2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC047C4CEE9;
	Tue, 20 May 2025 14:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750190;
	bh=bnNtpdaYhSTu0AHgTNIQQgd5EocLQ1oPFbjp6LL9e8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgVy6s2KNhTo/QoBQ53Bawtgx84wi3vdt0RpTPe46vxheuCKdsLJuX3+LGbKH3Tk3
	 9LHBkD9UARnQ9jIAe46SEsx921mLyoqM+OK7fFFuqE27VL4dU5Q92+EBwtmEXWpgPR
	 8HwH1FHnDJN5eLVwUi3GvmTDOK8YZnITxQBgg+OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Joe Damato <jdamato@fastly.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/143] selftests: ncdevmem: Unify error handling
Date: Tue, 20 May 2025 15:49:55 +0200
Message-ID: <20250520125811.630278170@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit bfccbaac1b45f9af7d76589d7e31ad921b50c0d7 ]

There is a bunch of places where error() calls look out of place.
Use the same error(1, errno, ...) pattern everywhere.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20241107181211.3934153-4-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 97c4e094a4b2 ("tests/ncdevmem: Fix double-free of queue array")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/ncdevmem.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/ncdevmem.c b/tools/testing/selftests/net/ncdevmem.c
index 3e7ef2eedd60b..4733d1a0aab5d 100644
--- a/tools/testing/selftests/net/ncdevmem.c
+++ b/tools/testing/selftests/net/ncdevmem.c
@@ -339,33 +339,33 @@ int do_server(struct memory_buffer *mem)
 	server_sin.sin_port = htons(atoi(port));
 
 	ret = inet_pton(server_sin.sin_family, server_ip, &server_sin.sin_addr);
-	if (socket < 0)
-		error(79, 0, "%s: [FAIL, create socket]\n", TEST_PREFIX);
+	if (ret < 0)
+		error(1, errno, "%s: [FAIL, create socket]\n", TEST_PREFIX);
 
 	socket_fd = socket(server_sin.sin_family, SOCK_STREAM, 0);
-	if (socket < 0)
-		error(errno, errno, "%s: [FAIL, create socket]\n", TEST_PREFIX);
+	if (socket_fd < 0)
+		error(1, errno, "%s: [FAIL, create socket]\n", TEST_PREFIX);
 
 	ret = setsockopt(socket_fd, SOL_SOCKET, SO_REUSEPORT, &opt,
 			 sizeof(opt));
 	if (ret)
-		error(errno, errno, "%s: [FAIL, set sock opt]\n", TEST_PREFIX);
+		error(1, errno, "%s: [FAIL, set sock opt]\n", TEST_PREFIX);
 
 	ret = setsockopt(socket_fd, SOL_SOCKET, SO_REUSEADDR, &opt,
 			 sizeof(opt));
 	if (ret)
-		error(errno, errno, "%s: [FAIL, set sock opt]\n", TEST_PREFIX);
+		error(1, errno, "%s: [FAIL, set sock opt]\n", TEST_PREFIX);
 
 	fprintf(stderr, "binding to address %s:%d\n", server_ip,
 		ntohs(server_sin.sin_port));
 
 	ret = bind(socket_fd, &server_sin, sizeof(server_sin));
 	if (ret)
-		error(errno, errno, "%s: [FAIL, bind]\n", TEST_PREFIX);
+		error(1, errno, "%s: [FAIL, bind]\n", TEST_PREFIX);
 
 	ret = listen(socket_fd, 1);
 	if (ret)
-		error(errno, errno, "%s: [FAIL, listen]\n", TEST_PREFIX);
+		error(1, errno, "%s: [FAIL, listen]\n", TEST_PREFIX);
 
 	client_addr_len = sizeof(client_addr);
 
-- 
2.39.5



