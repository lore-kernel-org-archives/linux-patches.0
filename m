Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016825;
	b=Yh2/tvDVd8+lyKk8XgkuPNpAJejQQEdNhvYJrQc+2GrICLhgTCkhfdVfvmFz4XTG08Cm
	 xilpl97wSbwsPNvkNDEOMHacoteyaW0NwuOnms9dhc78u4zJGShjkLc9f0wHr8cfnLh71
	 Cx9ygVSJIPgeUmu+LNQqNUSJqvY7f9pfbHCRYZcOe2CG9Wjpzka0C2R/32YA0YIocVkFF
	 HYfqi8sgyjgWFPhjxtlx7SMrUkKu37f/Wo8d9CCZ0y4BPjAaNTdoZSqnqS1irVM0sTC0R
	 bVGvXOPnIa0B1BfzJFrC/rtcPLcDfzK9Ia7FsNnJ1slFooCK7VePFMG1WmJyEIc5q3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=inn/T5y9a7wCa5iqE8epExyOTf7eVvTFPlEe0qJT8as=;
	b=5YTC0bZzbkTLohmW6oJ9DKsznmcg+6Td60NIxQONxkrY0lvd89S6m9kYmlZ6aYfWoScU
	 4yYCA31qvr+S5wiI72BtC20uBaEI0t+4M/2rGdHfgl2JFoBdsLAM767+H0Z7rHTw7zs6z
	 3tqGFOlzLUZ6AjUNuDPo4GN1H0IEf/xKpke+I8XFfh2ztLbjpWzDpoBrSWKenI0X/WKYg
	 I1fNeC4HzwhNSZe9fiP2L4UQbpNwaFMEBOpVdbmtLEZReY5zlYNFN/q3I79ieLZSQ9MfF
	 tBtidvJIHMxLtV/VzC90/Qz5eo2CMjnvGrt33lHN/geJd8KOX6/h6FdjpoXSJ7svomQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvz6zPmL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE182606A320;
	Wed, 18 Nov 2026 15:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvz6zPmL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A2E1F000C4;
	Wed, 18 Nov 2026 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016825;
	bh=inn/T5y9a7wCa5iqE8epExyOTf7eVvTFPlEe0qJT8as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvz6zPmLgY79APC6I8aEzKTZIQENKrVnmP76iKErccD6RO0R/6EPt9eXExU3GMH38
	 QL7rd2HjSlUQM7PnWWJbLnYDc/twb6gzTfRq+1i1DriZ5/l2yvtaufx23ur0Mo7txD
	 6dUgUiZ1mtj04uy3isq8wI5SHppOJep8guJnzVoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0649/2651] RDMA/irdma: Fix erroneous -ENOMEM for large MR registration
Date: Wed, 18 Nov 2026 15:31:29 +0100
Message-ID: <20261118150311.050645433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 5bb710151753fe53047b1d34b1b54d0f179cec68 ]

Commit cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
replaced the explicit level1_only boolean with a bit mask
but did not properly convert the "if (level1_only)" check
in irdma_get_pble() to be "lvl == PBLE_LEVEL_1" and instead
left it as "if (lvl)".

User MR registration passes "lvl = PBLE_LEVEL_1 | PBLE_LEVEL_2"
so this check always evaluates to true and causes the
loop to bail after grabbing a single SD even if the region
actually requires more than one SD (as is the case for
regions larger than 1 GiB with 4k pages). As a result, these
registrations can fail with -ENOMEM even if there are
sufficient PBLE resources.

Fixes: cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260915170317.2901672-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/pble.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index 28dfad7f940c2..14318af97d581 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -482,7 +482,7 @@ int irdma_get_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 
 		status = get_lvl1_lvl2_pble(pble_rsrc, palloc, lvl);
 		/* if level1_only, only go through it once */
-		if (!status || lvl)
+		if (!status || lvl == PBLE_LEVEL_1)
 			break;
 	}
 
-- 
2.53.0



