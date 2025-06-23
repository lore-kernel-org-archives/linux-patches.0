Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6D01F4628;
	Mon, 23 Jun 2025 21:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715913; cv=none; b=pxExQZWyEct7PZec2z5qcuLFJJrHxEdw41ia4uGQNkOIW4Plcd3JYlyT3kUvAgttf08qtgqQQLjuXT0pcfLWYwGFtG2RY4Fwo8rxdClrWvzDGUdq2u74R39zexSk+flX+O1AfAyXpNe69GpY3HqncDaMVAKlE0LbXIrKiJvCp7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715913; c=relaxed/simple;
	bh=N37EFeHd+zlDrkykjhY+/D3P71UUwo24yxQWrtpWDLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0TP3IGgjyMNTBPOFXxBkVXI+a+/VKmjzvodNjQWv7FCcm11HB/r4xTkIcnStvfg3VAsGmQMagXMcbm+lnasHnMfPl7aN8fUXey8HAUhClCPTuVRUF9GIt0DALSfF6/660CRu+mFCgGUgDygpIKYZi/jC+zJj63c7duU88QpftY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jutwtMGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jutwtMGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04289C4CEEA;
	Mon, 23 Jun 2025 21:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715912;
	bh=N37EFeHd+zlDrkykjhY+/D3P71UUwo24yxQWrtpWDLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jutwtMGZ6frP/DMwxaxjhKT0ajyfXQvg0LASLHKS8sbR9lzO6D5nrP5zQnttr6xJd
	 mvf0BwFwz0lTh/NYVItLtqqHXWhILoXQArpkHjjn61Cj5lCsgCOZSv7n4Lv7zYAHnb
	 umtBtxmlY10knP9HgR8YHovWKyFNfd2Pko2XIImQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 511/592] ionic: Prevent driver/fw getting out of sync on devcmd(s)
Date: Mon, 23 Jun 2025 15:07:49 +0200
Message-ID: <20250623130712.589691789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 5466491c9e3309ed5c7adbb8fad6e93fcc9a8fe9 ]

Some stress/negative firmware testing around devcmd(s) returning
EAGAIN found that the done bit could get out of sync in the
firmware when it wasn't cleared in a retry case.

While here, change the type of the local done variable to a bool
to match the return type from ionic_dev_cmd_done().

Fixes: ec8ee714736e ("ionic: stretch heartbeat detection")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250609212827.53842-1-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index daf1e82cb76b3..0e60a6bef99a3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -516,9 +516,9 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 	unsigned long start_time;
 	unsigned long max_wait;
 	unsigned long duration;
-	int done = 0;
 	bool fw_up;
 	int opcode;
+	bool done;
 	int err;
 
 	/* Wait for dev cmd to complete, retrying if we get EAGAIN,
@@ -526,6 +526,7 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 	 */
 	max_wait = jiffies + (max_seconds * HZ);
 try_again:
+	done = false;
 	opcode = idev->opcode;
 	start_time = jiffies;
 	for (fw_up = ionic_is_fw_running(idev);
-- 
2.39.5



