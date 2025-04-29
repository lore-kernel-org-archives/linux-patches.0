Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C782512F3;
	Tue, 29 Apr 2025 18:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949601; cv=none; b=c7RKeZjcFEcwhnBu+/aR0rQB8B/WFYQ3lXwGMpwPzD+Q2JTVlzrLROeU0Bx2pfUXBL+xhJ7mjbar3YLYOdxhWmrHMkvVoahmpj0bn0AydaBNxtPoaazxpnmNvKQFG5TTD71vqQH5ZEkOGWW9aXpoBGzgnXMfTP95kUtB8Gor3mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949601; c=relaxed/simple;
	bh=u3KCuz+jFtkFkXWJa5ApJs2x2Y7ZSObNTXfFmB59Cyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIAe30CujXGwIjyAJFzHotcsMSMb7OSllf5mSa1pA/XYSq922o1UcZ1+pfF0GO+Wx6zm6PENjWS3xF66yRqLYSq/1q4qjhOpejL6aT4AGp95Qwq0M+bDutUDEDLGsRHdxJ+f9Kjuy6/nLIYVisrC9yUeONPjvmgJY/c8EWeYmEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL97leni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL97leni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D59C4CEE3;
	Tue, 29 Apr 2025 18:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949600;
	bh=u3KCuz+jFtkFkXWJa5ApJs2x2Y7ZSObNTXfFmB59Cyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WL97leniN7jGeA3TzYt7ibL/U11NM7VqAK9Kwn2la/rlXI8ByKS8dPAgbONHxGK3y
	 K+DaoCnFapbxyI8G9tJ3S1m+zNE1eqiXK8bDVBq1qyCBannc7EpdaOmpEu4jTsGqBS
	 PMSl7WqWEWfHseSLJ1332g8Umo5UwRSLKW5+yJGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Srikanth Aithal <sraithal@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 5.15 370/373] nvme: fixup scan failure for non-ANA multipath controllers
Date: Tue, 29 Apr 2025 18:44:07 +0200
Message-ID: <20250429161138.349246813@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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
@@ -4226,7 +4226,7 @@ static void nvme_scan_work(struct work_s
 	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
 		nvme_queue_scan(ctrl);
 #ifdef CONFIG_NVME_MULTIPATH
-	else
+	else if (ctrl->ana_log_buf)
 		/* Re-read the ANA log page to not miss updates */
 		queue_work(nvme_wq, &ctrl->ana_work);
 #endif


