Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEA5BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D5CC4339B;
	Tue,  7 Mar 2023 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210198;
	bh=4Nt92KzbsqU8PigjDhTRfGAusiZGoIGgOoXHeJkDaRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhf7BuVGF4vnbrJetJy2yNT5MXZfekPFIClOVNSEpD05ipFOIMPJVmEDFXyxr57ec
	 eA21QLhPACvLKOQkcSSDq7lwoAW2WXA1TyUn4EoxscV9VQyqG4pDjBzTvRQ3s9Gjpe
	 1CL+anJCI4sRR6pD41+ho2WQ1om1SaMujkp1ZZMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	David Howells <dhowells@redhat.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0457/1001] cifs: Fix lost destroy smbd connection when MR allocate failed
Date: Tue,  7 Mar 2023 17:53:49 +0100
Message-Id: <20230307170041.205711239@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit e9d3401d95d62a9531082cd2453ed42f2740e3fd ]

If the MR allocate failed, the smb direct connection info is NULL,
then smbd_destroy() will directly return, then the connection info
will be leaked.

Let's set the smb direct connection info to the server before call
smbd_destroy().

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smbdirect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 8c816b25ce7c6..101dab87cad1a 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1700,6 +1700,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 allocate_mr_failed:
 	/* At this point, need to a full transport shutdown */
+	server->smbd_conn = info;
 	smbd_destroy(server);
 	return NULL;
 
-- 
2.39.2



