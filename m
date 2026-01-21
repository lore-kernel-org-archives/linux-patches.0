Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA357392B76;
	Wed, 21 Jan 2026 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020166; cv=none; b=RfzjBdq6uXkSabwk+2xv7FpCkLqWX71XneuAIUkBmqTdMX7sYuBAOxFuORgbUQqz4dxGXHK2svEbJyG20Tk7/fQQGhtrVcsGf9V6+gKihI5Bv1m1SfRW16kuhEgC1br6IuxrzDIFz/6SDLeeiWapesF6rKi7TX1jvLW+jAIBtUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020166; c=relaxed/simple;
	bh=yR0dwN9RpHyVkE/bNuc0owC/HJJUEqL8/pWEoGzIiGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bBb5GgVGds4dgfZaCS99HNIoWN66wSJi8xYyT0gdS1LMCnh7FYe1eFn99AkETE9rz2FlOY6HP2dtcrC5zNAeGD/y7GKB084yPjc/ktFxuW9GbzesYgly0HM4EoWxSXkbxEF7+XdLmNbZJspPxfp8a7plS7meKxsVCzqGa8lHRjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tc/x2o8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tc/x2o8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317ABC4CEF1;
	Wed, 21 Jan 2026 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020165;
	bh=yR0dwN9RpHyVkE/bNuc0owC/HJJUEqL8/pWEoGzIiGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tc/x2o8E6WJXhCfQcOtBm4lXSBSUMpJeF9OH343AlUxVGvzvRtRMhwPfyIVTdf6Nh
	 JDvfG3JeEYcmgmvmsdA27InxuLd4if/N6I8LleNvr21f3/mhpZMKL12epPLCjz1gcc
	 n884cTH4sIc7Rst+KfWn+gxZp48Grbu8NeLgrJjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/198] selftests/landlock: Remove invalid unix socket bind()
Date: Wed, 21 Jan 2026 19:15:07 +0100
Message-ID: <20260121181421.404621086@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Buffet <matthieu@buffet.re>

[ Upstream commit e1a57c33590a50a6639798e60a597af4a23b0340 ]

Remove bind() call on a client socket that doesn't make sense.
Since strlen(cli_un.sun_path) returns a random value depending on stack
garbage, that many uninitialized bytes are read from the stack as an
unix socket address. This creates random test failures due to the bind
address being invalid or already in use if the same stack value comes up
twice.

Fixes: f83d51a5bdfe ("selftests/landlock: Check IOCTL restrictions for named UNIX domain sockets")
Signed-off-by: Matthieu Buffet <matthieu@buffet.re>
Reviewed-by: Günther Noack <gnoack@google.com>
Link: https://lore.kernel.org/r/20251201003631.190817-1-matthieu@buffet.re
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index fa0f18ec62c41..a6eb9681791a5 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -4375,9 +4375,6 @@ TEST_F_FORK(layout1, named_unix_domain_socket_ioctl)
 	cli_fd = socket(AF_UNIX, SOCK_STREAM, 0);
 	ASSERT_LE(0, cli_fd);
 
-	size = offsetof(struct sockaddr_un, sun_path) + strlen(cli_un.sun_path);
-	ASSERT_EQ(0, bind(cli_fd, (struct sockaddr *)&cli_un, size));
-
 	bzero(&cli_un, sizeof(cli_un));
 	cli_un.sun_family = AF_UNIX;
 	strncpy(cli_un.sun_path, path, sizeof(cli_un.sun_path));
-- 
2.51.0



