Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E879C82871;
	Wed, 19 Jun 2024 13:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802344; cv=none; b=hZOyelZRHXkXE9qd3W0oOIWoa48Fca22CXGYeKyXhk/2lFlmBCb142tBgZ8AG8DbaK+Sum1zYqje6wIMV3YiLxtgs+FYnxjX4VC3tcmn5LecJ0hwowSur6iJ/WTLDnJyqCKqRe9CscZAcaJXDAtL1ZnYfjUNFbvonfiTC2XFOyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802344; c=relaxed/simple;
	bh=+13jNWMwRK7PXxSLdKLCDoFW76KbPFTFDw4D6DoSgS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AE6icq0brNvRUzM1r2c+CARR7VU9H7ujymV77aXk2L1uIEgWd51zDpk5NFryUbX5JA/B//aKPHG8kCelsq8EfHxW049J2bmdMvpVKVB9UXYkvx4NeDi/zXpZn0r/FCY+c82G7umUTZIqGszDvxyxpo1dJu15uO4dhei4zSclPUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmGVFBWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmGVFBWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0C5C2BBFC;
	Wed, 19 Jun 2024 13:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802343;
	bh=+13jNWMwRK7PXxSLdKLCDoFW76KbPFTFDw4D6DoSgS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmGVFBWcChBBOVLAS0LyZejBe597HFwBeiB8GnFwwxVDS/iT019CRE2qB85kXpoF5
	 /4iauBXQRG4JoHqUSs8XoSI7/fGhEemVTwQTk3dKc5kVB3SnRSDLLHCQLvp8hxAVUW
	 2R4lDPBLo053z2tZhjb5f4+x8UlvjHFUP+RQeWjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/267] nvmet-passthru: propagate status from id override functions
Date: Wed, 19 Jun 2024 14:55:16 +0200
Message-ID: <20240619125612.677909091@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit d76584e53f4244dbc154bec447c3852600acc914 ]

The id override functions return a status which is not propagated to the
caller.

Fixes: c1fef73f793b ("nvmet: add passthru code to process commands")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/passthru.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 9fe07d7efa96c..d4a61645d61a5 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -226,13 +226,13 @@ static void nvmet_passthru_execute_cmd_work(struct work_struct *w)
 	    req->cmd->common.opcode == nvme_admin_identify) {
 		switch (req->cmd->identify.cns) {
 		case NVME_ID_CNS_CTRL:
-			nvmet_passthru_override_id_ctrl(req);
+			status = nvmet_passthru_override_id_ctrl(req);
 			break;
 		case NVME_ID_CNS_NS:
-			nvmet_passthru_override_id_ns(req);
+			status = nvmet_passthru_override_id_ns(req);
 			break;
 		case NVME_ID_CNS_NS_DESC_LIST:
-			nvmet_passthru_override_id_descs(req);
+			status = nvmet_passthru_override_id_descs(req);
 			break;
 		}
 	} else if (status < 0)
-- 
2.43.0



