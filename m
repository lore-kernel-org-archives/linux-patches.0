Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6DF40FDAE;
	Wed,  4 Feb 2026 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216716; cv=none; b=gZpNiZzVnapBNluLOW2NC946moM3O2TWHdYzn7EwYcpeG2cUxYP9sPi/OKEEQtsmiRnoSiKWbjFWDeHp1/c6ncLOSBfpePKQCPyK2TZgpZFj7nTjGIQ3b600dM78alu9bui5stCxkqWNexZUqi8EOfk32zp83DJf1LRIcf6M9H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216716; c=relaxed/simple;
	bh=YG3f9gxnXOAykY+vDUGv2/kaBjOjARc7cNJjxbb9pyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrtgJSZ3KI/vUaMhilgmycmDPukSw6ZsSs5QPlrO744QvlH01ejlrWHK9H3Nn7yUTH1EqVYdwBfJMze/zRbcCH76nJg6/ATr/RjRZ+zVPLXTDB8b1cGOE9Du3kXHNei4cnVNDekToGJLOUHOE3NvPRg66N+oWC6k6PpyCiFHtqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjIH6twZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjIH6twZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE2DC4CEF7;
	Wed,  4 Feb 2026 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216716;
	bh=YG3f9gxnXOAykY+vDUGv2/kaBjOjARc7cNJjxbb9pyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjIH6twZOypvhuKDGc2ALYlojGTNNQDpBAzt8UJ/+E53jvn2JGPNmOBvpcRzM5VST
	 VU+v79UaQey8lgdRhbdmecuj+IGbkaS3dNB4plP/0JTLIQJ973jE/9hgkozalxyj9I
	 +gFW83u+RkUy/IKzWrUFAcIfGTwQ3R6IticYzCnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/206] vsock/test: add a final full barrier after run all tests
Date: Wed,  4 Feb 2026 15:37:21 +0100
Message-ID: <20260204143858.573006387@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit c39a6a277e0e67ffff6a8efcbbf7e7e23ce9e38c ]

If the last test fails, the other side still completes correctly,
which could lead to false positives.

Let's add a final barrier that ensures that the last test has finished
correctly on both sides, but also that the two sides agree on the
number of tests to be performed.

Fixes: 2f65b44e199c ("VSOCK: add full barrier between test cases")
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260108114419.52747-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/vsock/util.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 2acbb7703c6a0..259d33ae6293b 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -360,6 +360,18 @@ void run_tests(const struct test_case *test_cases,
 
 		printf("ok\n");
 	}
+
+	printf("All tests have been executed. Waiting other peer...");
+	fflush(stdout);
+
+	/*
+	 * Final full barrier, to ensure that all tests have been run and
+	 * that even the last one has been successful on both sides.
+	 */
+	control_writeln("COMPLETED");
+	control_expectln("COMPLETED");
+
+	printf("ok\n");
 }
 
 void list_tests(const struct test_case *test_cases)
-- 
2.51.0



