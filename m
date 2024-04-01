Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663A63F8F4;
	Mon,  1 Apr 2024 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989813; cv=none; b=JryDyNlXLVlz/QXSe+6dVnnYM64HLmlX1KCtni4O0iXF+uOWcWEgSX85awDNbxK8xtN7e4V3XjZcCvngnSBAuRTu8nsY0iEQgqI4D89gdU/jOfI1SKA7+erKN2xGsa3ZfJpFpZhRYPnuiVIWBbxvB0n5FIa/LUjwiJbaW04Akpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989813; c=relaxed/simple;
	bh=+VTiYCBKn0sI6kHLftj5boCISlffB4K3+qk2lVvSLFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GcOJ52pP/OnF1vN5q2JsABamamvep6/lLg6f+4Qrmw/q825XPjwGTMxDpyDkcjD/j6f94qzP/QRwx7VIG0t1csru1V991me+c3E2tTJR/NUxTLwPIEmWhAuWdSL4fKJyB7u4M3RcfZOs088Gs6JJeZkWdihUHETnpsS588ofJiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5ZLVTfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5ZLVTfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681B1C433F1;
	Mon,  1 Apr 2024 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989812;
	bh=+VTiYCBKn0sI6kHLftj5boCISlffB4K3+qk2lVvSLFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5ZLVTfZoIPxVdqOb9Ps8T6l1LFxqiulhdME0PBJIsczcg7q2EIq5SckJNY4EYLjR
	 XGOkjZc6gsB1flzZNX0EIkMQ23zK73I6rAv8aw0J9uZi8exb+/6kZp5PQ6SWp4z3Aj
	 CfxINIC6VdopMy8OaMjgfgaGDmI4m/EGXQ0xMEEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20=C4=8Cerm=C3=A1k?= <sairon@sairon.cz>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/396] cifs: reduce warning log level for server not advertising interfaces
Date: Mon,  1 Apr 2024 17:43:30 +0200
Message-ID: <20240401152552.741544704@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 16a57d7681110b25708c7042688412238e6f73a9 ]

Several users have reported this log getting dumped too regularly to
kernel log. The likely root cause has been identified, and it suggests
that this situation is expected for some configurations
(for example SMB2.1).

Since the function returns appropriately even for such cases, it is
fairly harmless to make this a debug log. When needed, the verbosity
can be increased to capture this log.

Cc: stable@vger.kernel.org
Reported-by: Jan Čermák <sairon@sairon.cz>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 16554216f2f95..e4168cd8b6c28 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -224,7 +224,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 		spin_lock(&ses->iface_lock);
 		if (!ses->iface_count) {
 			spin_unlock(&ses->iface_lock);
-			cifs_dbg(VFS, "server %s does not advertise interfaces\n",
+			cifs_dbg(ONCE, "server %s does not advertise interfaces\n",
 				      ses->server->hostname);
 			break;
 		}
@@ -390,7 +390,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	spin_lock(&ses->iface_lock);
 	if (!ses->iface_count) {
 		spin_unlock(&ses->iface_lock);
-		cifs_dbg(VFS, "server %s does not advertise interfaces\n", ses->server->hostname);
+		cifs_dbg(ONCE, "server %s does not advertise interfaces\n", ses->server->hostname);
 		return;
 	}
 
-- 
2.43.0



