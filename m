Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8DE3559ED;
	Wed, 21 Jan 2026 18:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020025; cv=none; b=ivJ4Dq36sL2wLAvsAhWBDIItnXKcpPfP4Hzyn6C5DBigDm+nIwv/N141XxZPiLkmv4wKpWukiDBTdDgp8pIP7vOfkXolPefHArFx3mCtg6660SVC8OBaCVL6OFAMQuULBCUhbBW1RYvvV45Z9pV5LJCE2ryJrNomh+0HmtyjVOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020025; c=relaxed/simple;
	bh=twP5nqGJD00tZZexHsw5EhtjLsuMSMIMRcRlOdGRjSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ni35oRYVKTc8IPBANcX4OjkBEwYuK1tHxYzRUAfFJBw3GfFPU9QlDNvTLt/oYWDYKCcp7CJ/uCMq0OHU7CsRcmN1uCGQnyhoP/HoGooPEcyNa4X6qoM6PwXcZOaDPki6y8oJnpTMLe3EG+Y2IPIzQFLpPydEbS9FgJVkYnFyvc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqTrAYPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqTrAYPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6734C4CEF1;
	Wed, 21 Jan 2026 18:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020025;
	bh=twP5nqGJD00tZZexHsw5EhtjLsuMSMIMRcRlOdGRjSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqTrAYPKuZM9pf0CqTdtiVfQBwFU4Zsfsiw2krDiuDZPALeNObx1+uG7+YO4gAeup
	 hSEczVuESDe03TYq9xhNpFIM/5bbOIsqO4EDhSHOI32P/OaB2f/K3V59ZqdpkWElQW
	 vwE2lRzS493VzZjwc/3Rkqq/ZmZYVw/8t5Kljbqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/198] vsock/test: add a final full barrier after run all tests
Date: Wed, 21 Jan 2026 19:14:26 +0100
Message-ID: <20260121181419.920958790@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d843643ced6b7..9430ef5b8bc3e 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -511,6 +511,18 @@ void run_tests(const struct test_case *test_cases,
 
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



