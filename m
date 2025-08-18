Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5F03218D6;
	Mon, 18 Aug 2025 13:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522447; cv=none; b=EZnekWXfYjwQqhgysGuzibYpc7RrKiSeKosfBvKhh3QlfvYncgOfAgACoSNiHu5GU7Mx3Va+WoDUrlBg3oj6NnnCiXWhch/pBjO8hyAdm9gtgYyjG+ed7p0/5S/SO0LkNb1H5V2CUh8H5jmIB8T1BUZLEeNqI4W0/kBxBKkYVis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522447; c=relaxed/simple;
	bh=8SzncU8ip9SIfqJqCViTxz0vN9DqmtEi7F+N6V9R1GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3KR5n+SEq/kMkMSH0Z4jWrApiTYWZEpQklQ/EHlBu0KpQ8ybCXqy8ZgAHUnusE/ecbBvS9nOAMts7ZSa+WL8L9pQzHby62T5Esc+jRPPS5J/B30p6iyW8bYvXWlmvJamNL3ZZ3Mmv4EE8aH8lf17nnayIcaYI6DMSO8KJmypuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5o1jInn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5o1jInn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9601C4CEEB;
	Mon, 18 Aug 2025 13:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522447;
	bh=8SzncU8ip9SIfqJqCViTxz0vN9DqmtEi7F+N6V9R1GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5o1jInndGacniA1lW9RTWUg5SQO0Rr6l7XfsMiboBerMa6XwsKfzmS4tiUO065Cm
	 Iiz8lhTQHlEgmzcr4Rn+4XwFapljHD743bPJa7/ZJuNf02ypmdn/DZxMXf52S7rslI
	 xlaiY1XsTJDJMpnkCXIeC1V+5JYRtNbk5oLkXe18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Guo <alexguo1023@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/444] media: dvb-frontends: w7090p: fix null-ptr-deref in w7090p_tuner_write_serpar and w7090p_tuner_read_serpar
Date: Mon, 18 Aug 2025 14:45:44 +0200
Message-ID: <20250818124500.869796451@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/dvb-frontends/dib7000p.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 24f13a866735..40c5b1dc7d91 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2193,6 +2193,8 @@ static int w7090p_tuner_write_serpar(struct i2c_adapter *i2c_adap, struct i2c_ms
 	struct dib7000p_state *state = i2c_get_adapdata(i2c_adap);
 	u8 n_overflow = 1;
 	u16 i = 1000;
+	if (msg[0].len < 3)
+		return -EOPNOTSUPP;
 	u16 serpar_num = msg[0].buf[0];
 
 	while (n_overflow == 1 && i) {
@@ -2212,6 +2214,8 @@ static int w7090p_tuner_read_serpar(struct i2c_adapter *i2c_adap, struct i2c_msg
 	struct dib7000p_state *state = i2c_get_adapdata(i2c_adap);
 	u8 n_overflow = 1, n_empty = 1;
 	u16 i = 1000;
+	if (msg[0].len < 1 || msg[1].len < 2)
+		return -EOPNOTSUPP;
 	u16 serpar_num = msg[0].buf[0];
 	u16 read_word;
 
-- 
2.39.5



