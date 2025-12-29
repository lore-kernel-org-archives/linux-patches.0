Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2F2202F65;
	Mon, 29 Dec 2025 16:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025395; cv=none; b=R0wurGplX+R4BdoBgxR69Fz30LmMRMkINki6pgpBdey8c7QyPoSjZiiOaxRUMkSi+s5nEQtVixk31VAac5JyuSYZD2aTHejCYpMJwmweK+3mFsSC8Ir8p4MAMm13xOKA0kUof9CYQyQAAsjxajc84Dft/5TRM+Zj1OES0Axqm4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025395; c=relaxed/simple;
	bh=tbHqcgi8KFB+aXR/myFuqQuqYsGNyq0LSmlu7Evcr/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bP2cLj4v3MSsOTBS+oktwueAB5pfAE9AH9Tk2l5yHgmXOmezf/804Oda1tdUmNyH2vnivDnRQ7kxyC9x/j67zDrUrBbXVkR2oijWhJiA41X/DR7oWHKAHkUokgyha1L0UJeaI3Wr5bs8N+p4Sld44WQA13Uut3ZVACReIcu+drM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRDSbKFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRDSbKFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25072C4CEF7;
	Mon, 29 Dec 2025 16:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025395;
	bh=tbHqcgi8KFB+aXR/myFuqQuqYsGNyq0LSmlu7Evcr/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRDSbKFuC50yFWq4zDnpMhjAJfEJXojsesYoRs/HsVTPSqS+KNScqoEc+MVVDC31C
	 DzpTMPE79IWHa+au3/a7I2cVTIj/i6jATRGR1jHWCnQEXo5T8tfZ6YxRvJBW4kCT9o
	 wD8m0dNkHFu4VhourY1OxfL+SBQdjI7vZi+MMY34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 197/430] usb: typec: ucsi: Handle incorrect num_connectors capability
Date: Mon, 29 Dec 2025 17:09:59 +0100
Message-ID: <20251229160731.603262260@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 30cd2cb1abf4c4acdb1ddb468c946f68939819fb ]

The UCSI spec states that the num_connectors field is 7 bits, and the
8th bit is reserved and should be set to zero.
Some buggy FW has been known to set this bit, and it can lead to a
system not booting.
Flag that the FW is not behaving correctly, and auto-fix the value
so that the system boots correctly.

Found on Lenovo P1 G8 during Linux enablement program. The FW will
be fixed, but seemed worth addressing in case it hit platforms that
aren't officially Linux supported.

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250821185319.2585023-1-mpearson-lenovo@squebb.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 3f568f790f39..3995483a0aa0 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1807,6 +1807,12 @@ static int ucsi_init(struct ucsi *ucsi)
 		ret = -ENODEV;
 		goto err_reset;
 	}
+	/* Check if reserved bit set. This is out of spec but happens in buggy FW */
+	if (ucsi->cap.num_connectors & 0x80) {
+		dev_warn(ucsi->dev, "UCSI: Invalid num_connectors %d. Likely buggy FW\n",
+			 ucsi->cap.num_connectors);
+		ucsi->cap.num_connectors &= 0x7f; // clear bit and carry on
+	}
 
 	/* Allocate the connectors. Released in ucsi_unregister() */
 	connector = kcalloc(ucsi->cap.num_connectors + 1, sizeof(*connector), GFP_KERNEL);
-- 
2.51.0



