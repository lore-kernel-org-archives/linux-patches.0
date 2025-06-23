Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301624C74;
	Mon, 23 Jun 2025 22:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716118; cv=none; b=a2tCFjYvsBh+3rV2Z3E1UD7SqWcbIZ058fk7kf66fkqeq/4IPkpG1pkKlCigGLUPHWQi2hg+sYBCnJmhs6Yp6aNQ6SdJgh6AjvwHYSmV9yHrlicoqqJ+HMXtcrViAYsglq7Cauto7n16mGbUbpJ5Zc+NyVJMN3SRaIg0aZzuZPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716118; c=relaxed/simple;
	bh=Bk9hNytm/BpNueayOVSOtcIHL1/YEV/KXf3fS/ixxjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jF/wjVz5mDTtZPv+4nMldseqF2eyxccbMlnlECoQOz8kp8uqOd+IH/wFyxwcN5edpAfeW9+lO4QHZXXgeG/2Qaqxs4JfYqZPkDyjeJAN8OoPLHIrBqJP/Zj1iFUM6Obuw789U9A94IFWQeT+Q31b5uowCuWPHmpxBE9nBsechMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmJnO+Fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmJnO+Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AADC4CEEA;
	Mon, 23 Jun 2025 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716117;
	bh=Bk9hNytm/BpNueayOVSOtcIHL1/YEV/KXf3fS/ixxjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmJnO+FvcW0wrHOIwv2XqG2RZVo/mZlocHzwabIsGdlk2bFGRvBB8yZ3tIp20zcx7
	 ZjYj0v3Yw2YcLtJGgsKZIpF5J4Pebv7O1gPiuNjq2luSsoQkAKeGTVFZbOXmvxp+rt
	 0c3Akv2xa/xrI7doU7V0sWi1zEAtfdmnl8PhuLBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Kyle Tso <kyletso@google.com>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 281/508] usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()
Date: Mon, 23 Jun 2025 15:05:26 +0200
Message-ID: <20250623130652.172995072@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Amit Sunil Dhamne <amitsd@google.com>

commit 0736299d090f5c6a1032678705c4bc0a9511a3db upstream.

Register read of TCPC_RX_BYTE_CNT returns the total size consisting of:

  PD message (pending read) size + 1 Byte for Frame Type (SOP*)

This is validated against the max PD message (`struct pd_message`) size
without accounting for the extra byte for the frame type. Note that the
struct pd_message does not contain a field for the frame_type. This
results in false negatives when the "PD message (pending read)" is equal
to the max PD message size.

Fixes: 6f413b559f86 ("usb: typec: tcpci_maxim: Chip level TCPC driver")
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Kyle Tso <kyletso@google.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/stable/20250502-b4-new-fix-pd-rx-count-v1-1-e5711ed09b3d%40google.com
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250502-b4-new-fix-pd-rx-count-v1-1-e5711ed09b3d@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci_maxim.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpci_maxim.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim.c
@@ -171,7 +171,8 @@ static void process_rx(struct max_tcpci_
 		return;
 	}
 
-	if (count > sizeof(struct pd_message) || count + 1 > TCPC_RECEIVE_BUFFER_LEN) {
+	if (count > sizeof(struct pd_message) + 1 ||
+	    count + 1 > TCPC_RECEIVE_BUFFER_LEN) {
 		dev_err(chip->dev, "Invalid TCPC_RX_BYTE_CNT %d\n", count);
 		return;
 	}


