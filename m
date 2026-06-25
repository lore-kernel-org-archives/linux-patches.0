Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D571E633C;
	Thu, 25 Jun 2026 13:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392777; cv=none; b=AHfKZiDuXlKhJGOzk6lDafrkHL5iHLbrjSYXtpDfzVkoJTSK8UFqc3bVn2us81v+Hwa/IwodGt+I3ljVqYc6CPy2V8SJoruaj7OquJBEWKbofyjnM9nMp+V/uNbxtQT+aAoiHFrdLWEk/sGD+ZRGWAlNCLA2LpgSR2gMO6kscKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392777; c=relaxed/simple;
	bh=Hnru30w97suqwP2W0iXA/7eKcTD5fzrF9Ep5QKneXrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcG0/xUZJXRgzF8slFyptDqzOASd/Byp2zt1WhHirWlm3A8Cg/S4c9nEToj6klkaUnwX7/P6CQTPHwiFEGejiPcJ/IiEHAVxdBDXXXzDpVlP+TUT/3lBWPDZOlF7c6GScM8R5f+M1DjmN+PisR53+khR81AE9nog6jA7nmIl70U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XU6gST+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XU6gST+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6D31F000E9;
	Thu, 25 Jun 2026 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392776;
	bh=ugnyu56h6xQd8HMz7vV9GBZmUqFr5vYYUolJb6g6YIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XU6gST+7I5RbcyEdEsXcvquqYwjh9dxrAF6JWxszVQcYJW7u/KZDIxkxkjiIOFJi/
	 3j8SW/Xgm94seCq5Exz1Nl0IGzqzcZD1jc60hqBJnNxw6R+H8YITB+jNQkkgFU13mZ
	 J4uvusCbaQBBVW4RDwhjNz4uKht/N3ixdsrujqgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 06/60] debugobjects: Use LD_WAIT_CONFIG instead of LD_WAIT_SLEEP
Date: Thu, 25 Jun 2026 14:02:51 +0100
Message-ID: <20260625125646.501010628@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 37de2dbc318ee10577c1c2704de5a803e75e55a2 upstream.

fill_pool_map is used to suppress nesting violations caused by acquiring
a spinlock_t (from within the memory allocator) while holding a
raw_spinlock_t. The used annotation is wrong.

LD_WAIT_SLEEP is for always sleeping lock types such as mutex_t.
LD_WAIT_CONFIG is for lock type which are sleeping while spinning on
PREEMPT_RT such as spinlock_t.

Use LD_WAIT_CONFIG as override.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251127153652.291697-3-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/debugobjects.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 9d59b797d1b507..4343dc5e5c99da 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -734,10 +734,10 @@ static void debug_objects_fill_pool(void)
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible() || system_state < SYSTEM_SCHEDULING) {
 		/*
 		 * Annotate away the spinlock_t inside raw_spinlock_t warning
-		 * by temporarily raising the wait-type to WAIT_SLEEP, matching
+		 * by temporarily raising the wait-type to LD_WAIT_CONFIG, matching
 		 * the preemptible() condition above.
 		 */
-		static DEFINE_WAIT_OVERRIDE_MAP(fill_pool_map, LD_WAIT_SLEEP);
+		static DEFINE_WAIT_OVERRIDE_MAP(fill_pool_map, LD_WAIT_CONFIG);
 		lock_map_acquire_try(&fill_pool_map);
 		fill_pool();
 		lock_map_release(&fill_pool_map);
-- 
2.53.0



