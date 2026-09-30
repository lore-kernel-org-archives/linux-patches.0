Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DC44CA784;
	Wed, 30 Sep 2026 16:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787429; cv=none; b=Uzyeqbtx2SlhJSslcJczxZn59FBvH1Kmp8xM+BxKk15b/MKc3+vINaZSYypIJjMk9y9zO0qVzUs6e5IQgbg2lPeW5mSQaY5flOB/ygAwojiEKXEq/p4kg/h9mwHHItG7EXhhVQJDXJ+IAhQbPTML1UuwYV/kqcZxh552e4IGiZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787429; c=relaxed/simple;
	bh=NF7lLotyrIW65kPnf+W/ynhdWBd4GKooQi/2ZbImMpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+t52vbwENW+c8Zoa45j6oFU6aR++1Fz4xxIOsKgeRYJRnQhzwPGEQq7kGjTYrNb+jDlhk64u5ReCcbqdAE6SY0oaxPTaLpuzPOvjJMA8Fohg6g7R1sqV9aZFeDhtkYr5jrczUhGKJWxzRx8tN7079dBO1fr0gwQKI1akdGK3v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSKUSIi9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSKUSIi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A828F1F000FF;
	Wed, 30 Sep 2026 16:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787428;
	bh=uaco6Bz5hhEJJHsidgv50DsdZRaYG/7djmH6uLU98aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSKUSIi9XOcB2JyjDTnBQTlVJ85DZxXT5+Om341ce5cY0FPVVCjK4NXxLYodOQy7p
	 FuvZ+w6THJ6vkiM/uIJ4KIp2OqV5TDw74L7SzyrrgOTQng6uJPN4d+6dO/BgTau/qE
	 Ow+Z92B3j+8mgsn5gb7XPU2Oc9wwwLEoPPH6uink=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 227/457] autofs: fix sbi->pipe file reference leak in autofs_kill_sb()
Date: Wed, 30 Sep 2026 17:25:32 +0200
Message-ID: <20260930152350.947070642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

[ Upstream commit aa5e44b29ffe4eaa08cc2237fd65bc2596bc023e ]

When autofs_fill_super() fails before clearing AUTOFS_SBI_CATATONIC (for
example, when find_get_pid() fails on an invalid pgrp mount option, or
when an fs_context is closed before mounting), deactivate_locked_super()
invokes autofs_kill_sb() -> autofs_catatonic_mode(sbi).

Because AUTOFS_SBI_CATATONIC is still set in sbi->flags,
autofs_catatonic_mode() returns early without calling fput(sbi->pipe),
permanently leaking the pipe struct file reference.

Explicitly release sbi->pipe in autofs_kill_sb() if it is still non-NULL
after autofs_catatonic_mode().

Fixes: ebc921ca9b92 ("autofs: copy autofs4 to autofs")
Signed-off-by: Hui Peng <benquike@gmail.com>
Link: https://patch.msgid.link/20260919204808.2812930-1-benquike@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/autofs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index 6b15a3717ba7e..066c16f2ea569 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -51,6 +51,10 @@ void autofs_kill_sb(struct super_block *sb)
 	if (sbi) {
 		/* Free wait queues, close pipe */
 		autofs_catatonic_mode(sbi);
+		if (sbi->pipe) {
+			fput(sbi->pipe);
+			sbi->pipe = NULL;
+		}
 		put_pid(sbi->oz_pgrp);
 	}
 
-- 
2.53.0



