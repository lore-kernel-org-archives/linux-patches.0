Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6371F217F34;
	Thu, 12 Dec 2024 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018057; cv=none; b=YssGaHlKuxtrjRLL/VtYLCTFkPQYuLiY2/thWljPF1Mb5s8YO9sQyMz3KHFLf43bB3K73RH/wBWQyU3gDSz8sjvwjDe53qfry5I91U8KlNQT//pdySL5a8z6DLrkeiwJdXpGPUkV4f/W0FbXPGez02gUaZ4BA7n9wdecH3hqL1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018057; c=relaxed/simple;
	bh=SIOH4DvyNCtk8sucXaN6ljvUsQ6qpsSYs2aXNnXmOO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aj1Hg5WRH8W6WoBw7Fr7Sn5CoQcgm+3RjjJ/x4fI1j7zlauj70aZ3fEc7Ix75jK5b6nB0qYSWz2YfbzNSUAXFYPuWJnu+rM6N9FLS2RtolBThZeW1ZxIrVjCVNhBl9BQ/MIKQWp9E+qmyW4dAvekkTMFGu6zfvgrj2x+zxVR/f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7orQqzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7orQqzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB69CC4CECE;
	Thu, 12 Dec 2024 15:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018057;
	bh=SIOH4DvyNCtk8sucXaN6ljvUsQ6qpsSYs2aXNnXmOO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7orQqzEASBCjbz9VPF8sJDkxrynQm1i2ZF2EikjXKMFrxX0yD+iE30x5il6ULzoI
	 YBjFquGX1v1EZnZkGgJM5fSwNM+PkCI0rndhpwE2WVriBgTjnnL2zutYbCHZEeRN9R
	 LUInA4Ik4sej2EyvHhIGDkP+BLAoqebIvt1V5N10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/356] kselftest/arm64: Log fp-stress child startup errors to stdout
Date: Thu, 12 Dec 2024 15:58:24 +0100
Message-ID: <20241212144251.937348915@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit dca93d29845dfed60910ba13dbfb6ae6a0e19f6d ]

Currently if we encounter an error between fork() and exec() of a child
process we log the error to stderr. This means that the errors don't get
annotated with the child information which makes diagnostics harder and
means that if we miss the exit signal from the child we can deadlock
waiting for output from the child. Improve robustness and output quality
by logging to stdout instead.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241023-arm64-fp-stress-exec-fail-v1-1-ee3c62932c15@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/fp/fp-stress.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/arm64/fp/fp-stress.c b/tools/testing/selftests/arm64/fp/fp-stress.c
index dd31647b00a22..cf9d7b2e4630c 100644
--- a/tools/testing/selftests/arm64/fp/fp-stress.c
+++ b/tools/testing/selftests/arm64/fp/fp-stress.c
@@ -79,7 +79,7 @@ static void child_start(struct child_data *child, const char *program)
 		 */
 		ret = dup2(pipefd[1], 1);
 		if (ret == -1) {
-			fprintf(stderr, "dup2() %d\n", errno);
+			printf("dup2() %d\n", errno);
 			exit(EXIT_FAILURE);
 		}
 
@@ -89,7 +89,7 @@ static void child_start(struct child_data *child, const char *program)
 		 */
 		ret = dup2(startup_pipe[0], 3);
 		if (ret == -1) {
-			fprintf(stderr, "dup2() %d\n", errno);
+			printf("dup2() %d\n", errno);
 			exit(EXIT_FAILURE);
 		}
 
@@ -107,16 +107,15 @@ static void child_start(struct child_data *child, const char *program)
 		 */
 		ret = read(3, &i, sizeof(i));
 		if (ret < 0)
-			fprintf(stderr, "read(startp pipe) failed: %s (%d)\n",
-				strerror(errno), errno);
+			printf("read(startp pipe) failed: %s (%d)\n",
+			       strerror(errno), errno);
 		if (ret > 0)
-			fprintf(stderr, "%d bytes of data on startup pipe\n",
-				ret);
+			printf("%d bytes of data on startup pipe\n", ret);
 		close(3);
 
 		ret = execl(program, program, NULL);
-		fprintf(stderr, "execl(%s) failed: %d (%s)\n",
-			program, errno, strerror(errno));
+		printf("execl(%s) failed: %d (%s)\n",
+		       program, errno, strerror(errno));
 
 		exit(EXIT_FAILURE);
 	} else {
-- 
2.43.0



