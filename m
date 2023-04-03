Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15FA6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7744EC433D2;
	Mon,  3 Apr 2023 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532356;
	bh=hK+x42Q/uF3uttO6IsFrAqE3HDLQUzKmJcaBgft0unU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcqfrREAbZ1ha9TpqjSU7GqDeq+y6E1N8HV9Rqv/WjGVO9Utk6AdKQK6HOhLj75pl
	 YzOR95YaK0SiMsbHsC/0KbBdcyzrPBikCc1XWOp0gnYTaseOrJuZDmnCQ/nj6BLWcE
	 LEqeFXhfLuAWw8myksC88Y1gow3sbamgfvVZ/kRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prarit Bhargava <prarit@redhat.com>,
	linux-pm@vger.kernel.org,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/99] tools/power turbostat: Fix /dev/cpu_dma_latency warnings
Date: Mon,  3 Apr 2023 16:08:44 +0200
Message-Id: <20230403140402.135850666@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
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
index 9b17097bc3d7b..b3d4bf08e70b1 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -296,6 +296,8 @@ Alternatively, non-root users can be enabled to run turbostat this way:
 
 # chmod +r /dev/cpu/*/msr
 
+# chmod +r /dev/cpu_dma_latency
+
 .B "turbostat "
 reads hardware counters, but doesn't write them.
 So it will not interfere with the OS or other programs, including
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 4f176bbf29f42..84b8a35c91972 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5237,7 +5237,7 @@ void print_dev_latency(void)
 
 	retval = read(fd, (void *)&value, sizeof(int));
 	if (retval != sizeof(int)) {
-		warn("read %s\n", path);
+		warn("read failed %s\n", path);
 		close(fd);
 		return;
 	}
-- 
2.39.2



