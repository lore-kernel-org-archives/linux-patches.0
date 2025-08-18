Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AD234AB0C;
	Mon, 18 Aug 2025 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525689; cv=none; b=rzV4kJzJ1gKv2TGp1g1+Cgzt5Tmnqwx4N+7iUYd8GpCt9hXIW78sCdi+cH60wPzSVIjoRexudmF2PGWX/6g69HNqnEnBAjr5OCtDhTq2bDmIg7LH3310ml8K5qORTia+d7UuCCj69pP0IYA0EkEgs0xqM682iaxEO+WBPjg6h20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525689; c=relaxed/simple;
	bh=Rx5L8Hs1Rma2TJfKgRkBcQvPfqb5xWJxx0uy9baRspM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8dlcbBLZIMF13feydtK0gf9zIFPyzdf0lYZZKa7z9AVUjvCX29oGc+xFQT2Z2aJdU0+dy0REHWfLTtSqOeeLXAdgRm+K5n18z3OWwvROGQHAvSnCbvGfLXfeWb+IB3nyVBDNXuwgzv9zY89oUCXLZ3cjyGcnk3Jwm19H6hpVr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=givhHuu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="givhHuu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4E7C4CEEB;
	Mon, 18 Aug 2025 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525688;
	bh=Rx5L8Hs1Rma2TJfKgRkBcQvPfqb5xWJxx0uy9baRspM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=givhHuu+45dnN/VaQPM+FsX6nC+mAeonPMrxAPtnv/8xRUsTL4+In6J8nS0U/cmFl
	 qx3LO/3a/xGdM+idxOuRIm1HeLz1Gje/a2c94Wy2Ilce+pk7iJqXTdV4xUfS82rFPI
	 Oxv85JQ7UbQyzH2760GsHuRORBtzaPcPCnMy1BjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 336/570] ptp: Use ratelimite for freerun error message
Date: Mon, 18 Aug 2025 14:45:23 +0200
Message-ID: <20250818124518.792617163@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit e9a7795e75b78b56997fb0070c18d6e1057b6462 ]

Replace pr_err() with pr_err_ratelimited() in ptp_clock_settime() to
prevent log flooding when the physical clock is free running, which
happens on some of my hosts. This ensures error messages are
rate-limited and improves kernel log readability.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250613-ptp-v1-1-ee44260ce9e2@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 36f57d7b4a66..1cc06b7cb17e 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -96,7 +96,7 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
 	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
 
 	if (ptp_clock_freerun(ptp)) {
-		pr_err("ptp: physical clock is free running\n");
+		pr_err_ratelimited("ptp: physical clock is free running\n");
 		return -EBUSY;
 	}
 
-- 
2.39.5



