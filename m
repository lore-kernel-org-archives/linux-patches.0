Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB04647988D;
	Sat, 12 Sep 2026 13:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218184; cv=none; b=frwOpoasUxAtskaeei3PSUbx1TWzkT+NTqXQs5Q+m63gDac0NJhGlq8yVdV4GU6h8stfkMS/TyTQKx/mnmGXzR8yuCozNxlIUwH45eWBzfdkmnvNbe7tVHy1WS6IPCnzWjIlwbnerPrqaIOESou0OfbfhEw5af96vuuAFZMoZeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218184; c=relaxed/simple;
	bh=KXquhnBGwvV3dWb8Lk6quP1c8Gs4H9UUflB2ouevFNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtQ4zRh965+YYLIe44qLkwYYs0C5GgMHnrnN+W92eIXNu6shorcVu5XvdKuHiIh/PDsAv+p9x6cZIsKCEmhTcKM9tPlrevqUYclThFHoIw6kXBPhkZ8yxFz1KR8bou1DkA/wJNHWoZ9SGYI1kWsMx5iKxc0gz4rnCBNEnp7va7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuGS1Oag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuGS1Oag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6EB1F000FF;
	Sat, 12 Sep 2026 13:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218183;
	bh=N1Jdnls5/2iEr8cX2ccUfaoQGysgW6Ju9f22AHjxcLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AuGS1OagNEHzAw77utHohzvUAl95r+aXfa7PerORcnvHJ3RNe1exXuRypIXAniV49
	 DeVNJRQS6H/MnreHmxIdoGV9wRtfpIcirCUIua9kGeFLI/IWUoIGU6eWZd1Gh2jEq1
	 OJzkPKRMgsbC2Gv4/gWuvfNa6QGBbcnC9XoCKse4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1092/1376] super: fix dying superblock warning messages
Date: Sat, 12 Sep 2026 08:58:38 +0200
Message-ID: <20260912065631.899338199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 9ac8fd831252e52aa78399eaccc11a72f6c2af1a ]

WARN_ON_ONCE() takes a condition, not a message. The string literals
are always true, so the warnings still trigger but the messages are
never printed.

Use WARN_ONCE(1, ...) instead to print the messages and keep the
once-only behavior.

Found with a Coccinelle script. Clang's -Wstring-conversion also flags
such calls but is not enabled in kernel builds.

Fixes: f0cd988016f6 ("fs: massage locking helpers")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260808123802.73687-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index bccfadb37ff26..2418e10cffa44 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -2065,7 +2065,7 @@ int freeze_super(struct super_block *sb, enum freeze_holder who)
 	int ret;
 
 	if (!super_lock_excl(sb)) {
-		WARN_ON_ONCE("Dying superblock while freezing!");
+		WARN_ONCE(1, "Dying superblock while freezing!");
 		return -EINVAL;
 	}
 	atomic_inc(&sb->s_active);
@@ -2219,7 +2219,7 @@ static int thaw_super_locked(struct super_block *sb, enum freeze_holder who)
 int thaw_super(struct super_block *sb, enum freeze_holder who)
 {
 	if (!super_lock_excl(sb)) {
-		WARN_ON_ONCE("Dying superblock while thawing!");
+		WARN_ONCE(1, "Dying superblock while thawing!");
 		return -EINVAL;
 	}
 	return thaw_super_locked(sb, who);
-- 
2.53.0



