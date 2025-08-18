Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29588321F33;
	Mon, 18 Aug 2025 14:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526004; cv=none; b=JER6Khki+DnpjIzrEmJRlfSUY0sWxoTsiWJO2o01PY83dOgAut6dqGGy4zvLJDxJPEXaRBHjnqSAc1fVo3qx2rXJg5TU9ad8XwFzJQLHYUJFhUd8NYZs4R4B0v7cntT+k4Kf+HWKRlGDYquaVlzNyzsoPZA/qUvbfHbGxknp/5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526004; c=relaxed/simple;
	bh=vYMjhFDzNcDDfKocDVIrKEagR9FSmb/9gC+IiFESwg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwKBjHmL+yYxc//n7JBnLzUZ1P2zWvAfvSjPGzv5RUB9ChECyCxB3oxwn/M7DfKblUPg7xreh/J5PWUsRO9NmzNJsFup/enPmGSi6Nyz0fyjVZ1FB6H7gFFRBQ3XSFjg90LzdFRnQbVMewDVUOk/KGOjXXanGMpeMcKQ0OLDEeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chElIdsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chElIdsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0ECBC4CEEB;
	Mon, 18 Aug 2025 14:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526004;
	bh=vYMjhFDzNcDDfKocDVIrKEagR9FSmb/9gC+IiFESwg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chElIdsJVwwbo92Xq9hpR8Ww70dsIRFJ7J+P6EM5LflmEQUSUqjcsKCSySy0BwZ2X
	 6a7/FLmG5+TKJuPuzdOlZo6Q7XUzjZ85xvr2aCfMC/XAt2BERektRjVqVdz5H0Qi8B
	 4LSNP3Cwpqg97lqAgMiKDBqnF40wA7IBA+BhKXTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 430/570] dm-mpath: dont print the "loaded" message if registering fails
Date: Mon, 18 Aug 2025 14:46:57 +0200
Message-ID: <20250818124522.400456634@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index b49e10d76d03..2c8626a83de4 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -541,8 +541,10 @@ static int __init dm_hst_init(void)
 {
 	int r = dm_register_path_selector(&hst_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " HST_VERSION " loaded");
 
diff --git a/drivers/md/dm-ps-queue-length.c b/drivers/md/dm-ps-queue-length.c
index e305f05ad1e5..eb543e6431e0 100644
--- a/drivers/md/dm-ps-queue-length.c
+++ b/drivers/md/dm-ps-queue-length.c
@@ -260,8 +260,10 @@ static int __init dm_ql_init(void)
 {
 	int r = dm_register_path_selector(&ql_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " QL_VERSION " loaded");
 
diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
index d1745b123dc1..66a15ac0c22c 100644
--- a/drivers/md/dm-ps-round-robin.c
+++ b/drivers/md/dm-ps-round-robin.c
@@ -220,8 +220,10 @@ static int __init dm_rr_init(void)
 {
 	int r = dm_register_path_selector(&rr_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " RR_VERSION " loaded");
 
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index 969d31c40272..f8c43aecdb27 100644
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



