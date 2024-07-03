Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F32918E74A;
	Wed,  3 Jul 2024 10:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004391; cv=none; b=F/+ch5XFqYhgPsbRB2SZLsY5OT9xW24dK30488SQnA0OOjmis2+IRJvHu85DWz4tqt50d5Y3qkgk18mbhQ3FUm1pQnDR8AZ0EqcbTp4GhxTwXsCC/AJXMFrLxp0QrbuEhzI6m+HzGy1WTQeJhtAi+LFdEpySS7dnXqKs7O58hQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004391; c=relaxed/simple;
	bh=NfEWPVS/XNZPbdG69u3X83kdOLoLKCUpmQT7Z/OoDkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYD7T+7QolxnVlyXwVAPCZXqjOL4UjB729FcxtLp0SsmutB12+ufbOKAUKHLlB7oVxxQZTPqlqZuPe1tNUn1rTZfeVQyvaGihQLpTIEtSJ6rqCRRF/5a03OgZRb9jWn7+frwCgXL9JTLM7b4K2wFAUg6Dp2ilBDjx9NNVPjubuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY3c9f6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY3c9f6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9E6C4AF0B;
	Wed,  3 Jul 2024 10:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004390;
	bh=NfEWPVS/XNZPbdG69u3X83kdOLoLKCUpmQT7Z/OoDkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mY3c9f6J/kU7SswUJ79s1TfcCqExEljafIGyuknUhMGgld73RuZNY91nJ4lOCXna6
	 Kd/49sVKHhEkHsHOmsxtbgNriCI8/7J+QJCljzHch9+zvxHbxSI8GS44X15b2aodm7
	 eLo5VFZ9BkKantuvahoUHLcAxcO1prZ21du+FybU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/290] ptp: Fix error message on failed pin verification
Date: Wed,  3 Jul 2024 12:36:40 +0200
Message-ID: <20240703102904.918241140@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Kolacinski <karol.kolacinski@intel.com>

[ Upstream commit 323a359f9b077f382f4483023d096a4d316fd135 ]

On failed verification of PTP clock pin, error message prints channel
number instead of pin index after "pin", which is incorrect.

Fix error message by adding channel number to the message and printing
pin number instead of channel number.

Fixes: 6092315dfdec ("ptp: introduce programmable pins.")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20240604120555.16643-1-karol.kolacinski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_chardev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 9311f3d09c8fc..8eb902fe73a98 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -84,7 +84,8 @@ int ptp_set_pinfunc(struct ptp_clock *ptp, unsigned int pin,
 	}
 
 	if (info->verify(info, pin, func, chan)) {
-		pr_err("driver cannot use function %u on pin %u\n", func, chan);
+		pr_err("driver cannot use function %u and channel %u on pin %u\n",
+		       func, chan, pin);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.43.0



