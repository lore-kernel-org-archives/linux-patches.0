Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD961A186B;
	Thu,  6 Jun 2024 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683191; cv=none; b=GUcV9pu2w0jnzI4almyTuNWuOtrWzYoSESmQ7DI6hxltGQyBfOqS0nHEQ3p1PTCTTA1Rw4Y5U1MsE7/6GCNMh/MnrGSG1zzT+PAizW4piQRMFOvjeTx1rxlaccZX5TNnyASfIuKaR4rxQo79pimINMBMOJENEbs0BgQ/BBV0UEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683191; c=relaxed/simple;
	bh=bQB9tEQXxLncc9QZPgo91/kV3vgXdSmYzkzeXqZ2VdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKlHIBe+8q+nIGJklMr4SleUO0yS6kl+dp+8KVxQ7g8/yzTx3ECpy16kvShbPQ+BY4+5EC/DtHKJfyEBdr4RO5SJaw2MC3VrofUjLs3TH6XVyCX/q6t0YqAQNIPzE4r+XXJnvOlulkshuljTLsCDgf8cW/l/EkTXj5m4Cu490Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ka3UL1eM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ka3UL1eM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5A2C32782;
	Thu,  6 Jun 2024 14:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683191;
	bh=bQB9tEQXxLncc9QZPgo91/kV3vgXdSmYzkzeXqZ2VdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ka3UL1eMfAuDczITg/B0yVfXHGyxO/ehw326DCatwFIGjMerwWtcIIaDn67IogPYj
	 yT4eTvaGVcxcogHsLy0qBgJGsoHilWlr0kxkriodEpu3WXJYyayWKWaSiwM028solm
	 puGcYabuLQ29T9S5P3SzEVbkIl4aBeEAcpiRaBgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/473] nvmet: prevent sprintf() overflow in nvmet_subsys_nsid_exists()
Date: Thu,  6 Jun 2024 15:59:54 +0200
Message-ID: <20240606131702.036848953@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index b1f5fa45bb4ac..40c1c3db5d7cd 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -618,10 +618,9 @@ static struct configfs_attribute *nvmet_ns_attrs[] = {
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



