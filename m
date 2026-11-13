Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591482;
	b=2/gQMvwdOyu37N5eIcA4i5z7w6fpl6aaPpxtrGzL3+7Y52iClwneBn0n4qECUNqKTa5U
	 whxa9a0/rCxfn3V0N+2nxMSR28pXHetdA2SbtGoocyzjU4Kh38vBBs/Q0hykyY/HdsEqM
	 fLRWmrEMUHy8DlcnxghKsADS2iYb58hRi3XrRc2HmGSj7YrwElxGxVkrhyWAQgZgaEX2V
	 221gmGYPreeuPO3hsV9HjeMbbVSG+YxR1g539fWC6ttJiI7FtBAYUsOVc+/2Cu8VUxRXl
	 n7+EJfkYWm3eQHQJLBBL8NHRzTi9BLvooS7a7QsPL5kSGwmdk1holoLbcCkr1wNJCCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qAUYmBt9U4fKyVq6moVI3QJgXSMyWGEYvDzKCcXxfpg=;
	b=uKObZwxeOPiqUmNbLmmVZnAoU/ci08UlBf4EEc7MVd7/zaBdVb7oBo7BlDRtKUouHeei
	 SPAALc99d8Cj3VKJNsXH8pU59Ez2C7MzT8NMu+WOiqASpH67g5uB2nv53N0om57p1Jxsh
	 3xWgLtc4S0mnRwOWpoxCEY2ooeFzC6Uovbm+7fGfkdRP5LDZKn9FGYAwKX79ch8esHNmd
	 4ASizjs74vEOPSpjCxcer/Ncceg9IToNGQl4KeP+mtfdEUNOoam8xTP0Hxe7loXLaiMo0
	 L9hXqv02h8wFT07KWdYp3E0CKyi2MwBi2KAKMPA0MbqqWDH0MTqBMhPSxDOut50c0Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBt3booi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D823607D2FD;
	Fri, 13 Nov 2026 17:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBt3booi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0961F000C4;
	Fri, 13 Nov 2026 17:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591481;
	bh=qAUYmBt9U4fKyVq6moVI3QJgXSMyWGEYvDzKCcXxfpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBt3booihughOq8i5Jbrt3xLy7ONFTy8tWpqV6jxVn/mvKzVgxivub7MdnenrtK50
	 b8ySVOsq9IwT/LzgGa+t1OJ5cv1EapaK9pEDXg+j6bQEey16eZLLuu9g7NeNaHgSIr
	 gz9UPY9Wit0oRsEJlRaewYt1laM2LvemH51xIWs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 522/670] ata: libata: Add an argument to ata_eh_reset()
Date: Fri, 13 Nov 2026 10:51:26 -0500
Message-ID: <20261113153829.618406256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 4b3c2ca268b0a66093793466e02d8566d642f19c ]

Pass the ATA port pointer as first argument to ata_eh_reset(). No
functionality has been changed. This patch prepares for enabling lock
context analysis. Without this patch, lockdep_assert_held() statements
would have to be added before each ata_eh_reset() call because the
compiler doesn't know that ap->link.p == ap. See also ata_link_init().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 96fdeb7e3fd8 ("ata: sata_inic162x: remove dangerous broken driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c  | 6 +++---
 drivers/ata/libata-pmp.c | 2 +-
 drivers/ata/libata.h     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 366b7d2a10e5d..b78aa5371c14c 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2632,10 +2632,9 @@ static int ata_eh_followup_srst_needed(struct ata_link *link, int rc)
 	return 0;
 }
 
-int ata_eh_reset(struct ata_link *link, int classify,
+int ata_eh_reset(struct ata_port *ap, struct ata_link *link, int classify,
 		 struct ata_reset_operations *reset_ops)
 {
-	struct ata_port *ap = link->ap;
 	struct ata_link *slave = ap->slave_link;
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_eh_context *sehc = slave ? &slave->eh_context : NULL;
@@ -3817,7 +3816,8 @@ int ata_eh_recover(struct ata_port *ap, struct ata_reset_operations *reset_ops,
 		if (!(ehc->i.action & ATA_EH_RESET))
 			continue;
 
-		rc = ata_eh_reset(link, ata_link_nr_vacant(link), reset_ops);
+		rc = ata_eh_reset(ap, link, ata_link_nr_vacant(link),
+				  reset_ops);
 		if (rc) {
 			ata_link_err(link, "reset failed, giving up\n");
 			goto out;
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 99c67dbfb7536..c3b3af28d17c9 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -796,7 +796,7 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 		struct ata_link *tlink;
 
 		/* reset */
-		rc = ata_eh_reset(link, 0, reset_ops);
+		rc = ata_eh_reset(ap, link, 0, reset_ops);
 		if (rc) {
 			ata_link_err(link, "failed to reset PMP, giving up\n");
 			goto fail;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 0a5f9a4fa906f..f98a3eb5d51e0 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -196,8 +196,8 @@ extern void ata_eh_done(struct ata_link *link, struct ata_device *dev,
 extern void ata_eh_autopsy(struct ata_port *ap);
 const char *ata_get_cmd_name(u8 command);
 extern void ata_eh_report(struct ata_port *ap);
-extern int ata_eh_reset(struct ata_link *link, int classify,
-			struct ata_reset_operations *reset_ops);
+extern int ata_eh_reset(struct ata_port *ap, struct ata_link *link,
+			int classify, struct ata_reset_operations *reset_ops);
 extern int ata_eh_recover(struct ata_port *ap,
 			  struct ata_reset_operations *reset_ops,
 			  struct ata_link **r_failed_disk);
-- 
2.53.0



