Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047AC3806AF;
	Sat, 12 Sep 2026 09:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205089; cv=none; b=boKyRiHQxGR9PBtPk88gu98eC5UkX0X7IQo+tdcj5b/MWVWEzzHGopdFZNem96SGILGIflgxYvWdIR2qqmjBuyabtZDfv0ocURWzBbUDeu1d0lOV6kfJoTpTX25Zic2dailjZPIuXCFN2frImVqCYjN6FZ1kS3LlmLZWUHRkDSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205089; c=relaxed/simple;
	bh=xtqd84q2d4MUQaAsb/ZqwxmYtgPUUI/tc0WiuY92NJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ2L+wyMEQ2BS6JNBk+yjqQIQhfObNawtsVuuyZIPnY+Kj0e8PlOCMJQ1UujhzPuIfrp0t2aqOQM+jENSIplMoPwP80Njp+3jlZpp9x+sA7KKHwN9oy/LxLSGF98NV0WqpMEHkOG6hRJoqI4MtEV+Xja7gWQrmyL58ZeUrQQIqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ismREKZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ismREKZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2421F00893;
	Sat, 12 Sep 2026 09:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205087;
	bh=JXdhExYWbnwLkTlGCY4/kG8xwMkeVI/kPpKI15BLUTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ismREKZhdebJnqF/FprRXoljPyUeuo9HzSOZJTbYb/VONEzb4/kCMBelGWsAVsyU4
	 q0RSbP07Tzd92JyNlMFvFyWLSqFaF5VQyWswhOXObKLPNuDU9/2Qv5Ia0seQ9xJ5b2
	 7YxM3Pvj732KJEOr/XDpMtJgWJlHManiblEBW27w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1747/1815] cifs: fix clearing stats for fastest execution of each smb2 command
Date: Sat, 12 Sep 2026 08:58:17 +0200
Message-ID: <20260912065729.997407865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 48cab1fd5720508148673f59d8ed52c7c7fffca2 ]

The code to clear the 'fastest_cmd' statistics has a typo that
repeatedly clears the stat for cmd 0, rather than iterating
through each cmd.  Fix the typo (0->i).

Fixes: 433b8dd7672be ("SMB3: Track total time spent on roundtrips for each SMB3 command")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 4ed4f55a0bb72..3761d3ad60882 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -754,7 +754,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 				atomic_set(&server->smb2slowcmd[i], 0);
 				server->time_per_cmd[i] = 0;
 				server->slowest_cmd[i] = 0;
-				server->fastest_cmd[0] = 0;
+				server->fastest_cmd[i] = 0;
 			}
 #endif /* CONFIG_CIFS_STATS2 */
 			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-- 
2.53.0



