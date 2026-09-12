Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0304BEE36;
	Sat, 12 Sep 2026 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226203; cv=none; b=deA1hvPTi6hA17VlJhmhpVGQKy2HJctgEwCrk+VLfMvwRP0S1znSm+izTI/h6qbqN7hqobx1s4JeLHEYdKG37KDpjvHuy/GCpZNS2kBY9FGTQoGuJ/ZlOhz1pUeHpOfkeSEHfMiZxBvDnVygdESw8Wzht5goHZ5J30W9qc0EEd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226203; c=relaxed/simple;
	bh=hi9dZZQ9Krua3ZYNe11mjscuEx35nMgkgLYEvzpqy5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzbwQV6vPISN/A3Exne0uJ1txeAAduUPiq67jzHUSpSbUb96pFq7HJpco/21kFwx4HACF13/nipnIju9DrNsD0n4PiYk1J8PdczoPqUi54XTtOT8updRkVI0YyKDVZcgaUQNWzO0/xKj1LxjuDN0ot7AFTvmZazNpY4CH4U0bBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxIfFe10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxIfFe10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EC71F000FF;
	Sat, 12 Sep 2026 15:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226200;
	bh=fJ90xxwzkXAxCayyQViLjEbeoJBtI9SqOG3HQpr/ERY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SxIfFe1072Yi86RKInM3XYTLm/kjjS/d/NE0ezFHU6hQ1NeGloc2UaJVImMam7mS7
	 jmrohtlOZRTqtQSPfc18Vp4em33j3dXC/Gr0s10RQvY2f8NIWKHxq9GOxDGa31PpXL
	 1zcNU/08KvgeccAjEZZTMUYI2/4fr1hezrcEcYPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1353/1424] cifs: fix clearing stats for fastest execution of each smb2 command
Date: Sat, 12 Sep 2026 09:03:05 +0200
Message-ID: <20260912065637.562258656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 50ad8246ed187..00d35e01a2240 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -674,7 +674,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
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



