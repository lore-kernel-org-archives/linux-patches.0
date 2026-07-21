Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30AB3C9ED9;
	Tue, 21 Jul 2026 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659321; cv=none; b=nI4QHMbPuFpLxtf8eehPlRsP/c/q2hhAT3h6fvnrW+juNMf2PfwVOa0qor3BpynBKFAP3yjD/ZBOHxpwOPp2Kbb4F6dVaBM3oxGMUQIKUUoIDjBsiMJ18pAsLqTVhdyygkqwG5l/3RNc/8oqa/ROyTzSQ60kN3gfMEMXlPUPPFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659321; c=relaxed/simple;
	bh=PcgwIwUOee+jX1Dwpxg6RFYvxZAf+rxCX6NegVdDqaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bLl6MJT5d6jKkQ/5OTNdol1xNKWYWFMwcvrKaU3Gnf9uxZFykBwOJG0OH4V9oSF/E2IKx2ONQsb3Omkvla38e2VLRIwCkWP77xON/APux9e2/WuFswd/CKOBU3tTPhPIxNlI81GPQxx8ZG4hjAuayjnt8wNQy3sP1ZHChktzHdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3DkhIfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3DkhIfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5E21F000E9;
	Tue, 21 Jul 2026 18:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659319;
	bh=wJPVzqsTU8isIXTy7sr/GojuA89v+oKvxV31iy6x0v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3DkhIfLmFew27/0CaufWLEbVjXlLQu7LBZK4RgbAE0VDEKktEBUPOQB5xD0lc+1h
	 idk0dJeXPt9ua9keXHubl/vVHewBpBYEsXTdXw41KrVQ2f6SIawWHR2cX0V306Pl0U
	 uwaRR9y2SUrB/Lsv26YVTiZrxfYFThy/EOXGktpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.18 1475/1611] selftests/landlock: Skip scoped_signal subtest with MSG_OOB if not available
Date: Tue, 21 Jul 2026 17:26:31 +0200
Message-ID: <20260721152548.623933459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


