Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9B8169AD2;
	Tue, 16 Jun 2026 16:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629049; cv=none; b=LJUsiDP1vzVG3rrtXX9IDSyh5D68sKEK+TMFOmXoKATN2Zrkt6KC+qfGHDC/TK6UwbDoQrTNARH+LwMsBNr6HI3LoB955R1qiVhTFEy7c5vTerKgfjM+smBaR4Gkt9PoFE84qT4/yImz8jJh/KOugvFy18DkVhL/hJmWx0uDf54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629049; c=relaxed/simple;
	bh=fnQgEhuRDMscEsJrPjyqrvDSQSqUyyAyI/SC3GkZcRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMIZ2NGfibw6QL989WKTSNwfa1BcJpHm34nfe+MfRtReW1D2KXS5d0gKxFo8eBkFDymOUXv1oTo6OZNnYWrnwZXJZccSmKe8ExGPBfuaHFeXFC09Dv4eOFwUbrXm/WIUzsjlwugT940TuAi1f/CTLZtiQ7esOpHN2ib1LIAbLRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAIJGaii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAIJGaii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6C51F000E9;
	Tue, 16 Jun 2026 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629047;
	bh=Vq6QVwnzoLjPNubJD/BiVeTIyBsLLlEczzCkWGG5iPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAIJGaiiT80V/8va7QZKyrAnKKuAkl32xfuaEIWcSSi530R208LxS3Ow1byBgtyrd
	 TrzKKASPLDMry9wQ+ubpsAH0CJYF2UlMB7ZHp8QJnvgs3RbnB2I4zadDW4w7Vpp3kh
	 bA65H+f8SOobNuyhRjTVvnpMT6rhnChE3SdBHfMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.6 210/452] i2c: dev: prevent integer overflow in I2C_TIMEOUT ioctl
Date: Tue, 16 Jun 2026 20:27:17 +0530
Message-ID: <20260616145128.836626846@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

commit 617eb7c0961a8dfcfc811844a6396e406b2923ea upstream.

While fuzzing with Syzkaller, a persistent `schedule_timeout: wrong
timeout value` warning was observed, accompanied by SMBus controller
state machine corruption.

The I2C_TIMEOUT ioctl accepts a user-provided timeout in multiples of
10 ms. The user argument is checked against INT_MAX, but it is
subsequently multiplied by 10 before being passed to msecs_to_jiffies().

A malicious user can pass a large value (e.g., 429496729) that passes
the `arg > INT_MAX` check but overflows when multiplied by 10. This
results in a truncated 32-bit unsigned value that bypasses the
internal `(int)m < 0` check in `msecs_to_jiffies()`.

The truncated value is then assigned to `client->adapter->timeout`
(a signed 32-bit int), which is reinterpreted as a negative number.
When passed to wait_for_completion_timeout(), this negative value
undergoes sign extension to a 64-bit unsigned long, triggering the
`schedule_timeout` warning and causing premature returns. This leaves
the SMBus state machine in an unrecoverable state, constituting a
local Denial of Service (DoS).

Fix this by bounding the user argument to `INT_MAX / 10`.

Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
[wsa: move the comment as well]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-dev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -476,12 +476,13 @@ static long i2cdev_ioctl(struct file *fi
 		client->adapter->retries = arg;
 		break;
 	case I2C_TIMEOUT:
-		if (arg > INT_MAX)
+		/*
+		 * For historical reasons, user-space sets the timeout value in
+		 * units of 10 ms.
+		 */
+		if (arg > INT_MAX / 10)
 			return -EINVAL;
 
-		/* For historical reasons, user-space sets the timeout
-		 * value in units of 10 ms.
-		 */
 		client->adapter->timeout = msecs_to_jiffies(arg * 10);
 		break;
 	default:


