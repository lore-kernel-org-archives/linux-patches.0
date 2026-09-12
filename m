Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FEA2264AB;
	Sat, 12 Sep 2026 19:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240534; cv=none; b=MfaV/6tlKOaWW8383+sM1zScIUCT7y975s4Y02UaVVLGNMEMJSINo5qD9vmcTTrbGs0CnsON8rm8AD6q+UM+I+wT96vHegMbORQeyRsbiFacyLw1l5Y7AnBRUq2hKh8rCzAspcgOYPVKv3XkX+l41Ocx08EzVfWeYEHrtMBsLS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240534; c=relaxed/simple;
	bh=2BHQGNoyMD1wpoF1GIJnRE7taO3ERCCkSupa6b3JVUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEMdiZM5HHVBl7Gc3F6GJEz510WJhOtiCmV2QagRT2bOlQeIfC/XqzIIlDBUmtXbO4+ljTw/Yiz+jga14Q3MF6FSiJlkozUSELqcv8b3D3ej+hHmSZN0uVkFJhK4HhXilb1o6Npoto9LRJksCdZ6H6Xk4b4xnbM7xZ5JO8+PeWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyPx4FgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyPx4FgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF061F000FF;
	Sat, 12 Sep 2026 19:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240533;
	bh=FMWdAlp4cqyMrg7+XWsoQBra+jZtOSjrrd84+LPPe3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kyPx4FgJKHe7wCqD/lYwPFAE63vpWdCqupRLDv0zB7yJYJmCcHBVZAM4stlFTh/IY
	 EjgFA5Uf1rlz3VHCQCVnphPelnLuJujv3PpFIWr9KsZZQ9Kl4rKgT5mxKLBrHqAei7
	 tKaIZvntGzWpeDV3XmSloK/YXezP0+IHN9451CQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 887/935] cifs: fix clearing stats for fastest execution of each smb2 command
Date: Sat, 12 Sep 2026 09:05:17 +0200
Message-ID: <20260912065547.157095272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/cifs/cifs_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index b7bbcd67e0954..52321f7a49e0b 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -526,7 +526,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 				atomic_set(&server->smb2slowcmd[i], 0);
 				server->time_per_cmd[i] = 0;
 				server->slowest_cmd[i] = 0;
-				server->fastest_cmd[0] = 0;
+				server->fastest_cmd[i] = 0;
 			}
 #endif /* CONFIG_CIFS_STATS2 */
 			list_for_each(tmp2, &server->smb_ses_list) {
-- 
2.53.0



