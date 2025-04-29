Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E35221703;
	Tue, 29 Apr 2025 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946562; cv=none; b=lUX4X/xtg1BaG2qND6VSDA/bgFEdT1ExFMWXcZTNC+gQ536E5CgqnQiyCjpMVdcG5U2jQH9AxL1+iC3AsGAvgHsrFBODkVgXJ6vQQM122C43Q3/qlUDlnVEVYEkPHhYlM3JeDGaXIhJw1fNsfltoe0mqX5HnoGs222RviQYYmBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946562; c=relaxed/simple;
	bh=p8Q9D0hwDOmyXBLoxpAaqfAXaIN6FZif41VJsP+X+dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcNYeVvTvaLiMoD+b63ZLOD1sGai8XLEqUI81r3yJsdw6NwlwPMiUSpvaSm8D9VQYZu79lgLFjRBWP/nhcjGOX7/0akhGDwm3WDyQTvz6l6/F1zpZl6CjnxNiHchl3c3msElAh7HbGnURU5ImCvlDYcZ4cZSchlQ5n1DN8whnzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KeDHg+oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KeDHg+oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62343C4CEEE;
	Tue, 29 Apr 2025 17:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946561;
	bh=p8Q9D0hwDOmyXBLoxpAaqfAXaIN6FZif41VJsP+X+dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KeDHg+ocq2HHfiVzU91U3QuwNqmKG86IdBn1al+Xi9ggwlC4qz2w74Vsxhj1SRsBk
	 53cbuJH44IBW1Mjw+ZWiZ6KZN+CSlE2BRSf/z5hNLPxTJN63/KulYJjYqBD9KCbUZA
	 LJf8U5Opg9y+uwL6LagLN/kfieiFVsupTa9fFfAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Srikanth Aithal <sraithal@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 6.14 307/311] nvme: fixup scan failure for non-ANA multipath controllers
Date: Tue, 29 Apr 2025 18:42:24 +0200
Message-ID: <20250429161133.571598395@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4297,7 +4297,7 @@ static void nvme_scan_work(struct work_s
 	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
 		nvme_queue_scan(ctrl);
 #ifdef CONFIG_NVME_MULTIPATH
-	else
+	else if (ctrl->ana_log_buf)
 		/* Re-read the ANA log page to not miss updates */
 		queue_work(nvme_wq, &ctrl->ana_work);
 #endif


