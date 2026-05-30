Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B8321B191;
	Sat, 30 May 2026 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162829; cv=none; b=mqr/PNYTnk3yv4RzvrgBQicJZbSYWWd6F7xwKzljTBqCyN+yiAlOaLukjGHAy5BgPBwqlFyhVrFatz2gVR2Q8GZEYDMIwjBq7zqyoOyceDo3SM5OfpK1jlrx5sP69mWIoxvPsCtJYXI2Zi8d1HA/iDfu5CetUmxsZODTAhCbbRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162829; c=relaxed/simple;
	bh=wW2TpZVc7JxgmABw1IdgGYqt2NJzRfT4enQzMes9FCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrc0NuvyxGoAh1C4b/gl9bZ6lQtsEr3qR7ccsB/DiwAGvAir6Y/cO5fy3XOs5+DhtwZ4Sg/aUcAe0+Admih7W25BYRG8tKT4DRn9IYFrZB4TOL8M8/v/DpbrLJ8VopcdVwMkHqJhAjnyyHud7OPDLfORBoqJMFiEZdYdF4hi0U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sm9FhQV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sm9FhQV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7381F00893;
	Sat, 30 May 2026 17:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162828;
	bh=sQzvDWkQV6rvDNjnecA4UWAOvSje7pbPuUVGI629hJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sm9FhQV8gaYzdpW6cjUCpwPenrPLq3Aj2oQRSR6avlvGD4QyCjZCscUtVDfKVFn4P
	 PYfSEo9xGPgvSlvHJb0PxA0zrvFRitnwDeuKi/0edMCR7Br4LzsX/l5pvIMwnM8+SW
	 Od8UFY23EiB9QsC72h3ExEmoIaFcyTPCdlo3Am1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Robert Garcia <rob_garcia@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/776] smb: client: fix potential UAF in smb2_is_valid_oplock_break()
Date: Sat, 30 May 2026 17:56:30 +0200
Message-ID: <20260530160242.289579650@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 22863485a4626ec6ecf297f4cc0aef709bc862e4 ]

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Appropriate path used. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2misc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index b84e682b4cae2..da32b3f6686bd 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -679,6 +679,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 
 			spin_lock(&tcon->open_file_lock);
-- 
2.53.0



