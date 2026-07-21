Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAF4472F60;
	Tue, 21 Jul 2026 20:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664193; cv=none; b=iHVBePJb61qUHmmTF7TVfWQlsVU2PSRpugH2EfdB1AET01u9ykTkkJQ0NI2hcZtgvoGkrhcvUx1lCrE88QhrV0MN8P69K1Ze+JYSxK0ViKvCMuFlpzycAE0+Sk4/tZ520AUo+CKIetBroTyPa/zG1LdXHMshj+ByWHw9CL+eQvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664193; c=relaxed/simple;
	bh=7/fLkW1jOvBCTCEPaA/b9Y6gUTG3740f5VAhhMaeb/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WmRkSoqUIH2n9gcv9V/yhp9z5F8DH7TFC1K0y8xr6L0uGvGlvzbw9Jp3brOeiQdXAjAuURXG6S8y4HNhjGZ81+Ew7FGTln+9g4dTM99DSouwWA12XJwG5hgfbd4Z87m+4u5Hgp4GSuNTODMkmrZV17IVKkZLnFYxVfAdAF4Sj5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dh8f5s03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dh8f5s03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909B21F000E9;
	Tue, 21 Jul 2026 20:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664189;
	bh=eOE+mCuRzY5fQruYMAWzJRqDWMmfSseHnhAtSkmF2H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dh8f5s03z9CRAstDtnPBHxasVJho80zZt3N8X12cqBCyGHNFfcqyxOEcNsECP6Gja
	 xpydRgAAzfAJc12IN9B46aIlSCnPAoYW5lbSUcrUCuGbBRPYrkVv22LKq2GzYTVH33
	 UXjjCli27LyWzgj6lcHwo2xFtnViqI+ZA3kjWqzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.12 1104/1276] selftests/landlock: Skip scoped_signal subtest with MSG_OOB if not available
Date: Tue, 21 Jul 2026 17:25:47 +0200
Message-ID: <20260721152510.695897383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Huth <thuth@redhat.com>

commit 5ab1dc6d110db6bee167a32fd94c53ea0e7ad6d2 upstream.

MSG_OOB might be disabled in the kernel for unix sockets (by not
selecting CONFIG_AF_UNIX_OOB), and in this case the related tests
of the scoped_signal_test are currently failing.  Add a runtime
probe using socketpair() to detect MSG_OOB support and skip the
test gracefully if it is unavailable.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Link: https://patch.msgid.link/20260710081642.405916-1-thuth@redhat.com
Cc: stable@vger.kernel.org
Fixes: f34e9ce5f479 ("selftests/landlock: Test signal created by out-of-bound message")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../selftests/landlock/scoped_signal_test.c   | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/landlock/scoped_signal_test.c b/tools/testing/selftests/landlock/scoped_signal_test.c
index 3f0cd42a2afe..2d37d0c06c06 100644
--- a/tools/testing/selftests/landlock/scoped_signal_test.c
+++ b/tools/testing/selftests/landlock/scoped_signal_test.c
@@ -400,6 +400,24 @@ static int setup_signal_handler(int signal)
 	return sigaction(SIGURG, &sa, NULL);
 }
 
+/*
+ * MSG_OOB might be disabled in the kernel via the CONFIG_AF_UNIX_OOB
+ * switch, so this function can be used for probing for its availability.
+ */
+static bool has_af_unix_oob(void)
+{
+	bool available = false;
+	int sp[2];
+
+	if (socketpair(AF_UNIX, SOCK_STREAM, 0, sp) == 0) {
+		available = (send(sp[0], ".", 1, MSG_OOB) == 1);
+		close(sp[0]);
+		close(sp[1]);
+	}
+
+	return available;
+}
+
 /* clang-format off */
 FIXTURE(fown) {};
 /* clang-format on */
@@ -462,6 +480,9 @@ TEST_F(fown, sigurg_socket)
 	int pipe_parent[2], pipe_child[2];
 	pid_t child;
 
+	if (!has_af_unix_oob())
+		SKIP(return, "CONFIG_AF_UNIX_OOB / MSG_OOB not available");
+
 	memset(&server_address, 0, sizeof(server_address));
 	set_unix_address(&server_address, 0);
 
-- 
2.55.0



