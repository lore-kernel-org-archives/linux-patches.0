Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F7E41238
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwXZ80hZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978FDC433CC;
	Wed, 15 Nov 2023 19:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076859;
	bh=spnA0tdjKs01s53+aBG2tJJW9IzNYyecRmYc5KHq+rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwXZ80hZDjzXUr93Hf8VJhTPUGettq8aY1jPbk9ruKh+DMC2OybyCH+xQnusZb3Fo
	 mWYKJm9Ioo98N8IQNs6PCfIoywATnEOxz43Y0naWjTau1tB/rqGwiKUOoy8/U3RwSw
	 46JHd81J3Qda93XvbyBa7G4uX5nNcNV49sUkB55o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/603] selftests/x86/lam: Zero out buffer for readlink()
Date: Wed, 15 Nov 2023 14:09:36 -0500
Message-ID: <20231115191615.336203599@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Binbin Wu <binbin.wu@linux.intel.com>

[ Upstream commit 29060633411a02f6f2dd9d5245919385d69d81f0 ]

Zero out the buffer for readlink() since readlink() does not append a
terminating null byte to the buffer.  Also change the buffer length
passed to readlink() to 'PATH_MAX - 1' to ensure the resulting string
is always null terminated.

Fixes: 833c12ce0f430 ("selftests/x86/lam: Add inherit test cases for linear-address masking")
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20231016062446.695-1-binbin.wu@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/x86/lam.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/x86/lam.c b/tools/testing/selftests/x86/lam.c
index eb0e46905bf9d..8f9b06d9ce039 100644
--- a/tools/testing/selftests/x86/lam.c
+++ b/tools/testing/selftests/x86/lam.c
@@ -573,7 +573,7 @@ int do_uring(unsigned long lam)
 	char path[PATH_MAX] = {0};
 
 	/* get current process path */
-	if (readlink("/proc/self/exe", path, PATH_MAX) <= 0)
+	if (readlink("/proc/self/exe", path, PATH_MAX - 1) <= 0)
 		return 1;
 
 	int file_fd = open(path, O_RDONLY);
@@ -680,14 +680,14 @@ static int handle_execve(struct testcases *test)
 		perror("Fork failed.");
 		ret = 1;
 	} else if (pid == 0) {
-		char path[PATH_MAX];
+		char path[PATH_MAX] = {0};
 
 		/* Set LAM mode in parent process */
 		if (set_lam(lam) != 0)
 			return 1;
 
 		/* Get current binary's path and the binary was run by execve */
-		if (readlink("/proc/self/exe", path, PATH_MAX) <= 0)
+		if (readlink("/proc/self/exe", path, PATH_MAX - 1) <= 0)
 			exit(-1);
 
 		/* run binary to get LAM mode and return to parent process */
-- 
2.42.0



