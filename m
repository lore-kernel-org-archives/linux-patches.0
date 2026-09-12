Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97383A2576;
	Sat, 12 Sep 2026 20:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243438; cv=none; b=sAKQBKBYdqOlX7Q+I8f4PetNa0gFjiH87SxpgPVzvmaTC+zMeMaMF6FQpshxrvhmkWDJ3kicSFrao+OJncyw41xINgT1q1CMlBnSBbqdjKSzKiEmYhnhQK7ogiO2jURdHhGiNyERpwuIgWwArQ29fX5DLzslub9CFkIrFuY6O7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243438; c=relaxed/simple;
	bh=koOkjHPIymx9k+GOgFDsZy1dl2nlEcyzRfXRsICLsRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E45cRRxlquXD/c+vbO6AFgP/bxyiI4sOaUPd2wenjPN0H8vNd4krJ0cBGCQX0dyvrrsQEwvvzCvGjdivEYF3lnuYi2Cd186H0iujpzi0KgJm61qouKde0+jbNYTFcn0d0BtmSG1GGeLk17om8lWUpJ5GjEPZauiMcowTf1Dpdq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPsMKW3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPsMKW3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4119D1F000FF;
	Sat, 12 Sep 2026 20:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243437;
	bh=yHuZUYCNQu9bbB3eKwvR2XJTCILxHWhCMHDcmD2kArM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPsMKW3uBSZSeqeYa/WTfrTmOn/vy8kvPpbhQPE6ImtcqURNOjyc1Sa1GRVaSoW5s
	 DuOExgOpW9azDx3uBWEfANQ4QuKA9/pR00Pfpsozn9qzgc+rSH4sL8bJ3wuuvInfDR
	 BnSFhtHw9YdqjgnWD7X6S874IHuz+LqOH87aMEI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 756/798] cifs: fix clearing stats for fastest execution of each smb2 command
Date: Sat, 12 Sep 2026 09:06:24 +0200
Message-ID: <20260912065534.394556548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 024a358380c79..bdba0e7d8a3b6 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -506,7 +506,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
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



