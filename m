Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C7F6FAA
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF06EC433A7;
	Mon,  3 Apr 2023 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532996;
	bh=dyRNXGOZf4brccamaHH/095YDcJCiuhx1pfl90nrrMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNP7d+40qXpXp/2YPD6Aur1VcDWaBjwhJwu0duY5HCmkEU3OBAXpP2O57/BqBpBqM
	 U4i5VqD+rIX0T8cPwTIniWWP1/qjnk4o7x9ta/ddfXOKwfCmhBn1jHI2r34gaLjQ44
	 L8tnASgLGnwpJqmedZR1PRbilU1+TuNYNgdnxDCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 002/187] cifs: update ip_addr for ses only for primary chan setup
Date: Mon,  3 Apr 2023 16:07:27 +0200
Message-Id: <20230403140416.101074673@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit e77978de4765229e09c8fabcf4f8419ff367317f ]

We update ses->ip_addr whenever we do a session setup.
But this should happen only for primary channel in mchan
scenario.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: bc962159e8e3 ("cifs: avoid race conditions with parallel reconnects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6da2af97b8bac..f53837f436d08 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3735,16 +3735,12 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		   struct nls_table *nls_info)
 {
 	int rc = -ENOSYS;
-	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
-	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
+	struct TCP_Server_Info *pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&pserver->dstaddr;
+	struct sockaddr_in *addr = (struct sockaddr_in *)&pserver->dstaddr;
 	bool is_binding = false;
 
 	spin_lock(&ses->ses_lock);
-	if (server->dstaddr.ss_family == AF_INET6)
-		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI6", &addr6->sin6_addr);
-	else
-		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI4", &addr->sin_addr);
-
 	if (ses->ses_status != SES_GOOD &&
 	    ses->ses_status != SES_NEW &&
 	    ses->ses_status != SES_NEED_RECON) {
@@ -3768,6 +3764,14 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		ses->ses_status = SES_IN_SETUP;
 	spin_unlock(&ses->ses_lock);
 
+	/* update ses ip_addr only for primary chan */
+	if (server == pserver) {
+		if (server->dstaddr.ss_family == AF_INET6)
+			scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI6", &addr6->sin6_addr);
+		else
+			scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI4", &addr->sin_addr);
+	}
+
 	if (!is_binding) {
 		ses->capabilities = server->capabilities;
 		if (!linuxExtEnabled)
-- 
2.39.2



