Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621433;
	b=12lLOXjI1u3MIFpVp5aOTWJxckMEhIl7UiNf0AQaqSszl91dzDkBqoT7sGhX1YdMNaJD
	 D//IcsBJPF3VAE/+ZPEg0e4HAiooWcEl2bps2xA4pKtkpQFr9v+P5aI2jeUT+VmwnnbzZ
	 EiVMkWx6XM6Kx6chS4kOnHOBpU3sRFwoOqRk88lags3s4pIfYQ8VtSqDrfqbM5yA+hUgI
	 b5KAAhWY+Pl7bo+KQO80vCRsp5o5ZXJwWKxgck6C2jSioO0oZq1MLzj5clN/yfrIUDsnA
	 rl99twzN8nc1ABWglhqtHJFimubQ/AAZl3UgZW/REjZ2DlJ/UFy84muoClx+iPC4Lnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4sdU7HPKkGU3yZ3IKWi9V1AhehUmdIAwXuk9Sqg9ODQ=;
	b=HU/q1u3y2/HkyLqplRgrmeb/6diM7Ilz0cL0+dPcB9kEkNcrZFzmDi3zGR42u6fI6HkD
	 9aZsvHrWyFWEovt9zeOC8Rluaz/uogQTwaiZ8key9ahUV5NVfbRb8Quitsb5DwXzQVKAs
	 FqQd4wFEsyHlbN01aealevTJWEsLy7YD/3acLywu4Jct34kpxy3iMPNi1VAKeYEw/JPwS
	 j7HioNel59fgs5sRZZ/D567aAWgYzFgYXFaZ1E+s7uB0cryl4ZtwCBAidENUWX4TtIcPE
	 c9p4moxZfn19N7d3+IrLuxG83h433dqdtVDY56Fy5E0LIUfEQngyvg9/WLC9lgx9pfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUN6QgHH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0694D606A33C;
	Wed, 25 Nov 2026 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUN6QgHH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02D21F000D0;
	Wed, 25 Nov 2026 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621432;
	bh=4sdU7HPKkGU3yZ3IKWi9V1AhehUmdIAwXuk9Sqg9ODQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUN6QgHH3Ma0u1Z6WdlTE9cqFIlNtfAedV3ObTomKB4CYrDWVRMNvNZtI+wor29jm
	 z017r3p/qGmdWs6uZpxozNPEHpTx8vJwywBrqNZaE0iNLr4r7Wx6rEwC2NIcUwUUaS
	 XjXLRtbnKZVmrgePKr4ae3melrNZ6idfsCXj5ads=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	James Fantin-Hardesty <james.fantin-hardesty@seagate.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 224/990] nvmet: fix arbitration burst field mask
Date: Wed, 25 Nov 2026 15:26:31 +0100
Message-ID: <20261125143827.336168537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Fantin-Hardesty <james.fantin-hardesty@seagate.com>

[ Upstream commit 6976a9b8dc71bb3b6e5dd563e35510461bea29d4 ]

The Arbitration Burst (AB) field of the Arbitration feature is
CDW11 bits 2:0 (NVMe Base Specification 2.1, Feature 01h), but
nvmet incorrectly masks it with 0x3. Use 0x7 for both set and get.

Fixes: a0ed77d4c9a7 ("nvmet: Implement arbitration feature support")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: James Fantin-Hardesty <james.fantin-hardesty@seagate.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 007029eaca39b..c8c7961beadb4 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -1341,7 +1341,7 @@ static u16 nvmet_set_feat_arbitration(struct nvmet_req *req)
 		.hpw = (cdw11 >> 24) & 0xff,
 		.mpw = (cdw11 >> 16) & 0xff,
 		.lpw = (cdw11 >> 8) & 0xff,
-		.ab = cdw11 & 0x3,
+		.ab = cdw11 & 0x7,
 	};
 
 	if (!ctrl->ops->set_feature) {
@@ -1496,7 +1496,7 @@ static u16 nvmet_get_feat_arbitration(struct nvmet_req *req)
 			 ((u32)arb.hpw << 24) |
 			 ((u32)arb.mpw << 16) |
 			 ((u32)arb.lpw << 8) |
-			 (arb.ab & 0x3));
+			 (arb.ab & 0x7));
 
 	return NVME_SC_SUCCESS;
 }
-- 
2.53.0



