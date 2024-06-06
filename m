Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0841A01CC;
	Thu,  6 Jun 2024 14:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683147; cv=none; b=uwRtJ5guA/7/Z7ViGco1reo6J/WYQm5E63u04s+3EQqTzPDaQBumYEOuZQ2tj0ugIz8FLEN9P7aimaGhsUNX4MPj2Bn9hZzrUkQAd8FJyURttzmF+72OPsq+i387/aOAgsdRFKgctr2fe/v+bFLzEOLPAmWPOP0Xg2ehF1Lasus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683147; c=relaxed/simple;
	bh=mC0v4VcvrWsgEPeI3UZWnRXLpuQucSdhP184y/CTer4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mG2ZxlS5wt8bgEJCvqCkzdvZw0UPNb/cH08klu2B+Uo+m0eT3kU/tDEn6kAX8+WzT+3BNPek2BBRwwFejz+/y5bB2gU++yIsMgSz52bN7gZsCQVTBatL2tumBPTm4/ORG5UJpHBQOxvBYBLIUVKRJBtZIP4fEkvYwI0LmtnzcJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BX6tSoAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BX6tSoAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE3BC2BD10;
	Thu,  6 Jun 2024 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683147;
	bh=mC0v4VcvrWsgEPeI3UZWnRXLpuQucSdhP184y/CTer4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BX6tSoAxrBY8NGiECokCEmTH1eFFoO3ZepPSJi4aQd2y4tnbpG8KV24Doi87851Vl
	 36tunJKTrRDnfhzu3BJD9pIQVPnrKYn7sR9zMFf0AmLO0JhLLwA9b86dj9LkbRU9qB
	 7YUdRwZi7x9ZPEt+p+3LQRl8ofyoe8M0JSTh7aiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/744] nvmet: prevent sprintf() overflow in nvmet_subsys_nsid_exists()
Date: Thu,  6 Jun 2024 15:56:04 +0200
Message-ID: <20240606131735.346606734@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d15dcd0f1a4753b57e66c64c8dc2a9779ff96aab ]

The nsid value is a u32 that comes from nvmet_req_find_ns().  It's
endian data and we're on an error path and both of those raise red
flags.  So let's make this safer.

1) Make the buffer large enough for any u32.
2) Remove the unnecessary initialization.
3) Use snprintf() instead of sprintf() for even more safety.
4) The sprintf() function returns the number of bytes printed, not
   counting the NUL terminator. It is impossible for the return value to
   be <= 0 so delete that.

Fixes: 505363957fad ("nvmet: fix nvme status code when namespace is disabled")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 3670a1103863b..f999e18e4561d 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -619,10 +619,9 @@ static struct configfs_attribute *nvmet_ns_attrs[] = {
 bool nvmet_subsys_nsid_exists(struct nvmet_subsys *subsys, u32 nsid)
 {
 	struct config_item *ns_item;
-	char name[4] = {};
+	char name[12];
 
-	if (sprintf(name, "%u", nsid) <= 0)
-		return false;
+	snprintf(name, sizeof(name), "%u", nsid);
 	mutex_lock(&subsys->namespaces_group.cg_subsys->su_mutex);
 	ns_item = config_group_find_item(&subsys->namespaces_group, name);
 	mutex_unlock(&subsys->namespaces_group.cg_subsys->su_mutex);
-- 
2.43.0



