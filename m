Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B2F13A26F;
	Tue, 27 Feb 2024 14:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043268; cv=none; b=euzTB8q64bapXh6BRfnsDDSgXRtp3wvHXCC/vDSyik5PXsxwnno90y0dn3Yn+u+12zudlJag1WUpDRYsa+EmfCbds3Gk4xK1yMJu4BczFzT5EmHPVnKrcjIYeRUYx6mBtGgTQ+LUoTTY9GTFhO9rkT40cMevxEWnh8wDHrb6JdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043268; c=relaxed/simple;
	bh=DNwXWSlUqBcCyZ5lvN1KstTS1RZiwZxRqifoayIGYiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hg7rKBLzyHmBBmEIX8PGuNR65tSk1g/u7qtdRKrNLSjuUmqIq6n4Q/2Xt74iWIwWs5FfB9OEKh9TOT28zsBH7He5azYyJ6eCRfRpp/cQVEiZoj/WKqu/qu9e035axbfhO2bNUQIYrR0gxNypqa4T0oJoubJ3EDiMLxy7Eow77G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2elS8OpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2elS8OpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0466DC433C7;
	Tue, 27 Feb 2024 14:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043268;
	bh=DNwXWSlUqBcCyZ5lvN1KstTS1RZiwZxRqifoayIGYiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2elS8OpUKE8nWJ6w4WrQWpJTF1HS9wQ5Y5gZLUa0/8wMDvQTSUjqx/6friUJvptmb
	 Y6DM9thY9AWqytyJTvpGcKyXXE3WdfIpJ2lG4YPNl0/HJPDcMQ7mCRCrUmlkNJ0PZ2
	 FNsNoeg00ee0agzhRbO53jLt9GiUlMSAI186/HVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/195] nvmet-fc: hold reference on hostport match
Date: Tue, 27 Feb 2024 14:25:08 +0100
Message-ID: <20240227131611.941196368@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c9ef642313c8f..64c26b703860c 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1069,8 +1069,6 @@ nvmet_fc_alloc_hostport(struct nvmet_fc_tgtport *tgtport, void *hosthandle)
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



