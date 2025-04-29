Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2741D24E000;
	Tue, 29 Apr 2025 17:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947444; cv=none; b=nVRh2E3qBlytDrsS+3O5vPxO1ZUAfJG+sys/LeopeWC9j0eyh9wf6qFxCFAHtaznJHgE2PbF9JpIv+nJfH6NFAw4rNIdCrR3aiEQwoERiJ1SgvYWUd/J7+Kpi4Z0bA07d2xk3tVL3xi+uxzkWPiVzOMtB5zat+mcQeO+ppVE5KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947444; c=relaxed/simple;
	bh=EqegcVCFXGZJZVjQ4jN4sR0Bchg3EBWwG/59JnHcW/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkR9Y2BNvC8bDa1WRQ2gXMPfhKfaEk+QNj7wfg7n5kxTaKX6l0cTSQiIUFmFM7gIgXShgLsjCGdtRFa4LanUTpG+HvhHfF3lpTSYcd3fl6jqvUMoe6hc+nKoMlguEwVEN0IuIV7KFjsBa41V7hvHoebinylIxiUlcazsMKEmcXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pks37jEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pks37jEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE54C4CEE3;
	Tue, 29 Apr 2025 17:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947443;
	bh=EqegcVCFXGZJZVjQ4jN4sR0Bchg3EBWwG/59JnHcW/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pks37jEnPsJvoA3ehtiTgeBaAddySoeKk7UenfAOoBgUsjHVpqeyXERToqA4wz4h1
	 c4fugdVnDj735/Dd9CrjKdwkcpePtoAX1ZLAbqXxsdmpDLPJkaq4TnoiNSpDObbpYZ
	 TelSQJHncXTZUDa1dk87OOKjiebLzGj6tLrKpJDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Srikanth Aithal <sraithal@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 5.10 282/286] nvme: fixup scan failure for non-ANA multipath controllers
Date: Tue, 29 Apr 2025 18:43:06 +0200
Message-ID: <20250429161119.509959722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4271,7 +4271,7 @@ static void nvme_scan_work(struct work_s
 	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
 		nvme_queue_scan(ctrl);
 #ifdef CONFIG_NVME_MULTIPATH
-	else
+	else if (ctrl->ana_log_buf)
 		/* Re-read the ANA log page to not miss updates */
 		queue_work(nvme_wq, &ctrl->ana_work);
 #endif


