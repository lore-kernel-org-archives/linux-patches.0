Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D619818A922;
	Mon, 28 Oct 2024 06:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098002; cv=none; b=CRVH+mQdZI2oil4WtC7WBk7FbMTcbbPN58zX6ZnXVCsdybVEIu2jmvLEAmx0EF7IwPSw4Nq64Uuu4UTj1CJT7m6nf+nbR2yWn4yu6/mBXWDkz8V106Kr4wsCb8Luc+eH1aQDk13FLtr951WJqI5/ecpqlXIhyGu6poPfxA8VeME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098002; c=relaxed/simple;
	bh=7oNexWLR4dhJVSk7tRDMf8hDtECDQ6UuHZcBMgBlp+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmAn23AsH2HJqxtSLvjs+kCZLiMjJJ8pzZ8VYkKGlz8vFRDX3DI/OGE+Bpbii6y+lgOYczRbvJd8cOQTkqea/BmwqN/rWJAo//zWwHs1RpmSKncshIXwOAqftt+b3xgJHZZCK+v3VSw+TOyBxSwmdjWQqZcaLJOF6NhUMUK4s9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFp+AU9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFp+AU9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A5FC4CEC3;
	Mon, 28 Oct 2024 06:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098002;
	bh=7oNexWLR4dhJVSk7tRDMf8hDtECDQ6UuHZcBMgBlp+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFp+AU9smUk1eU0Qd9xPoi2xsE39bXYBGlYjbmbOd8ZiTzcle9FTBnY0o/uwAFTJg
	 /ytJeQxkAP5sW/g4PpZRthjoz457f4DK+CLnkgc8Ef0mEhjJ2Mo6B7pGheXaMhFw4B
	 sWzcpTfnJsH5/ix7tA0HemQHXsN21ZwfZbLwdHvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 035/261] elevator: do not request_module if elevator exists
Date: Mon, 28 Oct 2024 07:22:57 +0100
Message-ID: <20241028062312.891339046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit b4ff6e93bfd0093ce3ffc7322e89fbaa8300488f ]

Whenever an I/O elevator is changed, the system attempts to load a
module for the new elevator. This occurs regardless of whether the
elevator is already loaded or built directly into the kernel. This
behavior introduces unnecessary overhead and potential issues.

This makes the operation slower, and more error-prone. For instance,
making the problem fixed by [1] visible for users that doesn't even rely
on modules being available through modules.

Do not try to load the ioscheduler if it is already visible.

This change brings two main benefits: it improves the performance of
elevator changes, and it reduces the likelihood of errors occurring
during this process.

[1] Commit e3accac1a976 ("block: Fix elv_iosched_local_module handling of "none" scheduler")

Fixes: 734e1a860312 ("block: Prevent deadlocks when switching elevators")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20241011170122.3880087-1-leitao@debian.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/elevator.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/elevator.c b/block/elevator.c
index 4122026b11f1a..8f155512bcd84 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -709,13 +709,21 @@ int elv_iosched_load_module(struct gendisk *disk, const char *buf,
 			    size_t count)
 {
 	char elevator_name[ELV_NAME_MAX];
+	struct elevator_type *found;
+	const char *name;
 
 	if (!elv_support_iosched(disk->queue))
 		return -EOPNOTSUPP;
 
 	strscpy(elevator_name, buf, sizeof(elevator_name));
+	name = strstrip(elevator_name);
 
-	request_module("%s-iosched", strstrip(elevator_name));
+	spin_lock(&elv_list_lock);
+	found = __elevator_find(name);
+	spin_unlock(&elv_list_lock);
+
+	if (!found)
+		request_module("%s-iosched", name);
 
 	return 0;
 }
-- 
2.43.0



