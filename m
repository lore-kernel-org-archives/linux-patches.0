Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396B73F9D2;
	Tue, 12 Aug 2025 18:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022719; cv=none; b=bwtEPI1BH2dyyaayQycdqupBsCZk2PA3lnhtK1BpHSYWIe80kzKCpo6BlEyzHKjZXbHYEyh3bJ7OYW1/7oXaYV0XbW6YVzHl5ER08uRre2+n6Z0bml6DCqhQv0ZWJY8TybSArss/FrCFLEjxdQRFdEJ9EhtVoPdEOEiQYlN1hEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022719; c=relaxed/simple;
	bh=iqHz6h6kX5s+ly2rpe+mKIwgXkHaRepmrhwjiHxxDig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enJSqnBIecyPI419dHdrYxK6qOXCxrlwhoOxFFJmDEqxg6PpVc5sSA98+6Vu26zYm2Kmrd0VLlfoil0OA5C/9vwIDS/oue3b1ybPKGgsiDceHaly1huSufGMI5K05cQw+++3XA5kp8bTaNdhCzFEz3doqcf6DPB+bN0SCRb3inY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXJmxLxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXJmxLxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD395C4CEF1;
	Tue, 12 Aug 2025 18:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022719;
	bh=iqHz6h6kX5s+ly2rpe+mKIwgXkHaRepmrhwjiHxxDig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXJmxLxNVHY1qT36lUxZa6aYrekuev+y5Hsxs1SaUqEJ1Xc5OO/tW8oQ3Y2SQRxaj
	 PQhXqIijCd22tsWa2KqLvqn4AWNRebQj+GHuOOKyrWDUyQQ/lvxNS5vRSAUwyzMqCs
	 nEL0ErmY9UO45V/6Jq+nOG4YnuUQK3trsOe8OrtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/369] apparmor: ensure WB_HISTORY_SIZE value is a power of 2
Date: Tue, 12 Aug 2025 19:28:55 +0200
Message-ID: <20250812173023.731228022@linuxfoundation.org>
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
index 4bb0405c9190..0539abda328d 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -135,7 +135,8 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 
 void aa_dfa_free_kref(struct kref *kref);
 
-#define WB_HISTORY_SIZE 24
+/* This needs to be a power of 2 */
+#define WB_HISTORY_SIZE 32
 struct match_workbuf {
 	unsigned int count;
 	unsigned int pos;
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 517d77d3c34c..0f791a58d933 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -626,6 +626,7 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 
 #define inc_wb_pos(wb)						\
 do {								\
+	BUILD_BUG_ON_NOT_POWER_OF_2(WB_HISTORY_SIZE);			\
 	wb->pos = (wb->pos + 1) & (WB_HISTORY_SIZE - 1);		\
 	wb->len = (wb->len + 1) & (WB_HISTORY_SIZE - 1);		\
 } while (0)
-- 
2.39.5



