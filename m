Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF94756B81;
	Tue, 16 Dec 2025 11:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884137; cv=none; b=U1Ove/EGPis57GCIxUEz+OCbiMrKFY7zUhR4Lv3lDQ5pwjcQC6OhCXT4VrNX5lfCJ3WEnFM5uTl44kfVjsA+8o8CwVFyN2J4F0RFwKq64ow2yW6zyKeKtR1SQDnhpEQ71beWgdjO6uTO2cx3O7y0ebTPMn5ydapJzTcnPJ798Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884137; c=relaxed/simple;
	bh=EvKJUxun6mAhRzfnazPrIyVHUqvgsMj0xzIHyWGyjZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4Tipjf2kKtlyhGOafkv3gnG6gvQr5wlhgWhO3nYvarLoLRdl917eT78udj3PA3lCJsPcRpdX8EbvX5AUdP2l5Ln0wj56BSso1W3v7MzwFseF+y4Z725Tg51ggwpj/B3m9a0UzBGDz7CVZqJuAeaYYJQd8RAPRYjZiZHniKXJv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fi/1rRlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fi/1rRlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C261C4CEF1;
	Tue, 16 Dec 2025 11:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884137;
	bh=EvKJUxun6mAhRzfnazPrIyVHUqvgsMj0xzIHyWGyjZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fi/1rRlYJ3JORdat+zuqTXm9ZHtpoJd+IBn4zwAyQGz5QZYYUIg53qZSidBUC6XIA
	 uwIAfUNzsZHAuY6pQmbOt26yhxpq4QsXrcJmTl7fhaqMGQ794VCtsiPn1WaUkHop9m
	 aEw83s2WG0zLiLvouVX1DHSEOU4yCFLaTZqaiVvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/354] s390/ap: Dont leak debug feature files if AP instructions are not available
Date: Tue, 16 Dec 2025 12:10:36 +0100
Message-ID: <20251216111323.425705012@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 020d5dc57874e58d3ebae398f3fe258f029e3d06 ]

If no AP instructions are available the AP bus module leaks registered
debug feature files. Change function call order to fix this.

Fixes: cccd85bfb7bf ("s390/zcrypt: Rework debug feature invocations.")
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index e14638936de6b..e7068016a9868 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -2419,15 +2419,15 @@ static int __init ap_module_init(void)
 {
 	int rc;
 
-	rc = ap_debug_init();
-	if (rc)
-		return rc;
-
 	if (!ap_instructions_available()) {
 		pr_warn("The hardware system does not support AP instructions\n");
 		return -ENODEV;
 	}
 
+	rc = ap_debug_init();
+	if (rc)
+		return rc;
+
 	/* init ap_queue hashtable */
 	hash_init(ap_queues);
 
-- 
2.51.0



