Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF7F139D0C;
	Tue, 18 Jun 2024 13:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715627; cv=none; b=NUBMbTilMN+EfpDFMZWae5GTnozd0jYwCZWpRx/sr7YIrQbvIV5zKZLcUPGri5q4BXzAJ44LqrwsqfimZcK5ggG6l8PiAyUjUKW/aQlTn+Q0ReDPKinllO9msgkjCdWBxK15/ZYs4B1UNKbmAMkKilKVdCA1hb2DPN0QyXRwE10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715627; c=relaxed/simple;
	bh=mtc7Tjok/QHRhinEtQ4LjxTaB+jzsRn+tIggPPX4TcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueCvcDfcUbNbtRz9LgEm8WFdcWNvEGy7YB7m2WYIyYyVxlXOAHipAiAH4lAZERhiR4Ukge/cNPZr1f8zXjcGNzUBGDmdg6EN43jw+5htP6RtlS42SzmlyBqU+5b4JSXk6Qv2nuv9swU7iGHhR4V0olfjk2YdWdhuba+xHeCDPA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3+rr8hA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3+rr8hA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B81C3277B;
	Tue, 18 Jun 2024 13:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715626;
	bh=mtc7Tjok/QHRhinEtQ4LjxTaB+jzsRn+tIggPPX4TcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3+rr8hAsb1uC4gSxxmcXMcyMbu1yBygeuQWZS40uPv5Gb8o9oshi+fLn1NKBF3tg
	 ytMx686HW7b4EsnXbXSvA1R4rPDgiJO52PGACe59Cwr3fkhx0/AEZ5V4srUabBlrYd
	 1OsyaIAbIjkpgEAwhhBy9RX9trHEJIlIuLoa9QhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia He <hejianet@gmail.com>,
	Pan Xinhui <xinhui.pan@linux.vnet.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 345/770] lockd: change the proc_handler for nsm_use_hostnames
Date: Tue, 18 Jun 2024 14:33:18 +0200
Message-ID: <20240618123420.580418378@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia He <hejianet@gmail.com>

[ Upstream commit d02a3a2cb25d384005a6e3446a445013342024b7 ]

nsm_use_hostnames is a module parameter and it will be exported to sysctl
procfs. This is to let user sometimes change it from userspace. But the
minimal unit for sysctl procfs read/write it sizeof(int).
In big endian system, the converting from/to  bool to/from int will cause
error for proc items.

This patch use a new proc_handler proc_dobool to fix it.

Signed-off-by: Jia He <hejianet@gmail.com>
Reviewed-by: Pan Xinhui <xinhui.pan@linux.vnet.ibm.com>
[thuth: Fix typo in commit message]
Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 2de048f80eb8c..0ab9756ed2359 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -584,7 +584,7 @@ static struct ctl_table nlm_sysctls[] = {
 		.data		= &nsm_use_hostnames,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dobool,
 	},
 	{
 		.procname	= "nsm_local_state",
-- 
2.43.0



