Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7B317E00E;
	Thu, 13 Feb 2025 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458686; cv=none; b=VkLUs220nhek+3x4xMNkBH/nnM8gLFx6JYqEXMjR8eK81Pjnw5ye8EgGIJc1+vEmYFqsz6DrzOR0l0f5Th7BmlzB/hHo7GqefjlLU6R51dWxcsxZqRKIcLMB04TmGcI6aGGaWAzQQOPpYcar1cJBQPXgD8fhSL2wU4l+beq0LJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458686; c=relaxed/simple;
	bh=v6j/0mLM+PUL+7MCW7Ckn8W7z3HeTrX4lT6DdthI5s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaT4Aqh6PDwCx1WjYQvBaJkQl7pvN4y79TKQbGH/nXKFc6TL1iuGkOF1j81IzDGSbFSiGkWr4PBH+KUm71Y9WIt57lbrKb7hs2EjgPS2fqSDqpOV1yEKEM6x8Sbtwr/X6pJpYJCkveq4JonirSBsfAlTrANPCrPj9ykPALG859Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byd1PrDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byd1PrDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7836FC4CEE4;
	Thu, 13 Feb 2025 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458685;
	bh=v6j/0mLM+PUL+7MCW7Ckn8W7z3HeTrX4lT6DdthI5s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byd1PrDh8dVQqHg7hRNgXiupU6gaxkVjINYjHLoaZDuJ3rUj1FdH2FVYsMqL6KP8j
	 XQ6akO/crw3zJsPU+wd/KXIAQAPsb+h9MYXzJLnVAm4aHWtZ0L7LyWlVwqr9FyZhH0
	 DHAkswIsGR+aMhvfyvYdFh7qUdDpRS4WNenncY88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4eb7a741b3216020043a@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 049/443] safesetid: check size of policy writes
Date: Thu, 13 Feb 2025 15:23:34 +0100
Message-ID: <20250213142442.514426617@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Leo Stone <leocstone@gmail.com>

[ Upstream commit f09ff307c7299392f1c88f763299e24bc99811c7 ]

syzbot attempts to write a buffer with a large size to a sysfs entry
with writes handled by handle_policy_update(), triggering a warning
in kmalloc.

Check the size specified for write buffers before allocating.

Reported-by: syzbot+4eb7a741b3216020043a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4eb7a741b3216020043a
Signed-off-by: Leo Stone <leocstone@gmail.com>
[PM: subject tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/safesetid/securityfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/safesetid/securityfs.c b/security/safesetid/securityfs.c
index 25310468bcddf..8e1ffd70b18ab 100644
--- a/security/safesetid/securityfs.c
+++ b/security/safesetid/securityfs.c
@@ -143,6 +143,9 @@ static ssize_t handle_policy_update(struct file *file,
 	char *buf, *p, *end;
 	int err;
 
+	if (len >= KMALLOC_MAX_SIZE)
+		return -EINVAL;
+
 	pol = kmalloc(sizeof(struct setid_ruleset), GFP_KERNEL);
 	if (!pol)
 		return -ENOMEM;
-- 
2.39.5



