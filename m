Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C04F3090D5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300907; cv=none; b=n9YpPoJ+zncO5ZGPCTR4rhxdTalJdwhPqy+daVFDGdMpQc2dcUITN/W5BKZrtDhO4F7PGPbCfh8sf22D4mJIIY7AxCsQsm6Ljr7fUnIapuB7V05DbpCZttfLyUeAhi1KWVrMsvVzuSZ5o4HgjJX/IF84aacQbOIGYVQx80qc9W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300907; c=relaxed/simple;
	bh=D5N9c4KjXXhj07dBWuc9h4/fSwtFdozgTaLnNQb5bUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCtEAffkuaB1KjtxoROgd29muP4CfifvdBYBZZS/ECEYmj3V9jN0dOVD4hh+lDo5K0wQayJZfbcOB+Qfp7wrlAFYLAbhJKLxOCVKuFzTGbkYUvYffgHPuDco5vqOMpdCa7sZ3VOs9D/ZxVkK0fmgt1UgD/zB7SJWdh0BtObWVdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwCzGn2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwCzGn2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0683C19425;
	Sat, 28 Feb 2026 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300907;
	bh=D5N9c4KjXXhj07dBWuc9h4/fSwtFdozgTaLnNQb5bUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwCzGn2mUA6lYhul+UXMg9Ovb98VEFmxkYuFJFW+o25qh2yUtxAHsgd0NYCkjzRJ0
	 8bs96NkEgKpqoxe5f+TTRsw273QVsuG77Os/7d5rSdRdNScfMfswE1QjMv8cnKJelm
	 g28htXN4QTeDFIusy6A9Yk3TuoG+6PQoNAXIS/J7IWEF6VYoWJxhmT3W5BPF1z9xB7
	 dFWoJrlJ+Bj0maABxR7kErsfcFbrN4CZpLEbhAj2ynSfj2Rnb9tQAvuGnUWnvP7XEN
	 kiFb0r8cY6J+Q2qEyZgPTI1tHsWKZodH/MalsyzptVTbi3x+Dg6vQ/AUsmPfAR8JWQ
	 S19Ygvi+rwuTg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>,
	Esben Haabendal <esben@geanix.com>,
	Nick Bowler <nbowler@draconx.ca>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/752] rtc: interface: Alarm race handling should not discard preceding error
Date: Sat, 28 Feb 2026 12:35:32 -0500
Message-ID: <20260228174750.1542406-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>

[ Upstream commit 81be22cd4ace020045cc6d31255c6f7c071eb7c0 ]

Commit 795cda8338ea ("rtc: interface: Fix long-standing race when setting
alarm") should not discard any errors from the preceding validations.

Prior to that commit, if the alarm feature was disabled, or the
set_alarm failed, a meaningful error code would be returned to the
caller for further action.

After, more often than not, the __rtc_read_time will cause a success
return code instead, misleading the caller.

An example of this is when timer_enqueue is called for a rtc-abx080x
device. Since that driver does not clear the alarm feature bit, but
instead relies on the set_alarm operation to return invalid, the discard
of the return code causes very different behaviour; i.e.
    hwclock: select() to /dev/rtc0 to wait for clock tick timed out

Fixes: 795cda8338ea ("rtc: interface: Fix long-standing race when setting alarm")
Signed-off-by: Anthony Pighin (Nokia) <anthony.pighin@nokia.com>
Reviewed-by: Esben Haabendal <esben@geanix.com>
Tested-by: Nick Bowler <nbowler@draconx.ca>
Link: https://patch.msgid.link/BN0PR08MB6951415A751F236375A2945683D1A@BN0PR08MB6951.namprd08.prod.outlook.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index b8b298efd9a9c..1906f4884a834 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -457,7 +457,7 @@ static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	 * are in, we can return -ETIME to signal that the timer has already
 	 * expired, which is true in both cases.
 	 */
-	if ((scheduled - now) <= 1) {
+	if (!err && (scheduled - now) <= 1) {
 		err = __rtc_read_time(rtc, &tm);
 		if (err)
 			return err;
-- 
2.51.0

