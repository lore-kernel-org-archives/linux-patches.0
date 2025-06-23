Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0482AC2E0;
	Mon, 23 Jun 2025 21:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714363; cv=none; b=bC5dtM3MReyK9nOgpwMnWrzItRTh50gaQxfZlDDVcLf3boBfNpm0rgAhtcgXSIpwXmvvgn//liCdfFIIJaE7255UkPmq/xsTAi94Om/djVhnM9IZrLe9FecGuZo6bb+1V+OApM6Sy0HzPWr8IChs0+Y4r8LRtg2OucjUflFx/Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714363; c=relaxed/simple;
	bh=rKroy6KZWhpC0oE5cwELAGo5M/U3iTt446VNLK5BQsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryhHpf3b8kiLZcev4kcbPiXM/wOcndCeKjWjs0V7+2YXe6AvYpYH1+FQKkYWfLaEhESk3iEaKIZzmk8Ret09wtwHCUW7Vcn1uWkWcK/cq5gkJC4sG5XK6C5NGzlF7rWxIrAPES63IR92QrAbd6B+IW1LQNQf9Qpqp/auYTI+GIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMiKLc+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMiKLc+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BC8C4CEEA;
	Mon, 23 Jun 2025 21:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714362;
	bh=rKroy6KZWhpC0oE5cwELAGo5M/U3iTt446VNLK5BQsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMiKLc+vN+O/tGEnOmmp19w4WWYCNRRyFJj77yN3Kl/yEkLand8UvTsdEWz5yQWVa
	 bNF9n86PlWsVWU156imtj5AtDBiUvJdRdOo4EfY5J9WydJ2PbPIgupRMKoJdQlyVxq
	 VSJqu+pvNQodI33Z69S4TRW78zts75raqtlarWAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Kyle Tso <kyletso@google.com>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 183/411] usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()
Date: Mon, 23 Jun 2025 15:05:27 +0200
Message-ID: <20250623130638.289674582@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


