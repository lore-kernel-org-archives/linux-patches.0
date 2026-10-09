Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E25F4E2F35;
	Fri,  9 Oct 2026 14:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557007; cv=none; b=uV7EO7F9psgDTidAtP+3lgV2UCtqjHfRO4enYAl7nH0pz2tMgKfiglzdDtteU/q4IDPMHCGuq6sk5oiCo6T/wT+BWHumpVgAJ47JG1GIo120fWNpMvyskCIZxwBkGfJxptDao0uhaNI2jj7JYldiJVrHch9MS0KZxRskyn6yQ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557007; c=relaxed/simple;
	bh=L9wUdVY/6BQgnvh+xft/UykQJ9js4dOlEcbaDn10RTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePFs23X2n3c0yUDzk+g1NimSQDJoX2W+4COkADd8JgHfN4CAOte1E4WYBHcbMu7LbdeAgkeycZgNAnUja5meReYNWm+DUq15w1c79Xe1ktyEgpy/I8EWXukw6hqvC3oOkzgaN/u3VwPjpW3Gu1x6ZX6Ja/i+T00fB0BAT4HEbOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6NyXH1y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6NyXH1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045EE1F000FF;
	Fri,  9 Oct 2026 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557006;
	bh=HWH1FRyaM39AcK2b9/KM0sYjFeKgTd/ixHt6dvoXFkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6NyXH1y+rwaKfzqn+VgZLz6+SMmwcx9IRgLnemEWD0tcBpPxdUcGITqTBOSZthZ7
	 skFPgSFY+8kNxYRdQ5whNS0mrT0GhTXgWIq//WrL8TRhrkl4eVjUl/UsYO8eCQb5QD
	 wdV/EgV4ImlTXmAGKEdejSXkMTUT+9p+Hpp0zikk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Michal Simek <michal.simek@amd.com>,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 281/428] i2c: xiic: dont clobber msg->len to signal block-read completion
Date: Fri,  9 Oct 2026 16:10:18 +0200
Message-ID: <20261009140952.273143117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 840d8acc87925deb3c75566fde9ca81d2f47f98c upstream.

At the end of a SMBus block read the BNB handler force-set
tx_msg->len = 1 to push xiic_tx_space() to zero so the STATE_DONE
branch would fire. Two problems:

1. tx_msg and rx_msg alias the same i2c_msg struct during a receive
   (see xiic_start_recv), so overwriting tx_msg->len also changes
   rx_msg->len. The i2c core's i2c_smbus_check_pec() then reads the
   PEC from the wrong offset -- buf[0] instead of buf[rxmsg_len + 1]
   -- and either mis-validates or returns -EBADMSG.

2. xiic_start_recv sets tx_pos = msg->len (typically 2 when PEC is
   enabled). xiic_tx_space() is unsigned msg->len - tx_pos, so
   setting msg->len = 1 with tx_pos = 2 underflows to 0xFFFFFFFF and
   xiic_tx_space() never compares equal to 0 -- the STATE_DONE check
   falls through to STATE_ERROR, giving -EIO.

Instead, advance tx_pos up to msg->len. That drives tx_space to 0
without touching msg->len, preserving the buffer length that
xiic_smbus_block_read_setup() already grew to cover the length byte,
the payload and the optional PEC byte.

Fixes: e4c1ff772e1a ("i2c: xiic: Add smbus_block_read functionality")
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Cc: <stable@vger.kernel.org> # v6.3+
Acked-by: Michal Simek <michal.simek@amd.com>
Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260924-i2c-xiic-v7-3-df7e752332ef@nexthop.ai
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-xiic.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -889,8 +889,11 @@ static irqreturn_t xiic_process(int irq,
 
 		if (i2c->tx_msg && i2c->smbus_block_read) {
 			i2c->smbus_block_read = false;
-			/* Set requested message len=1 to indicate STATE_DONE */
-			i2c->tx_msg->len = 1;
+			/*
+			 * Drive xiic_tx_space() to 0 to signal STATE_DONE
+			 * without truncating the rx_msg length.
+			 */
+			i2c->tx_pos = i2c->tx_msg->len;
 		}
 
 		if (!i2c->tx_msg)


