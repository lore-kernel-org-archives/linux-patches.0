Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570B1338F51;
	Tue, 26 Aug 2025 13:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216429; cv=none; b=jU+Oi4pAFPJf+CDlOPeoWdHoYMnstCJjds+GqH/TleuEJ1w22yOSW4FBk+2L5mPoJbfeoxXfkmauP2OCz6pz0hL7+KWc7Y42yu47liN7shAToAecGfRp7gRFlcJFJgY3Z5TonFNndQLGMzX/FJ/zVe4bw/pawwrQt9OIGf21m10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216429; c=relaxed/simple;
	bh=tikVpCArvSY+jXqy9ObybvNuxbcImHmQA5/kwsToKMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEpwk++it2J4uFpmHkLjoDzWFOif6TUi9iDmZtoLIsdBy0CS9TbzRVySNDl+5wbAbufz0GBFtYQkO2QHBXIF0mJQUAUDtA9IJ+mNtqSdP+iXvFzXCfaPjROZEp+TaYOz+pKu2hr2ppIv49vSanQxZz+RHDKC7s1fW6j2GURCL+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpDpcKzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpDpcKzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8871C4CEF1;
	Tue, 26 Aug 2025 13:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216429;
	bh=tikVpCArvSY+jXqy9ObybvNuxbcImHmQA5/kwsToKMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpDpcKzWtwISzrs6Xfh8mW8Dq500SOdCR04OQkVOyjaJKTvhnKq3NQMqn4LJbk4yB
	 o10WHPEl8cu6HQrorkOhPOEUmtWLGMZT415E1DkFv7DQHHuE6Ngw9oCF4pdp4tFVNv
	 d+aTKJV6wSKt//HWatY2sXJy9kkoq2ZpQNcQfPO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Guo <alexguo1023@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 409/644] media: dvb-frontends: w7090p: fix null-ptr-deref in w7090p_tuner_write_serpar and w7090p_tuner_read_serpar
Date: Tue, 26 Aug 2025 13:08:20 +0200
Message-ID: <20250826110956.589676042@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Alex Guo <alexguo1023@gmail.com>

[ Upstream commit ed0234c8458b3149f15e496b48a1c9874dd24a1b ]

In w7090p_tuner_write_serpar, msg is controlled by user. When msg[0].buf is null and msg[0].len is zero, former checks on msg[0].buf would be passed. If accessing msg[0].buf[2] without sanity check, null pointer deref would happen. We add
check on msg[0].len to prevent crash.

Similar commit: commit 0ed554fd769a ("media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()")

Signed-off-by: Alex Guo <alexguo1023@gmail.com>
Link: https://lore.kernel.org/r/20250616013353.738790-1-alexguo1023@gmail.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dib7000p.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2200,6 +2200,9 @@ static int w7090p_tuner_write_serpar(str
 	u16 i = 1000;
 	u16 serpar_num = msg[0].buf[0];
 
+	if (msg[0].len < 3)
+		return -EOPNOTSUPP;
+
 	while (n_overflow == 1 && i) {
 		n_overflow = (dib7000p_read_word(state, 1984) >> 1) & 0x1;
 		i--;
@@ -2220,6 +2223,9 @@ static int w7090p_tuner_read_serpar(stru
 	u16 serpar_num = msg[0].buf[0];
 	u16 read_word;
 
+	if (msg[0].len < 1 || msg[1].len < 2)
+		return -EOPNOTSUPP;
+
 	while (n_overflow == 1 && i) {
 		n_overflow = (dib7000p_read_word(state, 1984) >> 1) & 0x1;
 		i--;


