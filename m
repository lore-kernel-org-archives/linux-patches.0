Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AE21A08DF;
	Tue, 20 May 2025 14:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750568; cv=none; b=CWR2KjDOUGvie4E0s727fmmXI7MsODY9JN8ehNXbW8o/zEke94Usm2NgLJfMFfp5/SZ1MhTuf/Fjt8uuER5T1VD9By+S/XvFfXuf/VFC3F0PRKlXazQe3wkp1Kn6HwBLCT68agPmztt5BEJhYBpN0BTMAOTeWsj/9I9yREOfLpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750568; c=relaxed/simple;
	bh=phCB/DT19FyLw4av8aNUKQBzsxxtCIz8k0o8/hAgfgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjPi0kNrWACLZCSpo1tjJjAHh16n8jFuu3ZF5myAGGOsXvcmn2KIDw+ZDvqaOdHADeUrcF0SteiMDVb6Rr8evQQG6vag2jsqLJDaVqqA5SESaKS6KqV+71SEYcS8AeWvTgIr+w94mAWD8zqxhVcpU6qRU5n0w/+Ma6si0dAZt1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaaaUTpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaaaUTpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D86C4CEE9;
	Tue, 20 May 2025 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750568;
	bh=phCB/DT19FyLw4av8aNUKQBzsxxtCIz8k0o8/hAgfgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaaaUTpLkJvShyl9RnMo757EHuLF3iM/iGS66NtyKEwHL68LEUcF122+PBqA2P6yP
	 hdVTKrrrDKbUmM1+EafP6hNtfEFNTJuA+XpZ1Xxi+b1+/rG311dprafj46tmEeLF/g
	 0R2+oVAxGsBJ8XckctEI28AsuV3M4lAgfYk4QAJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Shkolnyy <kshk@linux.ibm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 043/145] vsock/test: Fix occasional failure in SIOCOUTQ tests
Date: Tue, 20 May 2025 15:50:13 +0200
Message-ID: <20250520125812.263238216@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Shkolnyy <kshk@linux.ibm.com>

[ Upstream commit 7fd7ad6f36af36f30a06d165eff3780cb139fa79 ]

These tests:
    "SOCK_STREAM ioctl(SIOCOUTQ) 0 unsent bytes"
    "SOCK_SEQPACKET ioctl(SIOCOUTQ) 0 unsent bytes"
output: "Unexpected 'SIOCOUTQ' value, expected 0, got 64 (CLIENT)".

They test that the SIOCOUTQ ioctl reports 0 unsent bytes after the data
have been received by the other side. However, sometimes there is a delay
in updating this "unsent bytes" counter, and the test fails even though
the counter properly goes to 0 several milliseconds later.

The delay occurs in the kernel because the used buffer notification
callback virtio_vsock_tx_done(), called upon receipt of the data by the
other side, doesn't update the counter itself. It delegates that to
a kernel thread (via vsock->tx_work). Sometimes that thread is delayed
more than the test expects.

Change the test to poll SIOCOUTQ until it returns 0 or a timeout occurs.

Signed-off-by: Konstantin Shkolnyy <kshk@linux.ibm.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Fixes: 18ee44ce97c1 ("test/vsock: add ioctl unsent bytes test")
Link: https://patch.msgid.link/20250507151456.2577061-1-kshk@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/vsock/vsock_test.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index d0f6d253ac72d..613551132a966 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1264,21 +1264,25 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
 	send_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
 	control_expectln("RECEIVED");
 
-	ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
-	if (ret < 0) {
-		if (errno == EOPNOTSUPP) {
-			fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
-		} else {
+	/* SIOCOUTQ isn't guaranteed to instantly track sent data. Even though
+	 * the "RECEIVED" message means that the other side has received the
+	 * data, there can be a delay in our kernel before updating the "unsent
+	 * bytes" counter. Repeat SIOCOUTQ until it returns 0.
+	 */
+	timeout_begin(TIMEOUT);
+	do {
+		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
+		if (ret < 0) {
+			if (errno == EOPNOTSUPP) {
+				fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
+				break;
+			}
 			perror("ioctl");
 			exit(EXIT_FAILURE);
 		}
-	} else if (ret == 0 && sock_bytes_unsent != 0) {
-		fprintf(stderr,
-			"Unexpected 'SIOCOUTQ' value, expected 0, got %i\n",
-			sock_bytes_unsent);
-		exit(EXIT_FAILURE);
-	}
-
+		timeout_check("SIOCOUTQ");
+	} while (sock_bytes_unsent != 0);
+	timeout_end();
 	close(fd);
 }
 
-- 
2.39.5



