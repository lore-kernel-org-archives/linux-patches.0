Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DFA21EBBB;
	Tue, 12 Nov 2024 10:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407827; cv=none; b=N7Ee0lAdP3F4N4td8rnKDe/GZwNMxFsr4EctLQMxLypkJ5nAJ9hp4UE3GFvdIb3sywHLv5unROB5IVkZkOAC3vt7ltXAqZIH+FTpldty1ubOtfQY7IUUNh1wOGmb4vaaOdJynSZuB8bnbVl5LyRMT5wr7lslzL27QCoUcDs+E48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407827; c=relaxed/simple;
	bh=xtP2FcuwhLO4bJVH1aZuwM5B9cg4VYpgMvgBiKa+4yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+woFYv9Qdreaj3kXIINEgYEWBaPKF6rdrMTUSfQGocxRhk9fYcJQNF7iiyKgpoU1pJV3scN0rXx1vbHHTwrTPe7rlGS1orrsAfF7cmMzkdnStzgzPEVt83GmarfqTcZnf42mJRUgnm8Y5U/TYBKNSXFnqZrzFObn7enovoy1BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mm5NWpWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mm5NWpWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31234C4CED6;
	Tue, 12 Nov 2024 10:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407826;
	bh=xtP2FcuwhLO4bJVH1aZuwM5B9cg4VYpgMvgBiKa+4yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mm5NWpWxFmz6h+V2jag87nzvLD5qhvfx8xfQadKCuNXlo0bj75gMvh4WuXm/KpW8W
	 W5hebjBSvl+WlPSsr8zmElMR8PIsWFuXoUP/hkW38NnJU2Kh6cRxcd2jtX6crZICZi
	 I6p4+sOWNit8qoOZKud3AD0XrGKNFt8Z1GzLfidM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 063/119] media: cx24116: prevent overflows on SNR calculus
Date: Tue, 12 Nov 2024 11:21:11 +0100
Message-ID: <20241112101851.122058885@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


