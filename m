Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CED2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D26EC433CC;
	Wed, 20 Sep 2023 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211260;
	bh=SlpV3CHcwtw6AXTAgQtICJBhdNsP1gjYleEAerZEaCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYrtwMu/jr97uKsmd0pK3q3yN29gQ1rVmrLOVpMD7LatsqG2pFVJXiPv91TQ91ymS
	 SSMB0kbCM34/NRZxnNtk3zo5mfEYcyamYeDOg7WFzL9W7hAG2+vWt8POoMmfbl0N/G
	 SUQXbyzEnP1667uH5t1wMxXZi0LSVLSLMTKhC8Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 028/186] cifs: add a warning when the in-flight count goes negative
Date: Wed, 20 Sep 2023 13:28:51 +0200
Message-ID: <20230920112837.935065327@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit e4645cc2f1e2d6f268bb8dcfac40997c52432aed ]

We've seen the in-flight count go into negative with some
internal stress testing in Microsoft.

Adding a WARN when this happens, in hope of understanding
why this happens when it happens.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index dec306a3b0f41..3287795c648e5 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -78,6 +78,7 @@ smb2_add_credits(struct TCP_Server_Info *server, const unsigned int add,
 		*val = 65000; /* Don't get near 64K credits, avoid srv bugs */
 		printk_once(KERN_WARNING "server overflowed SMB3 credits\n");
 	}
+	WARN_ON_ONCE(server->in_flight == 0);
 	server->in_flight--;
 	if (server->in_flight == 0 && (optype & CIFS_OP_MASK) != CIFS_NEG_OP)
 		rc = change_conf(server);
-- 
2.40.1



