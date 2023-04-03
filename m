Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0056E6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77376C433D2;
	Mon,  3 Apr 2023 14:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533189;
	bh=UMk1yWcwvsggJJjnaJ9yTLb2WQw1KXCFuCFy3Q+rgHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O16ATLFyfIMw7c+EyTL6enJ4jOwImHQq7HxRKxfR/7THplyDW8GvRibyfgwhWkaLb
	 ZtmuM5DH8rgyVazX4mdVwfY1ZpeqdNufkcrmVyk9j1vzZ4CjeqB5MPMLvqy3YE1Z2u
	 LudPJoQ1e6PMZ2DZELhJebdxcCkklavMYg3MbkA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prarit Bhargava <prarit@redhat.com>,
	linux-pm@vger.kernel.org,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 057/187] tools/power turbostat: Fix /dev/cpu_dma_latency warnings
Date: Mon,  3 Apr 2023 16:08:22 +0200
Message-Id: <20230403140417.838998267@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prarit Bhargava <prarit@redhat.com>

[ Upstream commit 40aafc7d58d3544f152a863a0e9863014b6d5d8c ]

When running as non-root the following error is seen in turbostat:

turbostat: fopen /dev/cpu_dma_latency
: Permission denied

turbostat and the man page have information on how to avoid other
permission errors, so these can be fixed the same way.

Provide better /dev/cpu_dma_latency warnings that provide instructions on
how to avoid the error, and update the man page.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.8 | 2 ++
 tools/power/x86/turbostat/turbostat.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index c7b26a3603afe..3e1a4c4be001a 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -344,6 +344,8 @@ Alternatively, non-root users can be enabled to run turbostat this way:
 
 # chmod +r /dev/cpu/*/msr
 
+# chmod +r /dev/cpu_dma_latency
+
 .B "turbostat "
 reads hardware counters, but doesn't write them.
 So it will not interfere with the OS or other programs, including
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index aba460410dbd1..c24054e3ef7ad 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5482,7 +5482,7 @@ void print_dev_latency(void)
 
 	retval = read(fd, (void *)&value, sizeof(int));
 	if (retval != sizeof(int)) {
-		warn("read %s\n", path);
+		warn("read failed %s\n", path);
 		close(fd);
 		return;
 	}
-- 
2.39.2



