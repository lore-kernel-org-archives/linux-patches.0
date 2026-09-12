Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3AE3F1ADE;
	Sat, 12 Sep 2026 07:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197605; cv=none; b=WdTXwsv7Ef2g5v6VMJOBKLdM2yeFmiZTRCQ8LjxbY1DSrHUAb7nQfFdBUL7s9xhST9YLflPaYq+Blz5rBXGQkGZa52+5ncZJP10E+Ny8Qc+VOj52QBLQE1skC3WdHTqx3fKJwQ90FZfDNgew6Rw6/mtedN079DKHEDV+81FVN3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197605; c=relaxed/simple;
	bh=cnVHhww3E2MtOOlAXWlTzW46jptNwJ+8DAmaZJFaGLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MH5Ii3Yguu1mlrojwMP00HMXxzc4M8u0QF2F0rtzcsD4a3GEYdKpkv4Ijb9YF1dIaHepnWGk+auCWe12P4xuODmeXozgdJsIdJQR4Q8UcXeGP7vsVFgqnVpcEwqKZhjcRgK2n7TMWZPW3Vpc5b3q2EC8r6we1XpsUQhcJAUYzW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6+Kse3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6+Kse3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E541F000FF;
	Sat, 12 Sep 2026 07:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197604;
	bh=zjhDYwalVThO0vaG49D5dkiw66kpGa4E2y1AfdxeI4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6+Kse3AAMGwn4Fc+fsTpqQOeu+bQpn6rFkHSCNDK+uwI8NWQQJU+rgzoPjDFHclR
	 PUYSDCLQzhSW47DemzRK6651p1jaMCTa7kmFveI7sDkTyVlklgwE0p2JKbJJK3gVT/
	 bydz+9I3cP2c0xEEVBLzPmYv+X9OFiWWT8wTlmZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haowen Tu <tuhaowen@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0209/1815] PM: sleep: Fix off-by-one in wakelocks number limit check
Date: Sat, 12 Sep 2026 08:32:39 +0200
Message-ID: <20260912065653.903303308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Haowen Tu <tuhaowen@uniontech.com>

[ Upstream commit 6058646587dded0ce0ba91bd5a6afbf14fe42055 ]

CONFIG_PM_WAKELOCKS_LIMIT is documented as the maximum number of
user-space wakeup sources, but the limit check is performed before
the counter is incremented and only rejects new wakeup sources when the
current number is greater than the limit. This allows one extra wakeup
source to be created.

Reject new wakeup sources once the counter has reached the limit.

Fixes: b86ff9820fd5 ("PM / Sleep: Add user space interface for manipulating wakeup sources, v3")
Signed-off-by: Haowen Tu <tuhaowen@uniontech.com>
[ rjw: Subject edits ]
Link: https://patch.msgid.link/20260624053839.2150567-1-tuhaowen@uniontech.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/wakelock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/wakelock.c b/kernel/power/wakelock.c
index fd763da06a873..a8b6bd5ec46b4 100644
--- a/kernel/power/wakelock.c
+++ b/kernel/power/wakelock.c
@@ -63,7 +63,7 @@ static unsigned int number_of_wakelocks;
 
 static inline bool wakelocks_limit_exceeded(void)
 {
-	return number_of_wakelocks > CONFIG_PM_WAKELOCKS_LIMIT;
+	return number_of_wakelocks >= CONFIG_PM_WAKELOCKS_LIMIT;
 }
 
 static inline void increment_wakelocks_number(void)
-- 
2.53.0



