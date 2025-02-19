Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423791DE8B8;
	Wed, 19 Feb 2025 08:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953974; cv=none; b=pMcM0RBrCfTqtFR0bzJIhfRtl9/2ka8rtS7YbUQnOezPGREGWgSAY4UQAQCvuK+Porb2hbRWlUPwIOIlg3n4BtOknRlOcn/i+ZdxZ/GboeUslPgrcang3pkUsZtlyvdWs3SzjpThkXrGcidtY42eUC4da8equb+qXiTZE6iK+Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953974; c=relaxed/simple;
	bh=QTMGTK4GOrK+g5ar/KGSO2iehgmloY+Hw+ts9BPhvT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZh+1AYxumoyIGKoJyzqtFB7cMN3oH6LHWDOpFZFORgXSZ6gXmD6RlQ9RoQukRyKrOgaa055e1RpIkIbrH/dNts6351bjw4N+iiZA0orerPn4rf82FIu8sq/GZIbFp2X47JGDk//SRtBOi1HmVC2EoNfnQ6t/OPLDpTNQzqsCNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6+uwPn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6+uwPn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3332C2BCC6;
	Wed, 19 Feb 2025 08:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953973;
	bh=QTMGTK4GOrK+g5ar/KGSO2iehgmloY+Hw+ts9BPhvT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6+uwPn37F6b0fcl1iWLTGLiO9NRZMJyWK5f0oopeyFig+ong6FxyxQF7dGuyUai6
	 lKdGRXx9cVQPBLMFzrC1kIll/Ump+Tz0dXbsTIt5fZPNicc4d/2igPeyBmVEIrzdA1
	 GUYYvO8+kr1xBtlw/iy97UZ3YP78abr0Lh8tFtKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 055/274] um: avoid copying FP state from init_task
Date: Wed, 19 Feb 2025 09:25:09 +0100
Message-ID: <20250219082611.672837164@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 8891b176d350ec5ea9a39c6ef4c99bd63d68e64c ]

The init_task instance of struct task_struct is statically allocated and
does not contain the dynamic area for the userspace FP registers. As
such, limit the copy to the valid area of init_task and fill the rest
with zero.

Note that the FP state is only needed for userspace, and as such it is
entirely reasonable for init_task to not contain it.

Reported-by: Brian Norris <briannorris@chromium.org>
Closes: https://lore.kernel.org/Z1ySXmjZm-xOqk90@google.com
Fixes: 3f17fed21491 ("um: switch to regset API and depend on XSTATE")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20241217202745.1402932-3-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/process.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 30bdc0a87dc85..3a67ba8aa62dc 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -191,7 +191,15 @@ void initial_thread_cb(void (*proc)(void *), void *arg)
 int arch_dup_task_struct(struct task_struct *dst,
 			 struct task_struct *src)
 {
-	memcpy(dst, src, arch_task_struct_size);
+	/* init_task is not dynamically sized (missing FPU state) */
+	if (unlikely(src == &init_task)) {
+		memcpy(dst, src, sizeof(init_task));
+		memset((void *)dst + sizeof(init_task), 0,
+		       arch_task_struct_size - sizeof(init_task));
+	} else {
+		memcpy(dst, src, arch_task_struct_size);
+	}
+
 	return 0;
 }
 
-- 
2.39.5



