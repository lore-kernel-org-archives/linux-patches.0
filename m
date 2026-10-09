Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F03A4E66A9;
	Fri,  9 Oct 2026 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557002; cv=none; b=klDjbaH7oPMB6foRbTvO6jcJksvABuRBey3O3IVxycT9UFnWt7RktG7wDrB+5QZdS24o9okrjF9BW+fd2n4zCCe9adXcSZOGutX4XzYs0C4ee7Oxa6P5HfV7sLNPcxOiD9Q+6PQYpHEtDb96J7cudWm3YAtuSntnszXT0fSxKiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557002; c=relaxed/simple;
	bh=4yukTm+HDY0NI6PloDU46a9Q31+guhS1k26jh5T03RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AA/etS7ejk2KTg/Jus6YMRzK4Jz/888wl/Th0vyHrXOMsBIVuoQFNH01Rj6Df1fH7xg8jlbKoF5vVpg6NCJ0fNhxGFGKBpy7rKgGGeL2MiKhUhzL/5Z1DZIcl5KMcCEtn9ZwKDpel4PR3ZXfaADrGissWg2dDkHOS2Dmc2GrKhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGObZ2Ts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGObZ2Ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ECC1F00898;
	Fri,  9 Oct 2026 14:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557001;
	bh=snPHsBr8IvNNz/lMEEjOB4j/blZzVoB6CjdAv3OnlZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGObZ2TstnuASV3p1dOkDpbGpnBjHrEFOrxH51PJPUOGAGJ6Rb52Vj4AfAXeaQNue
	 v7snCC09mcpXnq7SNCsOpC1pvqdNPpwWsowII4OyTGKvm79gYr+jcYnRbzsRDq7Ijc
	 wwQCTM8ZujTro2qCxLrBUgQLyIt13D4g/Spnc5KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 280/428] i2c: xiic: defer RX_FULL until all trailing bytes are in FIFO
Date: Fri,  9 Oct 2026 16:10:17 +0200
Message-ID: <20261009140952.249649769@linuxfoundation.org>
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

commit e6fe3ea04f0113fe4d47c03d76e03805a4768ca7 upstream.

For the normal path of xiic_smbus_block_read_setup() -- the trailing
bytes all fit in one Rx FIFO fill -- RFD was programmed two below the
byte count, which fires the RX_FULL interrupt while the last byte is
still in flight. xiic_read_rx() then lands in its bytes_rem == 1 branch
and sets NACK on a byte still on the wire, truncating the read.

Without PEC this is harmless: the truncated byte is the dummy one the
caller never looks at. With PEC enabled it is the PEC byte itself, and
i2c_smbus_check_pec() fails the transfer with -EBADMSG.

Raise the threshold by one so RX_FULL fires only once every remaining
byte is already buffered. That routes the drain through
xiic_read_rx()'s bytes_rem == 0 path, which reads everything out and
emits the stop cleanly. The only change for the non-PEC case is that
the controller waits one extra byte-time before servicing the
interrupt.

rfd_set stays inside the 4 bits of XIIC_RFD_REG_OFFSET: this branch is
only reached when rxmsg_len + pec_len <= IIC_RX_FIFO_DEPTH, so the
value is at most IIC_RX_FIFO_DEPTH - 1.

Fixes: e4c1ff772e1a ("i2c: xiic: Add smbus_block_read functionality")
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Cc: <stable@vger.kernel.org> # v6.3+
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260924-i2c-xiic-v7-2-df7e752332ef@nexthop.ai
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-xiic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -569,11 +569,11 @@ static void xiic_smbus_block_read_setup(
 			i2c->smbus_actual_len = 1 + rxmsg_len + pec_len;
 		} else {
 			/*
-			 * All trailing bytes fit in the Rx FIFO. The widened
-			 * condition above guarantees rxmsg_len + pec_len >= 2,
-			 * so this cannot underflow.
+			 * All trailing bytes fit in the Rx FIFO. Defer RX_FULL
+			 * until every one of them is buffered, so the drain
+			 * takes xiic_read_rx()'s bytes_rem == 0 path.
 			 */
-			rfd_set = rxmsg_len + pec_len - 2;
+			rfd_set = rxmsg_len + pec_len - 1;
 			i2c->rx_msg->len = rxmsg_len + 1 + pec_len;
 		}
 		xiic_setreg8(i2c, XIIC_RFD_REG_OFFSET, rfd_set);


