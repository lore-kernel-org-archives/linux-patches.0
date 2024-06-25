Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595271465A8;
	Tue, 25 Jun 2024 09:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308848; cv=none; b=ThXwkiHAobbSL4LqH1TU/lP9AQrQqXBQ+sgb3/oIc90b+c+g4KfgueczVs+gCxX4isId8+WQhEPe1YrYAEOTEjmOjRCrFvhuAdMXpzzs7xmFO7W6nolLNNac0NGKebilubkcLihl+oB1mcSL5BeoaSHK7mIWkxtJa5qVhgyDRdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308848; c=relaxed/simple;
	bh=ZftK36LYvJ/n6PyeADegLXJMPcHce24GRgHdwpr5x/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJMqv2/xEbt2ioNN/e55YVQz65vtU/f9e+ZQ9Sgh7jyZfHTOjkn9grIul1PJzawHzUC2lgi38OeiQU7ui2isMlyLZPXsnGX1zqmdZQaAvicf0Q4LFoj4foNyC+UINfW6nnBPsu3Ug+lGEqDLT8xMbKtXIvVTagZPe00q1Xvy7o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjILp54G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjILp54G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C6EC32781;
	Tue, 25 Jun 2024 09:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308847;
	bh=ZftK36LYvJ/n6PyeADegLXJMPcHce24GRgHdwpr5x/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjILp54GX7l/cBQyU676g/yjWFiEvkJiWwurLGeq9t8XZd1O8J0dRpWfez7q1Lstr
	 369nRC3Oax0b6EjvnmBJnfAllGhZ5RaDunEGhODp7+LABQauDzWSgfPMvAttUAxBBB
	 DtvTONq7zvBW/22dTEU5JxWruj/hUTVF8QH209zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/192] ssb: Fix potential NULL pointer dereference in ssb_device_uevent()
Date: Tue, 25 Jun 2024 11:31:22 +0200
Message-ID: <20240625085537.551816719@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Rand Deeb <rand.sec96@gmail.com>

[ Upstream commit 789c17185fb0f39560496c2beab9b57ce1d0cbe7 ]

The ssb_device_uevent() function first attempts to convert the 'dev' pointer
to 'struct ssb_device *'. However, it mistakenly dereferences 'dev' before
performing the NULL check, potentially leading to a NULL pointer
dereference if 'dev' is NULL.

To fix this issue, move the NULL check before dereferencing the 'dev' pointer,
ensuring that the pointer is valid before attempting to use it.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240306123028.164155-1-rand.sec96@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ssb/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index ab080cf26c9ff..0c736d51566dc 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -341,11 +341,13 @@ static int ssb_bus_match(struct device *dev, struct device_driver *drv)
 
 static int ssb_device_uevent(const struct device *dev, struct kobj_uevent_env *env)
 {
-	const struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
+	const struct ssb_device *ssb_dev;
 
 	if (!dev)
 		return -ENODEV;
 
+	ssb_dev = dev_to_ssb_dev(dev);
+
 	return add_uevent_var(env,
 			     "MODALIAS=ssb:v%04Xid%04Xrev%02X",
 			     ssb_dev->id.vendor, ssb_dev->id.coreid,
-- 
2.43.0



