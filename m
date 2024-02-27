Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E5378B61;
	Tue, 27 Feb 2024 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042580; cv=none; b=lO5Qs/+gkjSmAUd4T4rJHLkpdiNmrQfRxufpDZSmcunAk6XqOlmOLPVmgOItuJ7Uvn57TKdtiUfgig2HtIo7VLKHBCgL3HpuUI+W/g9oKsuY+17ICKYveE41mHYGgvDx9+jyJko5HD7uMtc8FivT3MgOfZRJa1WawQUN1Hn0ynU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042580; c=relaxed/simple;
	bh=kxSkx6IQ10edL9oyioIX1R3Mn5cdu89JzYofraIFym4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTKr0rBmooQ+U5+ZqFcj+1vwmqUqN0fBOs4SbrdlwIk8M0GdvnLE/ZgS9meFxHr9hueZsDSh06yQxVpnuQW1ormLqUZYa1F3u9ChqonagW5pKViapXoCQOmCaWam6Od9Oqq2WdWLVvL4c1+24SuIWY+EjJaVFR587tM7utDAra0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM5fze4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM5fze4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CBEC433F1;
	Tue, 27 Feb 2024 14:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042580;
	bh=kxSkx6IQ10edL9oyioIX1R3Mn5cdu89JzYofraIFym4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LM5fze4nNNnqeziQuM4y34dC5VKtk7UsbW+nXczlrjEBmJ3Ry1Jc+1Yio2GB1IPE9
	 QSxa+0MDSh5J4z7PuF7BVPIOiVaSvE8G9oNDEbE8X2nta8BGnatCY8LjwvXzPxDpOY
	 ip0Bvh0ne2gmsxcVVKJyiSnZkOWO9ovJCnea88EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/245] nvmet-fc: hold reference on hostport match
Date: Tue, 27 Feb 2024 14:23:54 +0100
Message-ID: <20240227131616.622850276@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 97f4ec37f36da..06d11bb7b944b 100644
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



