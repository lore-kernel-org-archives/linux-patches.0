Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EE32ED17F;
	Tue, 12 Aug 2025 18:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022401; cv=none; b=MYIA84SFrgQyQ/dewEyznCgJvXnJiyfryvKSJ1PK67jIp4nNBJ8no0LY470XLghA6dJpzNqJa++h/QGUGk4f/elBzEidMuK145qNF6hjfGuL8+cCr1eiXe5Dra7I6u2WAV+Iki1yU0rS4Pls2ObFO8jltETjwH86SUPc1x7O91M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022401; c=relaxed/simple;
	bh=Oqz+03HEHkZK2atNDgB/gr2pNd7ssI7FNeBYSaWTfO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWZWNCj9EWz499fRVbqYiu5JIR/uM7ok3X1Vga4nzr4WQCDQilcGITgeWOoH64+FVLhfVyDzb62luGtZfu9i4+CYZEVCbFc/BDUcua9ATS+iK/GUrDvUSg489srHpGlhriJJoXjRKqm0+U3muG5chdSknRxaJYLkQWjZIw6hpEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCWi6S1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCWi6S1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37E0C4CEF1;
	Tue, 12 Aug 2025 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022401;
	bh=Oqz+03HEHkZK2atNDgB/gr2pNd7ssI7FNeBYSaWTfO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCWi6S1CKIQJZYfnktvtqppbtWgZiREqs3ifYkHgzNvvAhZj/eAGWG8WvIL3341rL
	 VuAzkX2C7bqUW/4sVCZg2hRFto4DM8tcoIhY4Sv84scOzzuO5NIPcQ8wDYdL1XId4B
	 2ZCj+m5oIwTXd7Y4PUIeqLaLT/fMIpFDgG7xxtqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/369] um: rtc: Avoid shadowing err in uml_rtc_start()
Date: Tue, 12 Aug 2025 19:26:38 +0200
Message-ID: <20250812173018.576527125@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 4c916e3b224a02019b3cc3983a15f32bfd9a22df ]

Remove the declaration of 'err' inside the 'if (timetravel)' block,
as it would otherwise be unavailable outside that block, potentially
leading to uml_rtc_start() returning an uninitialized value.

Fixes: dde8b58d5127 ("um: add a pseudo RTC")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20250708090403.1067440-5-tiwei.bie@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/rtc_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/rtc_user.c b/arch/um/drivers/rtc_user.c
index 7c3cec4c68cf..006a5a164ea9 100644
--- a/arch/um/drivers/rtc_user.c
+++ b/arch/um/drivers/rtc_user.c
@@ -28,7 +28,7 @@ int uml_rtc_start(bool timetravel)
 	int err;
 
 	if (timetravel) {
-		int err = os_pipe(uml_rtc_irq_fds, 1, 1);
+		err = os_pipe(uml_rtc_irq_fds, 1, 1);
 		if (err)
 			goto fail;
 	} else {
-- 
2.39.5



