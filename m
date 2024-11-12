Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF9214415;
	Tue, 12 Nov 2024 10:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407444; cv=none; b=U1jgKIUS/+GN2Kolxw+N7iLo4CJ2z2fux0ijAtLUd0L6BnyAEOWxNzWVPPwAgp943LA1M7spipt3exb4UmJvQBnkVbpO7CpyxbqkTg5UYO0tbwS+JFSYc/tLXiKa4rrWRQGLJ2MUS0lratvxLvAsUHLz3snh11Gw+MEBbqqwz4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407444; c=relaxed/simple;
	bh=bwgQZWOgIboe7MF3/g3/ETdE2vc9/uffaYcdjl8FwBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkWFCg3qQW6x0T28bgFaxwAhqDCoNv1/iG5H9YxRjvYoiovcRPXHdhN/ogJRa2EpVC2qQ6Lub9aqkeLVBJBNskpiM6QwcvMDe5h6SaB5kMmceCC8bWSyrfraifTG6x6xnOgdzqBnZTrdWD7aowtcb+fLtmZtM1IKqJQNAkzRX60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlAtZieY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlAtZieY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B782C4CECD;
	Tue, 12 Nov 2024 10:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407443;
	bh=bwgQZWOgIboe7MF3/g3/ETdE2vc9/uffaYcdjl8FwBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlAtZieYuPo1Z7glsl4Zjx9kL5LJGcAInTuX4qEiHhRJJtnrcQFOMGQh5+IB/bO1F
	 KsEM8bYhax93Tznzk3ref5cz3FiiTCF8PSQqvIZnMu3MQWLu43qDzmKXKkClHZqhNV
	 d7O+K12NtDyA+Tip0EWpTexbGhP3/IXXq7bOV6xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 46/98] media: cx24116: prevent overflows on SNR calculus
Date: Tue, 12 Nov 2024 11:21:01 +0100
Message-ID: <20241112101846.024590455@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 576a307a7650bd544fbb24df801b9b7863b85e2f upstream.

as reported by Coverity, if reading SNR registers fail, a negative
number will be returned, causing an underflow when reading SNR
registers.

Prevent that.

Fixes: 8953db793d5b ("V4L/DVB (9178): cx24116: Add module parameter to return SNR as ESNO.")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/cx24116.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -741,6 +741,7 @@ static int cx24116_read_snr_pct(struct d
 {
 	struct cx24116_state *state = fe->demodulator_priv;
 	u8 snr_reading;
+	int ret;
 	static const u32 snr_tab[] = { /* 10 x Table (rounded up) */
 		0x00000, 0x0199A, 0x03333, 0x04ccD, 0x06667,
 		0x08000, 0x0999A, 0x0b333, 0x0cccD, 0x0e667,
@@ -749,7 +750,11 @@ static int cx24116_read_snr_pct(struct d
 
 	dprintk("%s()\n", __func__);
 
-	snr_reading = cx24116_readreg(state, CX24116_REG_QUALITY0);
+	ret = cx24116_readreg(state, CX24116_REG_QUALITY0);
+	if (ret  < 0)
+		return ret;
+
+	snr_reading = ret;
 
 	if (snr_reading >= 0xa0 /* 100% */)
 		*snr = 0xffff;


