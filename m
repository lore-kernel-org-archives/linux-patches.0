Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1EB2FA622;
	Tue, 17 Jun 2025 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179486; cv=none; b=fqWZcwCdUy3XcN0kT0YL/gAK2THlL6X/LkDkK3xVAVhfcIUqDvS7DmEH27Nyir6DJxt0kXkk6ddvWtfviF7xuwCuqOQ7L63Ae7BQIrmliLPLcdSuy9pjjUTlFpvk7c4do8kCUVn3hkiDID8c53K5k1En3a48rg9RNq1ODz70wqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179486; c=relaxed/simple;
	bh=+x9p0TGeWjtqSTLRu7UgiEHKGxMdtkd7kzrvSqc1HTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tP1j8Q+mr/SEuE+/o4TP1RhaGc2ekRJ/6LEOxAy0V7Bwj4AdFaEu0GsID2gROqfTimH9SWfcEfIfkfOzw1FFFVuxIvcrnu8gKgF/zNXfl8AO7REhRiHpls0C5MVDDo0XYtwY2RDLZd1DbC802cSmUGQk0tBALfo+aoQHO6eoKQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8N0uEX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8N0uEX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939C4C4CEE3;
	Tue, 17 Jun 2025 16:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179485;
	bh=+x9p0TGeWjtqSTLRu7UgiEHKGxMdtkd7kzrvSqc1HTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8N0uEX8MF5wwcnDonDuR+bmmlFIboB1Q5ZK5w7lQo6avd3MbMozjUW9pZV6R0CKl
	 ejxbKEtZDispC9eOGKi8c3cPcfqJGksH1XskYD5kJ7eyJ/JXIC7bMJK2kFkC1NCac9
	 PvWK3vMPGH9JzfDUveWzriej8GFxecbRyCxpjWYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Kyle Tso <kyletso@google.com>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.15 760/780] usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()
Date: Tue, 17 Jun 2025 17:27:48 +0200
Message-ID: <20250617152522.455589578@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/typec/tcpm/tcpci_maxim_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpci_maxim_core.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
@@ -166,7 +166,8 @@ static void process_rx(struct max_tcpci_
 		return;
 	}
 
-	if (count > sizeof(struct pd_message) || count + 1 > TCPC_RECEIVE_BUFFER_LEN) {
+	if (count > sizeof(struct pd_message) + 1 ||
+	    count + 1 > TCPC_RECEIVE_BUFFER_LEN) {
 		dev_err(chip->dev, "Invalid TCPC_RX_BYTE_CNT %d\n", count);
 		return;
 	}


