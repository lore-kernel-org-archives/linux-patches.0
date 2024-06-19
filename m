Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFC21459F2;
	Wed, 19 Jun 2024 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801986; cv=none; b=SuDbHd8PKsjZ5j+iSy+hUxgKOGuzXcim2yA3ZLJVYIppIYxOL7s+LvAcVgsuXRNkS8yKg9GqNByWHjMAo+Q7yNqvQwU6LJAQAv+T+i8/lxkcuyAqinuFBO0ivRemrJD59tcVnlvZy9+K+Qt6nskPaO3msESqWOVP8KdM+ENstlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801986; c=relaxed/simple;
	bh=tN4Guvku0s8tlEAq3k9N2NrgluQK5CbSwo/bk6lr8Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsB6bPI9dlLC7on+QluIopdPmK+LhJ4fk4LPkdA/jTdUp00GBj5GaIuambrdP4lYz70IUKNYry9OHkpP11kG3GZHUrl/RkwhOp+zqZEJAjzrG7SdHwa3HUgBhlIGSbXNERUqnEnySS5ZjnbWJthzAONzSihae1uz1p1FTsjvaXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mvg5IDh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mvg5IDh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F45C2BBFC;
	Wed, 19 Jun 2024 12:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801986;
	bh=tN4Guvku0s8tlEAq3k9N2NrgluQK5CbSwo/bk6lr8Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mvg5IDh6TO3jh9q6w3g04XqXrzgu3vhgStm658DwkR8cvM9P9lFuN1shBULo3ZDPx
	 z24afXlbUX56QkLzJRSL6C+CoUcd/kv0/O530JwZQjN783FL+ORJDGS6mTyK/DlESE
	 2k6ESBKmZO1IoGlhQtW17zYI0/Pf3XPyUDgevbkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/267] ptp: Fix error message on failed pin verification
Date: Wed, 19 Jun 2024 14:53:14 +0200
Message-ID: <20240619125608.021131980@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5a3a4cc0bec82..91cc6ffa0095e 100644
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



