Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BE7252905;
	Tue, 29 Apr 2025 17:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948438; cv=none; b=dfnsaOH/ZypkQ9uvOWH1Eq4zO5DSCoUE4Yyt6cfONfMWZr4KidEeV+pDXxn99oEHJ/JAL8WN8q3V9ryBibEEiAJUrw+6mf/Rla5JiOjl95JW3XrKBrB9BRRzNYO9UMo3Gu3bMV8I9EVY2r2XuZ5nmjpUH+/OFzQ27S6yt6Nu1HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948438; c=relaxed/simple;
	bh=di7n3BbnPrKiTIIKmf6mLAZhAlHCezP1es4fCYnEwrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDcoH8vkbm4PVzFABAaZBXnweucpYmk6pQKL9m6uG2GlglmYEzy1WQBNzxvNhmmuYIjDW6xdlj9fyIbXloU0CHKg2CLlfQzDaWW0kOhA3rfS8o7jpfNvAj86E/a36PpXmOCdbz1b86dmJbnbJmwvv21/n8P1Rt3wA0Zci8+5ag8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbyPf6JU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbyPf6JU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635DDC4CEE3;
	Tue, 29 Apr 2025 17:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948438;
	bh=di7n3BbnPrKiTIIKmf6mLAZhAlHCezP1es4fCYnEwrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbyPf6JUe5/mKLGs26H+DGfBeF2bVpQB5dHyLNVcckUolyq6wxgDNnKCg8eYyVnK1
	 0TlVBT5pvhy/YF6cYHRAvSBWMXB0Fo4FWaN7vcI5blRySk+84qDrSj2RRInXRFm01+
	 s0IOV+5ItKndyVka9Yu3Q2iZ6kzGv18yXhFEN1k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Srikanth Aithal <sraithal@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 6.12 273/280] nvme: fixup scan failure for non-ANA multipath controllers
Date: Tue, 29 Apr 2025 18:43:34 +0200
Message-ID: <20250429161126.304956889@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

commit 26d7fb4fd4ca1180e2fa96587dea544563b4962a upstream.

Commit 62baf70c3274 caused the ANA log page to be re-read, even on
controllers that do not support ANA.  While this should generally
harmless, some controllers hang on the unsupported log page and
never finish probing.

Fixes: 62baf70c3274 ("nvme: re-read ANA log page after ns scan completes")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Srikanth Aithal <sraithal@amd.com>
[hch: more detailed commit message]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4278,7 +4278,7 @@ static void nvme_scan_work(struct work_s
 	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
 		nvme_queue_scan(ctrl);
 #ifdef CONFIG_NVME_MULTIPATH
-	else
+	else if (ctrl->ana_log_buf)
 		/* Re-read the ANA log page to not miss updates */
 		queue_work(nvme_wq, &ctrl->ana_work);
 #endif


