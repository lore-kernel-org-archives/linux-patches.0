Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1CF211C;
	Tue, 30 Apr 2024 11:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475487; cv=none; b=KV7Uu+xjPiFE7r3vtDok68pvA77jr2qXZ3mSfPgTtAAfhlFFxTwl31xk6G9NKkEqQcRyG8A6FwYTXjTolr82jlWBLKmI11GWbBPoe5dVs8o/xieNXxOfV81jjvqQv6jTyuSb+Mm96QlnxcDDBHmlWe/AtCvf7r81nCPHi/0lfP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475487; c=relaxed/simple;
	bh=sSBpdqNHnsW8KsoKYI0yl12W2l1SfqkpVEWxXtmK5sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsyZoIWCEJg8vuaYuHurXVFwjH3qAe6C0jliOasXdxugo6ObmLgrs8Hfvk5/EBMmcIiqo++xRKgjloHLpwdcwBqOJjPJBQLdJYp8mVDAMQiHSZ3ffAyv2VX5QMHk1AqO0kV2mYs4JXr23nHpIezmc8pEbtVkrtqiuhAgnRg1GXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcYXXi9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcYXXi9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECD5C2BBFC;
	Tue, 30 Apr 2024 11:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475487;
	bh=sSBpdqNHnsW8KsoKYI0yl12W2l1SfqkpVEWxXtmK5sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcYXXi9VE7/uXQ2IeEzhmUsseQx3Gs09rpMbktbP6l01yGTtrsyTD8IPTLIXfeM28
	 C+/2QDTeBq5VTK0BuwqwA7PpUmZPz1KoDrh5DNcuH9WG8+My9Dat3VhhP2i8w6BZxL
	 HmYnWD5Y7wn/rz77PjqS6mnjEv91gDl5ymv8PvYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.6 109/186] selftests/seccomp: Handle EINVAL on unshare(CLONE_NEWPID)
Date: Tue, 30 Apr 2024 12:39:21 +0200
Message-ID: <20240430103101.197772428@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Tritton <terry.tritton@linaro.org>

commit ecaaa55c9fa5e8058445a8b891070b12208cdb6d upstream.

unshare(CLONE_NEWPID) can return EINVAL if the kernel does not have the
CONFIG_PID_NS option enabled.

Add a check on these calls to skip the test if we receive EINVAL.

Signed-off-by: Terry Tritton <terry.tritton@linaro.org>
Link: https://lore.kernel.org/r/20240124141357.1243457-2-terry.tritton@linaro.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3709,7 +3709,12 @@ TEST(user_notification_sibling_pid_ns)
 	ASSERT_GE(pid, 0);
 
 	if (pid == 0) {
-		ASSERT_EQ(unshare(CLONE_NEWPID), 0);
+		ASSERT_EQ(unshare(CLONE_NEWPID), 0) {
+			if (errno == EPERM)
+				SKIP(return, "CLONE_NEWPID requires CAP_SYS_ADMIN");
+			else if (errno == EINVAL)
+				SKIP(return, "CLONE_NEWPID is invalid (missing CONFIG_PID_NS?)");
+		}
 
 		pid2 = fork();
 		ASSERT_GE(pid2, 0);
@@ -3727,6 +3732,8 @@ TEST(user_notification_sibling_pid_ns)
 	ASSERT_EQ(unshare(CLONE_NEWPID), 0) {
 		if (errno == EPERM)
 			SKIP(return, "CLONE_NEWPID requires CAP_SYS_ADMIN");
+		else if (errno == EINVAL)
+			SKIP(return, "CLONE_NEWPID is invalid (missing CONFIG_PID_NS?)");
 	}
 	ASSERT_EQ(errno, 0);
 


