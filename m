Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5DA13B79B;
	Tue, 27 Feb 2024 13:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040670; cv=none; b=uIAM3lAWCWtWG9yQ2eNQODhAr4rAoS/++gHb1NFhmf9VP20q6+9Qjo6xOkCPmh4sqaYSjBHY0VppQbX0knyzfrf3gSHI0puo6SE8GQY6wewfP8JD9y9ERPGSjIvjB04zziI3Jd4yATQHV8LyAJRpAqtmudwcl+lSaU4MMygo5k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040670; c=relaxed/simple;
	bh=lElVVDSpy1c4oTWDbXVpAA+mm7mYa4ztA2KXlF+eSm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkKExWXgCRL0M674h6gWJYmaulej8iOT8we/b+QuCBhsZatfzda+h4l46a/QodznBun8GBERzo0NYoS652t5B+JHWk0AllzM3LQST8uTQ8J42n6wqLOHoeWDkKM4t0uu+wGape51R4RP1hFJ89y/t0begX9FrMi7ZqVKH+rAobM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDqNC/b3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDqNC/b3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2E9C433C7;
	Tue, 27 Feb 2024 13:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040669;
	bh=lElVVDSpy1c4oTWDbXVpAA+mm7mYa4ztA2KXlF+eSm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDqNC/b3vQZQ4ZnlINKoJ3XkiPn9nkm7LyA0UqNrGe4ZfHV7KJJ8zU2uPOfKVq/1s
	 Hri6YlstC/fGZHwbZB+RWSAbqfbrGJtS+dWVpi4Du+ux+VMsGRAtQUAny9sVWbUTxT
	 qcM2DRMhaz/HuenW0yvS70VlxZlHbwP2RbSGnuVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 068/334] nvmet-fc: hold reference on hostport match
Date: Tue, 27 Feb 2024 14:18:46 +0100
Message-ID: <20240227131632.751014560@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit ca121a0f7515591dba0eb5532bfa7ace4dc153ce ]

The hostport data structure is shared between the association, this why
we keep track of the users via a refcount. So we should not decrement
the refcount on a match and free the hostport several times.

Reported by KASAN.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 5fd37e989106c..6d111b03d3713 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1068,8 +1068,6 @@ nvmet_fc_alloc_hostport(struct nvmet_fc_tgtport *tgtport, void *hosthandle)
 		/* new allocation not needed */
 		kfree(newhost);
 		newhost = match;
-		/* no new allocation - release reference */
-		nvmet_fc_tgtport_put(tgtport);
 	} else {
 		newhost->tgtport = tgtport;
 		newhost->hosthandle = hosthandle;
-- 
2.43.0



