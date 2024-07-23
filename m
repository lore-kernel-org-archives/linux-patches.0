Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA416156F29;
	Tue, 23 Jul 2024 18:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759380; cv=none; b=hZe0Caf+tyTK/TtUPbaxYoe7N8fj7COE1xpKXFHRaKTr54eYHOYNux010W9GRNGFo6/d4ffNR8a15UVqIC9Ld5fflGRt4akC0P1qznXD6KCS/hFzXg5Zj+vpID7VXizVDMnzYMXis+5gOq5iWKxTvaCjUzNNsdIHjmXppmLHWfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759380; c=relaxed/simple;
	bh=/e0D/7SXLsMeoWuOGM7zOkZ8tAOsISVJ2bNCgyhY9Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzG/8fQlRTc5xuilbxnAxUCQVhTwDii2noRsPKYxijrqh43EYOMWYh5njyt0w0HzyPmro84TuWb3EhTNNvrhqB1E3iRoRTi76CUyO8k6YhjTOgBXB3fteIs/ZWqoGXOeB304cfhInAKFPulvh4E/ByFPu+AvArMrqGU7fLGhw4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cMr8uR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cMr8uR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1AAC4AF09;
	Tue, 23 Jul 2024 18:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759379;
	bh=/e0D/7SXLsMeoWuOGM7zOkZ8tAOsISVJ2bNCgyhY9Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cMr8uR2BONnZdeTfN+hKnrCg7mKB//51kmvNw/VZ7UfKaD8XCY2ltklNvjAbSHM/
	 VOgjoGn7lbX83MWg0FvVB1KEa2IYpY61gz54IFBJWM+XWb/FtzPShozg6foeu8TTaw
	 7UWhHHfxFG6k2S1yELuvlA6tiaMudEmT5ztu/mXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/105] s390/sclp: Fix sclp_init() cleanup on failure
Date: Tue, 23 Jul 2024 20:23:42 +0200
Message-ID: <20240723180405.751833384@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 6434b33faaa063df500af355ee6c3942e0f8d982 ]

If sclp_init() fails it only partially cleans up: if there are multiple
failing calls to sclp_init() sclp_state_change_event will be added several
times to sclp_reg_list, which results in the following warning:

------------[ cut here ]------------
list_add double add: new=000003ffe1598c10, prev=000003ffe1598bf0, next=000003ffe1598c10.
WARNING: CPU: 0 PID: 1 at lib/list_debug.c:35 __list_add_valid_or_report+0xde/0xf8
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.10.0-rc3
Krnl PSW : 0404c00180000000 000003ffe0d6076a (__list_add_valid_or_report+0xe2/0xf8)
           R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
...
Call Trace:
 [<000003ffe0d6076a>] __list_add_valid_or_report+0xe2/0xf8
([<000003ffe0d60766>] __list_add_valid_or_report+0xde/0xf8)
 [<000003ffe0a8d37e>] sclp_init+0x40e/0x450
 [<000003ffe00009f2>] do_one_initcall+0x42/0x1e0
 [<000003ffe15b77a6>] do_initcalls+0x126/0x150
 [<000003ffe15b7a0a>] kernel_init_freeable+0x1ba/0x1f8
 [<000003ffe0d6650e>] kernel_init+0x2e/0x180
 [<000003ffe000301c>] __ret_from_fork+0x3c/0x60
 [<000003ffe0d759ca>] ret_from_fork+0xa/0x30

Fix this by removing sclp_state_change_event from sclp_reg_list when
sclp_init() fails.

Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/sclp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index ae1d6ee382a50..889d719c2d1f9 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -1290,6 +1290,7 @@ sclp_init(void)
 fail_unregister_reboot_notifier:
 	unregister_reboot_notifier(&sclp_reboot_notifier);
 fail_init_state_uninitialized:
+	list_del(&sclp_state_change_event.list);
 	sclp_init_state = sclp_init_state_uninitialized;
 	free_page((unsigned long) sclp_read_sccb);
 	free_page((unsigned long) sclp_init_sccb);
-- 
2.43.0



