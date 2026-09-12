Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BA44BEE3C;
	Sat, 12 Sep 2026 16:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232207; cv=none; b=A4jkf3iZaR1wOvBZS2chgxpyThRt7kom3JTL74rASB9/DjieJYyY8WWEO/CYXQTr42hFZScwY/dm8Uis+fCgAALolmK5EJQOfr+ddEK/2NtaEUfkRaE1dRc0JYoVC032hBTeJPEd4/Oj5YLNfhxyIcmNZM2QgpmDUA6kP6aGVJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232207; c=relaxed/simple;
	bh=wztd0X9Da553dJBhbK6RmeFK4vsHLUeh33aurcmBweg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mz/y48gBRSZ5WATR2IHE6zMa3gBqEmwdYGVttXC+VyFeW4UEy68sAg4UDvnEZzRBB1sLdVjgX40NrAJsO3OUn3jgSnHzAgSUoaRLAg1Q0tGPygWM9RzMQeA6W6X7DP3pQmO6etEvo2gABk+Mp1c00o4SYsmL1CzlGg2H2CKHPxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfdHDdKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfdHDdKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111371F000FF;
	Sat, 12 Sep 2026 16:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232206;
	bh=+VPBvTolXkVxU0HpoTGDO8RpFQVdDjPdmUOPbaNfIxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfdHDdKATyJ7921A9b8M9ZqgQDRaUIkz7K1wDZ4axubOTK6dK4aM9pd+0AtawJ9r8
	 jLZ5mt16TNJ/59Cj0AqvqTridhVU+QZmWYN9n7Mz1TDfW1O7Ke+ptOAfUbQ+qxfKeN
	 pH4zAE2w44Klkd1rptrQA7NXPWta14k6sBYYqw3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1102/1191] cifs: fix clearing stats for fastest execution of each smb2 command
Date: Sat, 12 Sep 2026 09:03:50 +0200
Message-ID: <20260912065612.906963767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0c0a7fcc4cebc..df7f03cf30e08 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -564,7 +564,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
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



