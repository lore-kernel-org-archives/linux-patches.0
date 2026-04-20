Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09523D3326;
	Mon, 20 Apr 2026 13:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691413; cv=none; b=F+c/ZbKTDD/0D1kYz+N8gIHcus8hkRVuA9FRBU6KJuOmZJAWizlQf7kAvNopbgTUSK8D+am+OXSD3WZYWKJfD6c0Uj2JapUhxwkho2KIRD+M4v92RyBeNcFTS1zoLxVJk1gxMrZPnsRH0OLNfmDQF66G2G2MlPzyZ0Z+QAfAXXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691413; c=relaxed/simple;
	bh=QCvy9OvKnWbejpp6mFQcwprpj2Lu56vqf8tTWQD8YfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPf4c4VR6lNWH2L6VTzIEDCB3iqrditx3VsttpwwoaP414lvnaBblj8Ev3hkPsPQV5ptvIKx7ladXf9VMuQ7D2WA6adKiOsAod7of2XPtrKrnD7QWpWUiADtJA8/6ljGYstK7KOV2OzAyc8KsnFzl9dtoKeGFk0JJcolySfUEkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPQ242Bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPQ242Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6DCC2BCB7;
	Mon, 20 Apr 2026 13:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691412;
	bh=QCvy9OvKnWbejpp6mFQcwprpj2Lu56vqf8tTWQD8YfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPQ242BbupvLgAIgzJcV1OMu8JS0rGJGR3RmvqrHlXcTbukLB8EiJ2vmXeNHqAsBn
	 T1CptwM3Mpnmnn3nUm2u7kkMbf1D5Tbuj7/vegveq4dMG8uofNw51apFH8hdd4gL64
	 7KWpAXEGmjsRxlaEWv3v9IzIyGRP9Vcl75hhjnaoJbkgjcIvv5q6Jig2LHupIixzSi
	 KhRXeTfkuCF6a0XHvGaf72caKLG+Hi0aTzGmi0sQNU/222oS3PPzNMqCqW7OAtgB1h
	 SAD5Uk0oDADqt0bVa4k2RnrLVNZNtNsvX2ZFiGGU0Rb31ZGf6dah/PcvHxHbsO39uk
	 FjBvROI2SUenA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maximilian Pezzullo <maximilianpezzullo@gmail.com>,
	Casey Croy <ccroy@bugzilla.kernel.org>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	basavaraj.natikar@amd.com,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] HID: amd_sfh: don't log error when device discovery fails with -EOPNOTSUPP
Date: Mon, 20 Apr 2026 09:16:45 -0400
Message-ID: <20260420132314.1023554-11-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Maximilian Pezzullo <maximilianpezzullo@gmail.com>

[ Upstream commit 743677a8cb30b09f16a7f167f497c2c927891b5a ]

When sensor discovery fails on systems without AMD SFH sensors, the
code already emits a warning via dev_warn() in amd_sfh_hid_client_init().
The subsequent dev_err() in sfh_init_work() for the same -EOPNOTSUPP
return value is redundant and causes unnecessary alarm.

Suppress the dev_err() for -EOPNOTSUPP to avoid confusing users who
have no AMD SFH sensors.

Fixes: 2105e8e00da4 ("HID: amd_sfh: Improve boot time when SFH is available")
Reported-by: Casey Croy <ccroy@bugzilla.kernel.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221099
Signed-off-by: Maximilian Pezzullo <maximilianpezzullo@gmail.com>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 1d9f955573aa4..4b81cebdc3359 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -413,7 +413,8 @@ static void sfh_init_work(struct work_struct *work)
 	rc = amd_sfh_hid_client_init(mp2);
 	if (rc) {
 		amd_sfh_clear_intr(mp2);
-		dev_err(&pdev->dev, "amd_sfh_hid_client_init failed err %d\n", rc);
+		if (rc != -EOPNOTSUPP)
+			dev_err(&pdev->dev, "amd_sfh_hid_client_init failed err %d\n", rc);
 		return;
 	}
 
-- 
2.53.0

