Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9A48468;
	Thu, 25 Jul 2024 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919161; cv=none; b=NZCa8oSXUTcVE3k/q15ABHiNJUtRS8K8RN+Xt3QkRCYLlt9FMDRowMedjA/U/RX6qtapNrGwrovG1YFs2pyTJVTPnVXuUpf5akZu5IzVheKMToLpIEdOO6GKQis89HIauW7ZGTfGkKxr7poYIMaZ2ClLT6lwTR4GD8slO7lH3aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919161; c=relaxed/simple;
	bh=Vu27ivGp2SXV1/KfEE9p2uPtmFPWRibVXZU7e6EAckk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPMMNMU0antsYTXYp3UHfx9jHodnoTSKwsmAzYt5tOWG7B1evJ31mbjR3BhoC36Ht9cLOXc5jBV8ANN/K5GOZJSpHvGOahveom17kxhzwBJrIkbrb/usDHLsaZ8EdK6emJmXRGq1m12fWN1jRtSF2wkUDceflCo4AzsLfjeHTIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFyT3LhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFyT3LhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E866C116B1;
	Thu, 25 Jul 2024 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919160;
	bh=Vu27ivGp2SXV1/KfEE9p2uPtmFPWRibVXZU7e6EAckk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFyT3LhUrbPUfwGmn0PyXfP/92H72ILNJMnx2cF+VtBbsj9V9MuIZH4iUHwBdk4uV
	 25ntPMhPislasKuHnhBPPTtAkQ5zJ9zpeyT6ZNs34EgGiyxd3LkBeKPOzpdWuY2s3a
	 qFihKa6patolF+TBa+wb/GoBDa1RSZv059jyPN68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/87] s390/sclp: Fix sclp_init() cleanup on failure
Date: Thu, 25 Jul 2024 16:37:16 +0200
Message-ID: <20240725142740.058367572@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2cf7fe131ecec..0830ea42e7c80 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -1292,6 +1292,7 @@ sclp_init(void)
 fail_unregister_reboot_notifier:
 	unregister_reboot_notifier(&sclp_reboot_notifier);
 fail_init_state_uninitialized:
+	list_del(&sclp_state_change_event.list);
 	sclp_init_state = sclp_init_state_uninitialized;
 	free_page((unsigned long) sclp_read_sccb);
 	free_page((unsigned long) sclp_init_sccb);
-- 
2.43.0



