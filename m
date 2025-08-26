Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C08F225390;
	Tue, 26 Aug 2025 13:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216450; cv=none; b=EqQ7bgiQDvktG2fAmYUTAzZMkgdATTjcncWkVGZNVUgyG/yv4HY0ORSpUbinUS0Z1nZ0b/sFSfPzyRT8x9Er4MgYYIHlt2KzlxuorkVmJdc/2pHAZtKBrRI2+wJEFJ4cQEaojOothkJmpiwMMbY45ZEcjNXGXWr/oG21HdZk7k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216450; c=relaxed/simple;
	bh=+BSqDZNBSc4GwPUgyvg4dGVMONjvHsXsW6TY000+bH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0BWxwwnSkdwZItUl6ERyyy7odxjaZrICmY5u43upxoYNxrE5W8GQscXlKzWSgJrdZh3sz/AvygGTi+A28wTNA088yp5Ce7lf7dauEHW/8YFsWCN1OUGwSW6ytjb5TUdJPDc4rh0it4NrLv/Q3NHS2hJrg3GcAU6QCHwAGvB5K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dw8YBkUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dw8YBkUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D201DC4CEF1;
	Tue, 26 Aug 2025 13:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216450;
	bh=+BSqDZNBSc4GwPUgyvg4dGVMONjvHsXsW6TY000+bH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dw8YBkUTZtowrhD3H79BFPTGT76m+EixkOTa5jncDxjpTvotHMURClbQ4khVtU12M
	 /uI5J1Z8CxlI+oOH+kXWmNvRrumNYDLc8+Fa29LXs5+YhX0lM5uo1PZkO6J551w9Yz
	 zlGBB8+8MPV5SWMrdG7d4X/6TEbq6c4hVud0ENfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 416/644] dm-mpath: dont print the "loaded" message if registering fails
Date: Tue, 26 Aug 2025 13:08:27 +0200
Message-ID: <20250826110956.766539587@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 6e11952a6abc4641dc8ae63f01b318b31b44e8db ]

If dm_register_path_selector, don't print the "version X loaded" message.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ps-historical-service-time.c | 4 +++-
 drivers/md/dm-ps-queue-length.c            | 4 +++-
 drivers/md/dm-ps-round-robin.c             | 4 +++-
 drivers/md/dm-ps-service-time.c            | 4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index 82f2a06153dc..683ac2e03079 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -540,8 +540,10 @@ static int __init dm_hst_init(void)
 {
 	int r = dm_register_path_selector(&hst_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " HST_VERSION " loaded");
 
diff --git a/drivers/md/dm-ps-queue-length.c b/drivers/md/dm-ps-queue-length.c
index cef70657bbbc..cc5eff8853ab 100644
--- a/drivers/md/dm-ps-queue-length.c
+++ b/drivers/md/dm-ps-queue-length.c
@@ -259,8 +259,10 @@ static int __init dm_ql_init(void)
 {
 	int r = dm_register_path_selector(&ql_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " QL_VERSION " loaded");
 
diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
index 27f44c5fa04e..6f10c4f879ec 100644
--- a/drivers/md/dm-ps-round-robin.c
+++ b/drivers/md/dm-ps-round-robin.c
@@ -216,8 +216,10 @@ static int __init dm_rr_init(void)
 {
 	int r = dm_register_path_selector(&rr_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " RR_VERSION " loaded");
 
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index 3ec9c33265c5..eea15af86e69 100644
--- a/drivers/md/dm-ps-service-time.c
+++ b/drivers/md/dm-ps-service-time.c
@@ -341,8 +341,10 @@ static int __init dm_st_init(void)
 {
 	int r = dm_register_path_selector(&st_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " ST_VERSION " loaded");
 
-- 
2.39.5



