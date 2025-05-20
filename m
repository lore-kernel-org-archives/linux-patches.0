Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02B824888A;
	Tue, 20 May 2025 14:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750131; cv=none; b=CGVeW5f48H1LXbdu0ZP2SPIH/yT4QHQO4QUfNYaG+cHuatfoQFnAFsLCzWZzk0+q0yCdYQSi1L8xEnM7KPioxhP/hUaeSxaxkVZjD9sqS0b2O5Fp7qEZyu/IG/X6d3Th0+0KaHi4MPJ1LLfV8FfEsaS1NLsgicuDsLgZhLC1SKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750131; c=relaxed/simple;
	bh=TsVCdENJPdoJpDk/EecBTngIQ2X+PCx7OC20U19vP2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6CBaVzLwzS6eDV04fHgecN4I32wRcmcVnzjGFYlk0JRxtPF1uISGjQxoNiTqWhjxM48nDnnvWzsgmncMQ//eknskXJIlO/Q4/ekdjBbjoVPUklUCcBrPGMJnGUkAaOj/dSNBs6RO/4xK/G02lNIMC5oQm59vzQZ/92dRYsVc1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZF2AagZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZF2AagZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE4CC4CEE9;
	Tue, 20 May 2025 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750131;
	bh=TsVCdENJPdoJpDk/EecBTngIQ2X+PCx7OC20U19vP2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZF2AagZc9X+wxNIDsJUsm9FU2Ljqn2ao1P9hFF5YK8Yqug7X7GSY3Lx6s3HcyE1DA
	 wP9lGx5GZZ1zDCcW0O5Dgqpj1Sz0Ma7WbWWI1lIIvGsB0uIvdS3t5VDhzDsk2dMyDZ
	 mH3ztGSiNnvBiHupFABfaQ93VI4XfBdhrUd9B9xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Shkolnyy <kshk@linux.ibm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/143] vsock/test: Fix occasional failure in SIOCOUTQ tests
Date: Tue, 20 May 2025 15:50:08 +0200
Message-ID: <20250520125812.133858679@linuxfoundation.org>
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
index 0b7f5bf546da5..0c22ff7a8de2a 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1283,21 +1283,25 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
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



