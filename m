Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10463090C4;
	Mon, 13 Oct 2025 15:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369247; cv=none; b=blsANDE6nz4kWKiE2ra1c3BFm3bpPr/OKHwykvsKRbQie9lBf+ilBbvUHys/pkvgwbvqwyaXDDTScRDui9UGfuo0T7CNGgAftSemAWz2K51hGXbcDTDIKEV5si3q39X+43MRg0IKX4+8kL+CRxojPl56UM4vHLQNZYBCU97gtAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369247; c=relaxed/simple;
	bh=BhEdtwNnZzwvLFWNRP33UjJ5TQzx4wIF81bBJq0zSc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFE6ShKkM66QQoPqY1l2smJeDlPUHKUxyNhoerixz3+WpgJpPgTX2xOUa2T8z2z02Jm6cv0wjQY6MZ55FBaGa3SRZO9J4gpEdPnWtMi/iJH6kHdy5PxnuBhJyeEqL+fk6ZDZz9rCkUL9gJHIE6eCgi+VS8Nt7aS8rUDYJPCQSWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OL36bCbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OL36bCbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792CEC116B1;
	Mon, 13 Oct 2025 15:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369246;
	bh=BhEdtwNnZzwvLFWNRP33UjJ5TQzx4wIF81bBJq0zSc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OL36bCbSom0d9UJ3LbQ0JyTJo7c5vFdMrXXMxXdRven2MPojj0UtTY0zBoY28bxXX
	 l/Ufvg1kt2bluvaIVnuj1dJ3EIqwqAsZP771unzQz3euK03ifBBVT6nsHrNiCxjvem
	 VaMR0M/3UgqzR/9YLIbuU3/aYDSp9SBe50EBOtdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin George <marting@netapp.com>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 162/563] nvme-auth: update bi_directional flag
Date: Mon, 13 Oct 2025 16:40:23 +0200
Message-ID: <20251013144417.159665462@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin George <martinus.gpy@gmail.com>

[ Upstream commit 6ff1bd7846680dfdaafc68d7fcd0ab7e3bcbc4a0 ]

While setting chap->s2 to zero as part of secure channel
concatenation, the host missed out to disable the bi_directional
flag to indicate that controller authentication is not requested.
Fix the same.

Fixes: e88a7595b57f ("nvme-tcp: request secure channel concatenation")
Signed-off-by: Martin George <marting@netapp.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 201fc8809a628..012fcfc79a73b 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -331,9 +331,10 @@ static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
 	} else {
 		memset(chap->c2, 0, chap->hash_len);
 	}
-	if (ctrl->opts->concat)
+	if (ctrl->opts->concat) {
 		chap->s2 = 0;
-	else
+		chap->bi_directional = false;
+	} else
 		chap->s2 = nvme_auth_get_seqnum();
 	data->seqnum = cpu_to_le32(chap->s2);
 	if (chap->host_key_len) {
-- 
2.51.0



