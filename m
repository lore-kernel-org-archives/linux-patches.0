Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816BF3D2FE0;
	Thu, 15 Jan 2026 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499405; cv=none; b=ouXcmFdzEROG3YEvHqlObRbCbLsZmp3tVtNr+jCUYxVJZXaYEpbsN9R8Y26cpcmmW+mlXfOV8c27Rx+LpogH/f7d8rRGtz9siAYUgWH2W2zj+kZtaua+lHcEdBYDKBkNwxfdvmnseoPO8heLxrIctXaUgZAdlmplSest2EVQ3pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499405; c=relaxed/simple;
	bh=nwB7poy+0E6NqxWv9MWOYXi6yiZwJuZkYGvLb16fGPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGNpVvuMjlTenmj3UWLhqbxsQqC3ebC6S51BwmQzo7lSGvkje0ogWCSxp0wKHYzhdhuVIMu548LPhlFMv2DRznEPk97rtk4KAizlywdF803Br3mavkuVlDyDpnDbVNJIu6lyHGjGP66Pd5kmydhF3moUQ2VnSJ7PxVNjNafbHGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehgkccnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehgkccnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32D8C116D0;
	Thu, 15 Jan 2026 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499405;
	bh=nwB7poy+0E6NqxWv9MWOYXi6yiZwJuZkYGvLb16fGPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehgkccncdVUS1HEKWem7ym6LLYdLBwzLoupNV6TN7z5YJgC0sXMx0oER0hsmcHUeC
	 lqbseEMAk9qNmidTeBELXlwfjcgq02AvYDKSJ79YUTm+b0NMzADSX6JQK8piBfPTMx
	 lfa8zTN3pZGJ4+e+Vfx2xLSpZOpWgW9uKrdBPCZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/451] usb: typec: ucsi: Handle incorrect num_connectors capability
Date: Thu, 15 Jan 2026 17:46:56 +0100
Message-ID: <20260115164238.676554132@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0851d93d5909..60339c746694 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1220,6 +1220,12 @@ static int ucsi_init(struct ucsi *ucsi)
 		ret = -ENODEV;
 		goto err_reset;
 	}
+	/* Check if reserved bit set. This is out of spec but happens in buggy FW */
+	if (ucsi->cap.num_connectors & 0x80) {
+		dev_warn(ucsi->dev, "UCSI: Invalid num_connectors %d. Likely buggy FW\n",
+			 ucsi->cap.num_connectors);
+		ucsi->cap.num_connectors &= 0x7f; // clear bit and carry on
+	}
 
 	/* Allocate the connectors. Released in ucsi_unregister_ppm() */
 	ucsi->connector = kcalloc(ucsi->cap.num_connectors + 1,
-- 
2.51.0



