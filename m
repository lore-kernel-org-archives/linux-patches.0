Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6527D42314E;
	Wed,  4 Feb 2026 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217493; cv=none; b=Vd2gszo92NtYBqe13NsxARYx70ftRJOcPbux4GCvUQcs0XJlSARCvUeTiw2qcvIT371jlKEv79xr21wKcFgl/WzQETXzZnWtpmmzH5SbsgDA7xEhYFL855X093iI5Y/WvA/ZdRjU4YIvFZiUgKzRX2gLQH8J+/TTW84RtkUXC3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217493; c=relaxed/simple;
	bh=2LE8zAJ+/vC3Fv0WquBjOQZxyQMlxxUXzZSWnIftcQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRuZl8NhV3ug2Hl5MiwQYP2JORAd1jAB6lAgLLwcn9C7FwM8Stlp8vklvEqkrOMCRidgnACd5Wkwdf6/rz22sx6+e+gZk1YYi3u1OwuQISpqdTpw7HfWEQGf0ywTUZJpmv6KBk5PSM6hlwYEKd5R2cOJUZ4aHzBDVE1U/oyL/iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVWlSid8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVWlSid8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE687C4CEF7;
	Wed,  4 Feb 2026 15:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217493;
	bh=2LE8zAJ+/vC3Fv0WquBjOQZxyQMlxxUXzZSWnIftcQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVWlSid8o6VMpqNvxIpY767W6hTbAfhdZiVDOct7DK0hVxS4dXLfqZs0gYNtFfy0D
	 wrmPgOX8VxAvB6uhYBGFjlGVwSPBCi/KCXYizU9JxovTZ9ZacEjL22XHbceaNDAQ/B
	 slsBaMVSr9iLgsgMw3DyBSvI28PmKs+Q4eK8WzHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/280] vsock/test: add a final full barrier after run all tests
Date: Wed,  4 Feb 2026 15:36:28 +0100
Message-ID: <20260204143910.143907528@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



