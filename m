Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E1A1B0420;
	Tue, 26 Aug 2025 12:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213049; cv=none; b=PtLFo/Tfv6TjpBPlUCOeElT9GQyY+FSp2R0bOiDcQKbF53fSAunNTBgDXkSlSYdikr9ESSJKh8SPBKlsfWPAr3HLTZsRTZ+ohsZC8s6OE1SrwibArRVzEKVDTuwgIF7OoUM7u7sroKewYI2eo+q8wiw7pPHjwoSS3mVlT4aWvZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213049; c=relaxed/simple;
	bh=d37uhLAV0UTZFtwPqlxOuK7mUeutG3/CO/HJI6oR+vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNRqSHr2nZ7dcP0Fbjg7keYxyWqtbs7AATCOACwL+Z1JKLbJm9+S3IJojmpOlh+SL58nXYk9OCzFRYfHEYHlaSrAOO9Gnl0OoIyA9IhafJwPgidASD9+ys5XURJY1rhISkGmhca1GgBaJ8Mrw4XNz8V1qeklSE8EzyZ23kScTKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJR9pG+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJR9pG+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092C4C113CF;
	Tue, 26 Aug 2025 12:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213048;
	bh=d37uhLAV0UTZFtwPqlxOuK7mUeutG3/CO/HJI6oR+vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJR9pG+ZtG6V66vGA8hlQUE9z9C4qidjOLcX0ePb8k/wpSGromPOoyYZkdGvebvjT
	 qsL19rfaLo+P6Yb5Smx6Xb88lzKnfR6LPuwRX31MZpydBnTDtW9tc8eI3E7lmuR8t6
	 3xOpmYUUO1E8nPgNQeukLBBURNPDJD/LpKbZ62Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/587] ptp: Use ratelimite for freerun error message
Date: Tue, 26 Aug 2025 13:05:51 +0200
Message-ID: <20250826110958.078229174@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b7fc260ed43b..0682bb340221 100644
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



