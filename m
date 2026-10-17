Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481A53A7D9E;
	Sat, 17 Oct 2026 17:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256617; cv=none; b=usDqVhlOU3wPvKk1TB6gjh9IANWJ2QTooxpxhP6d6fnYckONjKHO/MGKtNoTay3lnrl0LqSw4FiFbrma6bNhav2mL/8z7IWjYHdSrgc4e4LyLKp1Up7Ib/NiTN2RpLzEg/6y4ZGxbqR+t4dkZA6YkZRcNtn1hgtMIpLSXaT9ooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256617; c=relaxed/simple;
	bh=v8bgYQz+EZ9RCnLT17Qw0EY+MayIKzQSwz/X8GIHncI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFgzJt8CaJgkJvva/bR0RinPmTpdxf6YfI84/t1B1Ir8CDeSfzOGtMoFRLmKjTfc1elJRyVpAho2DgxS/FHWx9CEdQjg47nA8HXwEPcygUYJEqlHr35ipPzPjb6UC39/hnMGtB4RzhV0J2NiAAxBIjdcNqgMAhMdTZ212bcW6Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6NHcJ1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6NHcJ1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F54A1F000C4;
	Sat, 17 Oct 2026 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256616;
	bh=rZaU9xNxzYZ6N3BXV6nQno8UlP5IJcme5sOVhl4xrPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6NHcJ1fCZHcpTmiJCEYzc4L+uQHXlgiJc8i+FPFOD0LdMpYhIyZWR3QVdUzco33Z
	 0li+OUMNCFI8UO9AT8RPmaig8+HHZTk4y6pEr3AzUhuUFvspwreKNJh1BqvWhNwUnc
	 LAhxyel02iYezC4og1joKP65AMFOyuNC79Q5PR6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Michal Simek <michal.simek@amd.com>,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 0293/1674] i2c: xiic: dont clobber msg->len to signal block-read completion
Date: Sat, 17 Oct 2026 17:42:45 +0200
Message-ID: <20261017160438.635292626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -805,8 +805,11 @@ static irqreturn_t xiic_process(int irq,
 
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


