Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31106364C1;
	Fri, 24 Nov 2023 18:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8X6JsKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDFEC433C8;
	Fri, 24 Nov 2023 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851207;
	bh=LaQkTibzop11ZYkMAwwl497ox55ulL/TQ5HSFzTXGy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8X6JsKPU4qZ/yaiRplHnoY2xqcyNOiSmYyBUQ4djeibKf8RxjkZJ51kFGMIX7aLR
	 qzQ4Og0mQe9r93nZZFle1vcecZX2lk8o0DH0NttS0gjSNm2SMofYaPxaIT3gVl/25M
	 1X8xEhdQbVQg6M94jFN3B+07rBU+bmhgbRBBHiYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.5 331/491] selftests/resctrl: Fix uninitialized .sa_flags
Date: Fri, 24 Nov 2023 17:49:27 +0000
Message-ID: <20231124172034.511853832@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit beb7f471847663559bd0fe60af1d70e05a1d7c6c upstream.

signal_handler_unregister() calls sigaction() with uninitializing
sa_flags in the struct sigaction.

Make sure sa_flags is always initialized in signal_handler_unregister()
by initializing the struct sigaction when declaring it. Also add the
initialization to signal_handler_register() even if there are no know
bugs in there because correctness is then obvious from the code itself.

Fixes: 73c55fa5ab55 ("selftests/resctrl: Commonize the signal handler register/unregister for all tests")
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/resctrl/resctrl_val.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 51963a6f2186..01bbe11a8983 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -482,7 +482,7 @@ void ctrlc_handler(int signum, siginfo_t *info, void *ptr)
  */
 int signal_handler_register(void)
 {
-	struct sigaction sigact;
+	struct sigaction sigact = {};
 	int ret = 0;
 
 	sigact.sa_sigaction = ctrlc_handler;
@@ -504,7 +504,7 @@ int signal_handler_register(void)
  */
 void signal_handler_unregister(void)
 {
-	struct sigaction sigact;
+	struct sigaction sigact = {};
 
 	sigact.sa_handler = SIG_DFL;
 	sigemptyset(&sigact.sa_mask);
-- 
2.43.0



