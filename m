Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8D61B6D08;
	Mon, 29 Dec 2025 16:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025517; cv=none; b=ji5jP72aEXZAHS/r5i8LlVmdYwwQuQ8urdP4K6qNxed3XbhWPLWBUuaA1ik+MCDZHqpgKdhucTbhigwysMJfmAtKtzw8laTPbhsmRhRLY3W7u3X7VjS8xy1gndL0Ss7gYWCQYMaGoBww6KvHBvB9aaSZ9qvcA6ZqtZ2PLfYq1Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025517; c=relaxed/simple;
	bh=fehKGRhktbU2DRiqFYdZkFcjXJ4dJN4JeMRQKrdci/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw+RLJXlf6bMhaXfVJpc67l0zgZ5gfdc12jlAzhmPJEAQf+xk22/Yq0PNjmiQkL53dAsdhguuEgTWZ74c8kIgQnrhxedtAGy9t/e9SkiFG9LUgH8XN+u1rQoyJRsXbHYk9FnPWZVNsla1vaNy4KHP6OnZGXHRlFCuG10W+lOS0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXqaF3K6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXqaF3K6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C31C4CEF7;
	Mon, 29 Dec 2025 16:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025517;
	bh=fehKGRhktbU2DRiqFYdZkFcjXJ4dJN4JeMRQKrdci/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXqaF3K61Xi0w1HV6bQTWO232oqR+QEbltaJL5Rl/N5yEEoNSWOTTTDwqQIMqw4Ny
	 byFuTvAnBepcmCnGdf9p8OTPtA+Fl//WKrkvAmDWkh+efp9cvMHfuxwqBPZJdRMbgj
	 FX+4l3L/NMp+ZY7UrtNkxVacJYBDHod7MUG8/M7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Justin Tee <justintee8345@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 209/430] nvme-fabrics: add ENOKEY to no retry criteria for authentication failures
Date: Mon, 29 Dec 2025 17:10:11 +0100
Message-ID: <20251229160732.045107242@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justintee8345@gmail.com>

[ Upstream commit 13989207ee29c40501e719512e8dc90768325895 ]

With authentication, in addition to EKEYREJECTED there is also no point in
retrying reconnects when status is ENOKEY.  Thus, add -ENOKEY as another
criteria to determine when to stop retries.

Cc: Daniel Wagner <wagi@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Closes: https://lore.kernel.org/linux-nvme/20250829-nvme-fc-sync-v3-0-d69c87e63aee@kernel.org/
Signed-off-by: Justin Tee <justintee8345@gmail.com>
Tested-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 2e58a7ce1090..55a8afd2efd5 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -592,7 +592,7 @@ bool nvmf_should_reconnect(struct nvme_ctrl *ctrl, int status)
 	if (status > 0 && (status & NVME_STATUS_DNR))
 		return false;
 
-	if (status == -EKEYREJECTED)
+	if (status == -EKEYREJECTED || status == -ENOKEY)
 		return false;
 
 	if (ctrl->opts->max_reconnects == -1 ||
-- 
2.51.0



