Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AFD18595E;
	Tue, 10 Sep 2024 10:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962796; cv=none; b=XoEPKRWnaWSUjfPqYdWtMTAv8wE0Gdx++RqJldd3kDMLB0+n00PEjVnfk9+OOwL93hKrplSTVcOeo89ZSIVxCP6eNVH5NU150+SEWkcgmXlZhqjm2HGt0JaUzrXIOLepSbsOR2LmiqQdiXltIzo9BENnQ+zmkI+bmXVCqNUXK+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962796; c=relaxed/simple;
	bh=cOV87OJFaLD/PxJlN/IoqR5s7i7n4bJqHla9DRuxO5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BD20jIyCqiosEqpaAPITNaw4/tK7NYK9AyJBYdLYkv3vkL0qOMmO4YUiPhs+vvQNV/VmTo0+u/1QnUEU9Op3kURI6wueJ2q5w6kBSk9Ouo5b0EjG6B/klEjUOswsgV0kd9FP00kcg2StsFyWeec5tUhm/O+jj7oxuBbClzNAQM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZhqWB9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZhqWB9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15DBC4CEC6;
	Tue, 10 Sep 2024 10:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962796;
	bh=cOV87OJFaLD/PxJlN/IoqR5s7i7n4bJqHla9DRuxO5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZhqWB9qvstxy5PhTNRg4gpG05Kob2NO416AyKICX5aycNHEXK8OFwWoWN/4oDl3f
	 /+ZYIvPmLFjL14PCgvOFBkxV1pjQe6bo8mp98pxPJ+PhVj4cHCkRgPIZGcQBtIYD9R
	 hnJq4pR8dWQLWDkUr6TaMLq4VreJkbXn2quvuYAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 033/192] net: mctp-serial: Fix missing escapes on transmit
Date: Tue, 10 Sep 2024 11:30:57 +0200
Message-ID: <20240910092559.318700625@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

commit f962e8361adfa84e8252d3fc3e5e6bb879f029b1 upstream.

0x7d and 0x7e bytes are meant to be escaped in the data portion of
frames, but this didn't occur since next_chunk_len() had an off-by-one
error. That also resulted in the final byte of a payload being written
as a separate tty write op.

The chunk prior to an escaped byte would be one byte short, and the
next call would never test the txpos+1 case, which is where the escaped
byte was located. That meant it never hit the escaping case in
mctp_serial_tx_work().

Example Input: 01 00 08 c8 7e 80 02

Previous incorrect chunks from next_chunk_len():

01 00 08
c8 7e 80
02

With this fix:

01 00 08 c8
7e
80 02

Cc: stable@vger.kernel.org
Fixes: a0c2ccd9b5ad ("mctp: Add MCTP-over-serial transport binding")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/mctp/mctp-serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -91,8 +91,8 @@ static int next_chunk_len(struct mctp_se
 	 * will be those non-escaped bytes, and does not include the escaped
 	 * byte.
 	 */
-	for (i = 1; i + dev->txpos + 1 < dev->txlen; i++) {
-		if (needs_escape(dev->txbuf[dev->txpos + i + 1]))
+	for (i = 1; i + dev->txpos < dev->txlen; i++) {
+		if (needs_escape(dev->txbuf[dev->txpos + i]))
 			break;
 	}
 


