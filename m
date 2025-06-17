Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47852E9753;
	Tue, 17 Jun 2025 15:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174833; cv=none; b=N0sdgycOt6+cO73sgclXQ0eOapQtnd9NSnbiBH92vIvRlpiu19BeedOdoR8qwz7gHXYADu8Cq3TXtUeeQmUanO+YX34q8cQFSINPkY6cG3SIoQTCxwcocrijrSYwMo47TO5R/djS6XsnEdSmV9CQu3Sw4/YNK2e2aTqid3ja7y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174833; c=relaxed/simple;
	bh=ivixVKyU5Pu9o7zJHPcAEo9PbpDOiiHUM9l4W9uw8/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFx4tZ9E/nIMNfBj3YnMXAqcxqtoeElY4bfIDZeYHrSXCtkVHaZy12z8F73/0x0Fy/1+DiIyOFkIXeg+rw7S9dqy38+mNlgWmWUrbbmQsEtgT0l5dvGK9Nx20jvMreeMhSRS74ACTEP6nrMb41oZ/bTqlW0LBkLrVennuXQWGp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1AGOB8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1AGOB8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1421DC4CEE7;
	Tue, 17 Jun 2025 15:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174833;
	bh=ivixVKyU5Pu9o7zJHPcAEo9PbpDOiiHUM9l4W9uw8/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1AGOB8FErS2VWMWgICZFRHQ+FXuJh/WMBbvFbrVmyN7JzPa/LJ+/UXp9gVR2kBMt
	 nE08ys8bq+rNd64/dtU1NmqNT3e8wCJPQQIJZLyZ1hXsMCd+ohctCusKt3Bln/fMoL
	 oWCYZB9dPrbLY6gM3uF4vHPauVi9HZEHztXDYCGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 025/780] selftests: coredump: Properly initialize pointer
Date: Tue, 17 Jun 2025 17:15:33 +0200
Message-ID: <20250617152452.533004861@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit e194d2067c958827810a7a7282dff8773633ad8c ]

The buffer pointer "line" is not initialized. This pointer is passed to
getline().

It can still work if the stack is zero-initialized, because getline() can
work with a NULL pointer as buffer.

But this is obviously broken. This bug shows up while running the test on a
riscv64 machine.

Fix it by properly initializing the pointer.

Fixes: 15858da53542 ("selftests: coredump: Add stackdump test")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/4fb9b6fb3e0040481bacc258c44b4aab5c4df35d.1744383419.git.namcao@linutronix.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/coredump/stackdump_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/coredump/stackdump_test.c b/tools/testing/selftests/coredump/stackdump_test.c
index 137b2364a0820..c23cf95c3f6df 100644
--- a/tools/testing/selftests/coredump/stackdump_test.c
+++ b/tools/testing/selftests/coredump/stackdump_test.c
@@ -138,10 +138,12 @@ TEST_F(coredump, stackdump)
 	ASSERT_NE(file, NULL);
 
 	/* Step 4: Make sure all stack pointer values are non-zero */
+	line = NULL;
 	for (i = 0; -1 != getline(&line, &line_length, file); ++i) {
 		stack = strtoull(line, NULL, 10);
 		ASSERT_NE(stack, 0);
 	}
+	free(line);
 
 	ASSERT_EQ(i, 1 + NUM_THREAD_SPAWN);
 
-- 
2.39.5



