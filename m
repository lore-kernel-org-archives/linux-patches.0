Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9C54399E2;
	Sat, 12 Sep 2026 11:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212314; cv=none; b=CcZCs6O/gFURHoJjEYgil/ygljvenpvkn7NDCBxx/yU7F+IOAAVp8Bgv5MO/sG/XGaev/prMaLS14CvWcNaxRzr4SdnQPkCQDVihMYKKcHg0nIl+Rd4XXXjlYeWJXcYBb4aoS81PIFLtgRDK6GUtkZIL2hvAMb7DU5abfHs5ZlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212314; c=relaxed/simple;
	bh=ijtWlDVok3+DPb+sFDN51z5M24LEvVvWhw/hoURcue8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM1VDFoWXllh1SXzFXof/gHRKGbgIlSzQkr86DnPieDbqXFc+YjYwA2pEGB0L8npMnpwCZ0zrJVBCoodW3kbHJ5S4CqAcoLygdmhOGy616r/HRIBGmK41C/hO3l2HKVdGqPRtQpzwd/fLtSWM9lSb/MwoJ+z0bDLJd8z/zomzkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRluXgWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRluXgWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941391F000FF;
	Sat, 12 Sep 2026 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212312;
	bh=Jwclf1KXn4AqpEmrFa8ntCdtgPY2kLWMd7FCz4QMhak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cRluXgWZgI8BzhpfKBxdA/DAbgOA70ReZ/KJjoVVCpx5iMdvpdcQ3znTz8HpvY436
	 ZmshHrgAcoCj5PPhci95S6ki6EVLeshask8Og/K6V6I8h8zhXjmXQ3AQbQ3RBve8wi
	 TVL0fpmbj9cbJ7H7rGK3ySFoPxZJbwRn8Hx3pkzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1410/1518] cifs: fix clearing stats for fastest execution of each smb2 command
Date: Sat, 12 Sep 2026 08:59:39 +0200
Message-ID: <20260912065655.445341987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 08538ad0f8dcf..3045db555c3cc 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -776,7 +776,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
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



