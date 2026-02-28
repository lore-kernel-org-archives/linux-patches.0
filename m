Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7471147CC62;
	Sat, 28 Feb 2026 17:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301317; cv=none; b=NueJNGEcshpJkt12EVU4QwCdWab+MUiYHlybjWnjUECNq1He9eJfS4ue6LnkN0e1cnmdUr5LXq1z3rbXhHRc4WVyi9EK8eCyhm2sum0VNyeVvErugN6HO5v6nmjng2q81mjzUrsNJNQa+wxN8LQKXv5jRDhSXn8V/HknAkjaFFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301317; c=relaxed/simple;
	bh=rSjy6sL5hSnkfOLqqG7zQ/p/cFN7Q4rphq2o6bHZHPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WcUQjeciBquhz1sePk7iHBz8M4FQQR/o58RcWZm1h5zd7GuJPrHMoQYOkt8dPBMz8gEWOIfvXZosv8LK3Eo9EOKSXYyfAgZqza80mSYRI4KXcGca/eqy2kh26wYepwVe8mGNRY2ev9NTbhkD5CjUX3RbIL70Yw4eDoyN5X+H/IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=os2Tqqnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="os2Tqqnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C256BC19423;
	Sat, 28 Feb 2026 17:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301317;
	bh=rSjy6sL5hSnkfOLqqG7zQ/p/cFN7Q4rphq2o6bHZHPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=os2TqqnnzsgDSDi0jm7PxB7+PFsuqDcOu+IKOd7WkWftDQPZlo87WCdRjVR4SRcCQ
	 2Z8IW4RkrtXdZP/oPgWbdoUnr3htOc+6NNn37K3per3IvNEBgTRv8tYwmXVxEsQVPj
	 32NoK3MsDpM4FbNIQAvPC+Q8LoOI3vwRLmmieBXMVEWx7LZYcH6Ygz0uiZZiRmGxgQ
	 z8QqqdGXQT0KwOPo6VHb5QLSfldXZxbK2b9+QJbsY3+VOxNAfdEX2F0Zct1EvKM3oQ
	 yI/AmfeQpu0Lj2uFmIh4IiKf2BSHNuSX+EJyj3YFkPSFbxIe25CL3DvUkqks6+oX2W
	 Tdj59Fr6Z/jkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	stable@vger.kernel.org,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 503/752] HID: prodikeys: Check presence of pm->input_ep82
Date: Sat, 28 Feb 2026 12:43:34 -0500
Message-ID: <20260228174750.1542406-503-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Günther Noack <gnoack@google.com>

[ Upstream commit cee8337e1bad168136aecfe6416ecd7d3aa7529a ]

Fake USB devices can send their own report descriptors for which the
input_mapping() hook does not get called.  In this case, pm->input_ep82 stays
NULL, which leads to a crash later.

This does not happen with the real device, but can be provoked by imposing as
one.

Cc: stable@vger.kernel.org
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-prodikeys.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index 74bddb2c3e82e..6e413df38358a 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -378,6 +378,10 @@ static int pcmidi_handle_report4(struct pcmidi_snd *pm, u8 *data)
 	bit_mask = (bit_mask << 8) | data[2];
 	bit_mask = (bit_mask << 8) | data[3];
 
+	/* robustness in case input_mapping hook does not get called */
+	if (!pm->input_ep82)
+		return 0;
+
 	/* break keys */
 	for (bit_index = 0; bit_index < 24; bit_index++) {
 		if (!((0x01 << bit_index) & bit_mask)) {
-- 
2.51.0

