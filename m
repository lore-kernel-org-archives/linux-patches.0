Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A14250C15;
	Tue, 29 Apr 2025 17:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948215; cv=none; b=MTrVOuuZfFRvJJXhgSfOtNGbzqH1ZxDhgBQ8eQvrZVGk3MJY/fCd2tnytf2/KJrfWeBEXZiejTkqBd9SrrIsDX5XBf41rfUrYTtoRS841cHYxW0xsHps0GeXpBeWN71vLUFY+Q0Ds+iGtYtbFvLj18c6QSmySsqf/N8fVY/0b0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948215; c=relaxed/simple;
	bh=j9NzJLSaWdwf/artlfz1NJkcSmK2nKc1SI64Jx5C4qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfi/r3NGGkhsBigcIgM3MCuxR3D/NFHkANNPUpocT2pEJjXX08ejsZcxLCyKHV6opOO9W5m0Hlb0wmj3MfXmvuKr+d9vny+zwKWc5K672x84enIteQr7JTurW9ZwDBBQf9Y15wCUnv9WBpYDSNuXKPvp/4CcL43wfK3gwHWoirU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW6j7Qah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW6j7Qah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547D1C4CEE3;
	Tue, 29 Apr 2025 17:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948214;
	bh=j9NzJLSaWdwf/artlfz1NJkcSmK2nKc1SI64Jx5C4qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PW6j7Qah7MXzd7nU04qVhB0GWLRp2v1NSEsAs7SUD2s6zRCCgZxPy0cT/Ze6JA4/+
	 GHL/VrUV1bVIgV3OrPdC5vNp5TOegoS8bEcr9DzHfK55qVwRYen5ffXgvygJQ+UuQt
	 4QKqbmb4x6igJm/bK3sYlrb3Uswax5MIflJNoQKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/280] nvmet-fc: put ref when assoc->del_work is already scheduled
Date: Tue, 29 Apr 2025 18:42:43 +0200
Message-ID: <20250429161124.203143723@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 70289ae5cac4d3a39575405aaf63330486cea030 ]

Do not leak the tgtport reference when the work is already scheduled.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 78c4a417f477e..ef8c5961e10c8 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1089,7 +1089,8 @@ static void
 nvmet_fc_schedule_delete_assoc(struct nvmet_fc_tgt_assoc *assoc)
 {
 	nvmet_fc_tgtport_get(assoc->tgtport);
-	queue_work(nvmet_wq, &assoc->del_work);
+	if (!queue_work(nvmet_wq, &assoc->del_work))
+		nvmet_fc_tgtport_put(assoc->tgtport);
 }
 
 static bool
-- 
2.39.5



