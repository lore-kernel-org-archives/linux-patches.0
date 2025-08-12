Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EFC2D2391;
	Tue, 12 Aug 2025 19:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026532; cv=none; b=QZp4AmgUskat/jpvJLqd3InTdSerZP5ZidER5NwmYDDp11wmuYwAdpxSAEJ6bYzNI07ZKt6ZgD5wk94BUXf39edXJugQOO1RvR6EUXHT5Sy7xC8Hd4pRVflyUkxi+2FylU7x/zW0bTLwqE+Bjse/YgWOMyFLCqgd6fZMtSsOktc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026532; c=relaxed/simple;
	bh=1nqUxJbHWrND28aUHTDVw/+pAZxKwlootfk6kyf23sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxwQVqHFRHCXRvcp9RdDQc6uZISDFTOhxgerWjYFCZjVpulJow9vYHCmyYdnmbV97HNTb5bigj/YAaCCtuvwtnS+ix6/4NUtuidS1uGxOkjfLZ8fWZsSZ+ifsy34VLFRvwCiczAeJK3Xo5Z4p38MZzWpdMWaSf41zvYv1GyCGPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4GZnoaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4GZnoaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88373C4CEF0;
	Tue, 12 Aug 2025 19:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026531;
	bh=1nqUxJbHWrND28aUHTDVw/+pAZxKwlootfk6kyf23sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4GZnoaJuqOY1qhi4WFsqbCIHrpulDLOnZ9MpQvOB9VPAniltQivr9ay65Py+Gob/
	 9u7TEa0Qc3v8JYS+usSSbPEY87cYoEuwEKXOxcArp3L3laC2hkA7xAiYSRf0xiNwyR
	 HCkJ0jx+G9S3k9CXw/8MvqN/pSUPXv6bDy0Vd3UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 332/480] apparmor: ensure WB_HISTORY_SIZE value is a power of 2
Date: Tue, 12 Aug 2025 19:49:00 +0200
Message-ID: <20250812174411.138079375@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Ryan Lee <ryan.lee@canonical.com>

[ Upstream commit 6c055e62560b958354625604293652753d82bcae ]

WB_HISTORY_SIZE was defined to be a value not a power of 2, despite a
comment in the declaration of struct match_workbuf stating it is and a
modular arithmetic usage in the inc_wb_pos macro assuming that it is. Bump
WB_HISTORY_SIZE's value up to 32 and add a BUILD_BUG_ON_NOT_POWER_OF_2
line to ensure that any future changes to the value of WB_HISTORY_SIZE
respect this requirement.

Fixes: 136db994852a ("apparmor: increase left match history buffer size")

Signed-off-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/match.h | 3 ++-
 security/apparmor/match.c         | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
index 536ce3abd598..b45fc39fa837 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -137,7 +137,8 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 
 void aa_dfa_free_kref(struct kref *kref);
 
-#define WB_HISTORY_SIZE 24
+/* This needs to be a power of 2 */
+#define WB_HISTORY_SIZE 32
 struct match_workbuf {
 	unsigned int count;
 	unsigned int pos;
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index f2d9c57f8794..1ceabde550f2 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -681,6 +681,7 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 
 #define inc_wb_pos(wb)						\
 do {								\
+	BUILD_BUG_ON_NOT_POWER_OF_2(WB_HISTORY_SIZE);			\
 	wb->pos = (wb->pos + 1) & (WB_HISTORY_SIZE - 1);		\
 	wb->len = (wb->len + 1) & (WB_HISTORY_SIZE - 1);		\
 } while (0)
-- 
2.39.5



