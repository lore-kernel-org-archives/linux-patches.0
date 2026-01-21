Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45643587B0;
	Wed, 21 Jan 2026 18:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019553; cv=none; b=esS3Pfd14zl6tQDR4lle1ofF6Cv2h0g9FWXYqdUcvCFe2p3C6FtQrZu3ym/G35umSxTdDlnkGGw3E3D8A/R3W0Ve+6DUpoaxAKqrl2kcZ3G/bLEPf6EJHENfH5JjV0E/poXcJsbs+MbZzujRPzlH8G7Qdx46S9CXUriHItJaa6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019553; c=relaxed/simple;
	bh=q/9ldyoUNExr7zfArlmoZsA9PvlOmg3ixm3tBgJMn2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPmflIOcgMMHhof6sFFMuNrOKUxXRxiKjsm5tQAfBKZwf10QbYmPE8g1CAptd/vswGOI58i7ZM5OC5+9LdsAwjHB2Iqj9FEX7LEbfuNb8k3mHCH/UrGs9UVSyYZ8LEEyfnhMjFy94oypPaja0UU8DP1TzYqh22P6S9fDPN+YHlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNdLpwhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNdLpwhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E35C4CEF1;
	Wed, 21 Jan 2026 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019553;
	bh=q/9ldyoUNExr7zfArlmoZsA9PvlOmg3ixm3tBgJMn2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNdLpwhyXSeXN4HqUSihX5i4Hb5nVeQwgpV8mHBDDqMP5Br02Hnkbv7eEG9wvki3M
	 GN25FkmHXkVZkgaMkzCGlx0s/WZQygdKI/XFNTzcwqZKhew0juEePtKxXE2Wb8nGzg
	 rn9uu1zpm0IQuSCuoXzYa5q6wq+qFbGYH7yOBX9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Leonardi <leonardi@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/139] vsock/test: add a final full barrier after run all tests
Date: Wed, 21 Jan 2026 19:14:30 +0100
Message-ID: <20260121181412.256494790@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a3d448a075e3a..8a899a9fc9a98 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -472,6 +472,18 @@ void run_tests(const struct test_case *test_cases,
 
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



