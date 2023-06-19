Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7A83C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB21C433C0;
	Mon, 19 Jun 2023 10:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171155;
	bh=dHdXjmRzGyB1fNKZuM3DNHavPKcXncU3n7gGSioMyeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFNMqHqQwtzL4J6sP4RNW4sL7dMAEtleTxQFiaJur7aYEKjJEt6APzabGUotjwQbE
	 COxqJQwAX9n4n8V5SHiCaVLjKbcWUEUi+L/GFhmaKvRsrNtqq0esS57dbKrxoQjPBq
	 +XqiPoHiLiqC/xFoK93uVLkJtE09Y1ITCe5/SqiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 168/187] cifs: fix lease break oops in xfstest generic/098
Date: Mon, 19 Jun 2023 12:29:46 +0200
Message-ID: <20230619102205.774132904@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve French <stfrench@microsoft.com>

[ Upstream commit c774e6779f38bf36f0cce65e30793704bab4b0d7 ]

umount can race with lease break so need to check if
tcon->ses->server is still valid to send the lease
break response.

Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending oplock break")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index df88b8c04d03d..051283386e229 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4942,9 +4942,13 @@ void cifs_oplock_break(struct work_struct *work)
 	 * disconnected since oplock already released by the server
 	 */
 	if (!oplock_break_cancelled) {
-		rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
+		/* check for server null since can race with kill_sb calling tree disconnect */
+		if (tcon->ses && tcon->ses->server) {
+			rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
 				volatile_fid, net_fid, cinode);
-		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
+			cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
+		} else
+			pr_warn_once("lease break not sent for unmounted share\n");
 	}
 
 	cifs_done_oplock_break(cinode);
-- 
2.39.2



