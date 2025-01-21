Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B66C1F5404;
	Tue, 21 Jan 2025 18:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483111; cv=none; b=d1Vao45S8OUmROBMCWU2tzU2PEXbhZmrdscJ8ysMC7WiK6ifaZsvfa8EAZCQiHx/jC5JU4Vw6RJJLivwNh9k370SrIAiL5Ufx6/11S/FABKBSIYLviRvsFP0RD8BQN3YR7FOAYOZvkErO+kSmINVFNGHuAq/4+j0fBniFH1arSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483111; c=relaxed/simple;
	bh=v/TnL1q6L6egZfROOw0ODewGosjQH+Ti8bJjkCVaCCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCnduYYRkHtotIXKooK2LOLn3Ql5NFEz0+uEY9sKKJkWmgxZ8vRP0RxckevxmWa2c8W7vam4YobYIkQl+1K4WsaoV7ZBrl+lto9gSp9LDBylMtNKZCBk8CVA9WdCfVu50Z3eWDJ8NHjdBcwDMQHhMkGkSjw1G33Jkw7FBad539k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufc3ynPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufc3ynPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EEAC4CEDF;
	Tue, 21 Jan 2025 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483110;
	bh=v/TnL1q6L6egZfROOw0ODewGosjQH+Ti8bJjkCVaCCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufc3ynPMHsdYkKYTh7jfYYQTGyIDUBQXRWX2QJ4i3HqC0YypL7qirf15H0rr+fwHC
	 3He5cJ7Xa8L1jrGKaCTXBx8ltUcAI2Sco+cBgVy6dDKzVFPDg/7snK+zbhFktP0N3s
	 vNCKgKQRfAlbrbjshpo2svPVN68PY6dkp6wBSq/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/127] nvmet: propagate npwg topology
Date: Tue, 21 Jan 2025 18:52:54 +0100
Message-ID: <20250121174533.587709302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit b579d6fdc3a9149bb4d2b3133cc0767130ed13e6 ]

Ensure we propagate npwg to the target as well instead
of assuming its the same logical blocks per physical block.

This ensures devices with large IUs information properly
propagated on the target.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 0fc2781ab9708..58da949696c21 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -36,7 +36,7 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 	 */
 	id->nsfeat |= 1 << 4;
 	/* NPWG = Namespace Preferred Write Granularity. 0's based */
-	id->npwg = lpp0b;
+	id->npwg = to0based(bdev_io_min(bdev) / bdev_logical_block_size(bdev));
 	/* NPWA = Namespace Preferred Write Alignment. 0's based */
 	id->npwa = id->npwg;
 	/* NPDG = Namespace Preferred Deallocate Granularity. 0's based */
-- 
2.39.5



