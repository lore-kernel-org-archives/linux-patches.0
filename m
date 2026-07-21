Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9EE46C4D3;
	Tue, 21 Jul 2026 17:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655210; cv=none; b=De99Hx8Z7SkBWjB3YV0r+g5Sz3Jn9rMDL0TTOmDvSHHws6EC6MXMDfQFbw2nTRD2wH96atPMFc8cyXCOS4favmSycFl39E8wleqihVfYvFTo0VzjXsEWvhTi+LQOVuVhlOenM3PKsadIvUJ6dGyrapPQBDxRrmsmTneE6LJTBZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655210; c=relaxed/simple;
	bh=4iO+rgqr1hRkbdFrPd62IYjMOs9IP0Wdr0OURimkJYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OVB5tmKlhRvvA3oUzVOU4xdxfbsljwnki6V30J2XWjQ8KOebiz5doL4mx295/UE7pdjTb7drsJ/N587SWx+7SjdISLCSsY+BZ6qhvk1kW4YfzbcRXxp8kqFwkK/5TNM/YtsBNEfAoq76kZ5QEAVQQctIrBT2imgIGPbdW9RGFKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcTF49s7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcTF49s7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BBB1F000E9;
	Tue, 21 Jul 2026 17:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655208;
	bh=gVC+ieW3M3UB6ot/5ELKVSiuhuVmrs3A9AFyP/pTqno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcTF49s7s1jAzX6WOMuTvuAWMqGY1k6jM5svoFD9H2dKAptnW3pqpiq/oYGfMI378
	 a63fdH1YPU26OT+57lkLcaG/xYwCE+QO3yBZogLnMYRavizlCOSHLDz7ps2CDrs+r2
	 udSNtA8njeqAF/rJWF1C0VvV56P/m98BBJMQXu78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 7.1 1998/2077] selftests/landlock: Skip scoped_signal subtest with MSG_OOB if not available
Date: Tue, 21 Jul 2026 17:27:51 +0200
Message-ID: <20260721152639.838382606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/landlock/scoped_signal_test.c |   21 ++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/tools/testing/selftests/landlock/scoped_signal_test.c
+++ b/tools/testing/selftests/landlock/scoped_signal_test.c
@@ -400,6 +400,24 @@ static int setup_signal_handler(int sign
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
 


