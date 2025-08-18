Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D399431B107;
	Mon, 18 Aug 2025 13:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522253; cv=none; b=KxEprbK7tn3ziVqnLd8wtXLhBBMpboVnZEZUtfmVsIVBs4zvBRgfhhDPDAOxhNg0eOrcFHUun3ZL6CXZIQ6QNF+Mbu8SDdTW8ZPLJ0UG3qte532081s/xO1sWKPpFbBLU1o8U4+c/vsrDVGvkSi9vEoxY8O1JwoZ6OsEcEUfMEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522253; c=relaxed/simple;
	bh=Hwb+6dlsG1KxbPGnRY/NYuADPzDeoqUxhYLXQRs74xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAAsaQRpCGp7LSCeCsyOQZVhfW3VlfdaB2umGGFWPj89CpkDoQAF6k4CXPyDdBkaaMhJCvgn40DbMkTmT9/2QWyYAjC6/XmGM3Ylg3jgyC4EpKEDEmytThwk4jGzT3JrpiHL8aZCZnp1RqU/fJoHQqM8oz4CfYs2F+EX8T6igl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIVnM/rj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIVnM/rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471CFC113D0;
	Mon, 18 Aug 2025 13:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522253;
	bh=Hwb+6dlsG1KxbPGnRY/NYuADPzDeoqUxhYLXQRs74xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIVnM/rjlKnQYnzRMB3cDLTn1Rs686gtZrUZws8PSZGl1keXPHI36LNGZsx/boNUl
	 W0nE4fN8mjphDrfFJwbOX2CZR3gTWsQ0lKGIIUcqq9WPNDEoNJYxCtYAkm1k3Dir2v
	 yWirCT5fuki3KshAci/fYScZhgIztSkSqwNhHVMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/444] ptp: Use ratelimite for freerun error message
Date: Mon, 18 Aug 2025 14:44:40 +0200
Message-ID: <20250818124458.344702661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index b892a7323084..642a540861d4 100644
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



