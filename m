Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3772541A57D;
	Sat, 12 Sep 2026 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219144; cv=none; b=qs9gmt1laKq2fwqKs5UzA9hwqmT1hkFioXdVH1z12V6DGl3+pqBKNWYC35aQig/UTt/RaMERRAhxcm+YkDqWGNSgzI2kZKKv3AvgsTltOs/6PWofar1ydXfOxn0ejn1yQ+RtPbh0ytZMUgX35NJl0WvpZ17aJ4JMFTEvQwd9LPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219144; c=relaxed/simple;
	bh=9lCtyMYVooRETpM9Zz/8GRBJ2SIe1KUBMQyezn/cryc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9XpJkC6BKuOhkdyrdBuH19a9I/cRj6xY60QqHCB0hbGDhLQqCLEWhKLXpPvcW09BdHDyuaqRn2ua0hCTC+I7px6gisCwoqGwteyEHD53MH7eck4npKo+elQMpyTUcajr016hBVOnMFytuwLKRMjWwgC/NBSNeKkHhmFEuZNpwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz/Pyonz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz/Pyonz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0DA1F000FF;
	Sat, 12 Sep 2026 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219143;
	bh=kLaAW3BeFSv/g+WBouRA12t9CsBb+VkBZTMIPYBrfAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vz/Pyonz34qzt84QhKskXdFFg6Bp5uw0VZANvxta1+ZEvNjgHItmY7rxNiyLeSpC7
	 FcNad0aJNCymx4B2KKH88fmxc6o+NG61bV2AVBHPplg6DjzHwL6KYR/0cNxGTSD81P
	 ZcLItZqNfICr6mvbf3U41c+dHHhWPxAxCkrTgnX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1289/1376] cifs: fix clearing stats for fastest execution of each smb2 command
Date: Sat, 12 Sep 2026 09:01:55 +0200
Message-ID: <20260912065636.265077217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9092051776fc1..185a618f5cf1e 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -682,7 +682,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
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



