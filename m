Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A4E226546;
	Thu, 12 Dec 2024 17:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023060; cv=none; b=YAmMigjUWyrxvyH70bLTJa5n3JFfUejbs91wYe+iS2/IvjuoceWLcfDliRVcIAfBNfvaRZUNBFlElekUYkv58kgidDCGJLJKIjCWuDa376U8DR4fmPCwA5ZVWO2C8iKfrfSCKGuw2E/yMhYV9HyAQ2Xdb1/COo40/zkuKGDGTDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023060; c=relaxed/simple;
	bh=c3qJIn/Wv+RcMaAg6N23t+QFf6GmIyIKlgeTHa8OD7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9+6y2jIJaE7uwWiLrnBan/E9z25oU9rkkbWCPifW7EIQiymQxO6M6SVZK0k3haEyq9/ChJNVhv2Bq7V48lCBSKIrHQlf9QaDTBO4vrSCEK0PpOMe3i9BFLaecDA8UYJd7a4H2l7xt4vfa3TZ+gaMecW7x8DpzA396Bx7cI7EiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUcnzQd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUcnzQd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E74C4CECE;
	Thu, 12 Dec 2024 17:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023060;
	bh=c3qJIn/Wv+RcMaAg6N23t+QFf6GmIyIKlgeTHa8OD7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUcnzQd/8F+MkEkDja6Zocbhc9adJXlFibYzpmVDk1zm06YB+WYQRsORW+AaJtqtp
	 ZxsJTi3lcn/RtFvMO0YQpi5XM4OV4enX4/UfOjNgBaxeRqLZLouOw40asZ4t4cFJSZ
	 93tv8TVTgIPEt5qTPVXEgFIWgLcECTNbgp5dK0FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/565] ptp: Add error handling for adjfine callback in ptp_clock_adjtime
Date: Thu, 12 Dec 2024 16:00:05 +0100
Message-ID: <20241212144327.865186242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajay Kaher <ajay.kaher@broadcom.com>

[ Upstream commit 98337d7c87577ded71114f6976edb70a163e27bc ]

ptp_clock_adjtime sets ptp->dialed_frequency even when adjfine
callback returns an error. This causes subsequent reads to return
an incorrect value.

Fix this by adding error check before ptp->dialed_frequency is set.

Fixes: 39a8cbd9ca05 ("ptp: remember the adjusted frequency")
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://patch.msgid.link/20241125105954.1509971-1-ajay.kaher@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index e70c6dec3a3a3..92dd1c6f54f4a 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -136,7 +136,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 			err = ops->adjfine(ops, tx->freq);
 		else
 			err = ops->adjfreq(ops, ppb);
-		ptp->dialed_frequency = tx->freq;
+		if (!err)
+			ptp->dialed_frequency = tx->freq;
 	} else if (tx->modes & ADJ_OFFSET) {
 		if (ops->adjphase) {
 			s32 offset = tx->offset;
-- 
2.43.0



