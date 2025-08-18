Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3526335BA0;
	Mon, 18 Aug 2025 13:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524282; cv=none; b=Xbk1oNCUsO65i43VqZEUy+b4UDoWDHNmU7UqVNbVq9tMeaRduwejF70ZvTAv7nKoVdUcrQUI4cvshvWNJ51znIkyLRYlbamp08TJaqDDeWLHaIXN+4jx/qIRCe3VIwshtB7cfx4B4EYuVN4g51n9POb3K0afz/VFhNU+XdPDXCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524282; c=relaxed/simple;
	bh=jQReOy/bcxITP9RcQPSw802unHrIfxBgsruQLNVYYZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIHL+x2WwjKYeIqG0fx4vm7EluDIm2veHnzbY5iV4f84OcVfpdxOpI8iwbpT5HIC0KSJkcNz81mgRyuU7RzNEDHMG4nxiWotGfMbFqSTZHK/HIVVsebbOb2ZF3ttEEiScSoZZKK5fXXb/EaWhO23HTzxqHvEp05YEOpQK0xeD1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYxRl7GJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYxRl7GJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421E6C116C6;
	Mon, 18 Aug 2025 13:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524282;
	bh=jQReOy/bcxITP9RcQPSw802unHrIfxBgsruQLNVYYZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYxRl7GJpbZLko0SVVdBKOeld8wUGTPLtZ67otVgpANFUUh1+z5XsmV8Yjr1f4Jei
	 N/yCPu0GuUZxVdHh1idUcySCrhq5vNUv2EIEBE8u8AXaWQ/8D2enCn72hhPKb7tsxn
	 3Myzib+MwRgXpU5mSC7uMTGSigAU2z7Y/6U8Q8m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 397/515] dm-mpath: dont print the "loaded" message if registering fails
Date: Mon, 18 Aug 2025 14:46:23 +0200
Message-ID: <20250818124513.693711792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



