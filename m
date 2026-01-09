Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA16E359FBB;
	Fri,  9 Jan 2026 12:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960426; cv=none; b=ki7BelI3Sp0KFioTNSgmUzQRLExsGGmQJgwSE61A4jxL9cStcj1ClBt2h3rqWeMOjccf5RB4WLhru/v4JH7hok21tj6ZUZtxb9kVN88rwpdJ29QyEsu3MSOPxlr+UjNZGtLCLe4mQLsmfvbRK5IOP48vYd7l26W5URmGUmK/HFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960426; c=relaxed/simple;
	bh=5hRsiVzau/2KBgPNsXkZovHTVRI7t5gnxSomNRr0QsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqGVLs9sIZNaJeQf4qOTn7XARco3y5n6vAAQ3QejFoKGIEildNzeuiFhYuGbFiqxCjFoCVFjkcNhsMKuUEn4UO4tsoEcY4djDpktt5h3+NJtwuJRQb6H9I1H++wW/UYRJWi6473E4DQz22cDv5m01v/7H8CviO3YkAMmhSTdTLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dE9/E2LD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dE9/E2LD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755D9C4CEF1;
	Fri,  9 Jan 2026 12:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960425;
	bh=5hRsiVzau/2KBgPNsXkZovHTVRI7t5gnxSomNRr0QsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dE9/E2LD8waZwhCJipG/UmJJgI8pgDvYOM16DuRKh+tn3CVAz6zg16z9p6MF240Zd
	 D9a9VoQZAINXn5g08+TXm/5dYoyxhwAHOnooEaYqL/dITpluUNso3zig0k9uEWVFha
	 foOHcQCEA/3d3Rshs1Z6XpU6iViZNcnlKHB5u3JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 400/737] usb: typec: ucsi: Handle incorrect num_connectors capability
Date: Fri,  9 Jan 2026 12:38:59 +0100
Message-ID: <20260109112149.048907616@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e5c001ee0cd7..b88f4e179a7a 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1428,6 +1428,12 @@ static int ucsi_init(struct ucsi *ucsi)
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



