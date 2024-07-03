Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF7D16F0E4;
	Wed,  3 Jul 2024 10:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003758; cv=none; b=HhtO5Nsa2bmBmaS7hoi3HRpZx67dEXZpa3xu+9jpHd4Iaccp1AKEv15rE58a4V9D3JUaJ70/8qyI3k0ZH8Y0+yTS9ULnYbIt/7ReTXMyMLiM/omZAQ+LIzr/NMiKAjYsqg9bGWVZXXG6u56u6xV506FkOdipC6PSfwkpxVtM1vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003758; c=relaxed/simple;
	bh=ClNMGVW6pAUE4or/Ti1vTPAjIBqqxRv9rzyD7PCNIsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctp7nCf2Jlsmj6lz+6rc8KL+yLoc75ABqF6TYmU6aez4eHKjA5Z5LhRgbKpw+dU1uxSazRtYOksRxGDN9/Xksaniw9hovNddwR3Ick4+sTGOQTxijlcRpku8kz+mxPnxVkUZcHYyIiow22x4tQl/GRZ9Vh2iQ4d6fmhU2jbbUtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8tjtO3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8tjtO3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B0AC2BD10;
	Wed,  3 Jul 2024 10:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003758;
	bh=ClNMGVW6pAUE4or/Ti1vTPAjIBqqxRv9rzyD7PCNIsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8tjtO3vRs5ZxMFXWTi9PFDe42YNDa9SmyxH1zMBf7uh0YS3iZFQoJAJogVMznnUw
	 H5BK5v8Gz/+b9Fx/zi493SHclGcTyLB3LTBaD8YkVZSzMgFkhiA46emdS0hH61KwyT
	 TNjJGsMUF9EvZsMkHBZygfEM+tT3MGb2xpdchUdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/189] ptp: Fix error message on failed pin verification
Date: Wed,  3 Jul 2024 12:37:54 +0200
Message-ID: <20240703102842.003871497@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 87bd6c072ac2f..37c4807f15c60 100644
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



