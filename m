Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9549B1EF39E;
	Tue, 26 Aug 2025 13:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214501; cv=none; b=jsqdci2A90jEL5NzpVqoAh3qlmhsr3kGBqpJbXqXgkG/KiJVbpiFnVX7IxdwanTADwQ4mM2kafKEe85KOFP9a4wQv85GWMQk8hS/g7ggFt1Tq4IbuyTTg53DvDWEk3Hb1DfWbq2K7mqjC1mhvQf7xfEhX1SYfqZakyuLPjcngp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214501; c=relaxed/simple;
	bh=i3QSRhmrr8wAJpbEE9yzvs4rTj01GRqYZMDJl8j8tRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/z5Nq5bdNdLIdzIMmX3nhtGnT6wjUFF50QspY9InpudHdzYduraj8iYqWhrv8UqbWitQwKkucYBC0CYuDLXTKdglDRHU9UCaunkusXRo2Cj6dqjDFavUdQCMN3kMqHTKq11W8poR1iXleQ6WC3GyCFf7pr+72lAKXfNR3I73Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCLKqQ21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCLKqQ21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04FDC4CEF1;
	Tue, 26 Aug 2025 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214501;
	bh=i3QSRhmrr8wAJpbEE9yzvs4rTj01GRqYZMDJl8j8tRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCLKqQ21ax4fqUKKjB/vY61EZ8HdGM58AaAkfunh5fdaPa8x3ng8yj07RDp2g2fJO
	 pY5DtTErJHl+xEWKTLyGA+slSph6CwBJXlwjBSL1GRN4YcdbpxsNnLbvRYDih7XZi1
	 npXtURS2386Fv0RusTsakHDzY4tamCjKqS1m1n0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/482] ptp: Use ratelimite for freerun error message
Date: Tue, 26 Aug 2025 13:06:55 +0200
Message-ID: <20250826110934.812902150@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 642c939d4523..e6bcccf87cd6 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -79,7 +79,7 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
 	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
 
 	if (ptp_clock_freerun(ptp)) {
-		pr_err("ptp: physical clock is free running\n");
+		pr_err_ratelimited("ptp: physical clock is free running\n");
 		return -EBUSY;
 	}
 
-- 
2.39.5



