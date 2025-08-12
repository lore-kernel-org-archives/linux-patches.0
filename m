Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4E3279915;
	Tue, 12 Aug 2025 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020893; cv=none; b=Esvn45QIX3nHAy6CoeP9bPbKRlUTIwQLCMI7radrFc9rrmxuBHSWKmkqcfPEa7P78JAE4028Loqf/BiQgyre1j7sMrB3LNi2eNr1y+FjcMR2m9bbT90f3dbCB4/oaMvkaxgz9k3d6FrN4wcxKtEH6pMipSkPd+hXu4DaPDGJaUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020893; c=relaxed/simple;
	bh=86Dc9U1LbpP4oHafup10qy9NzGaV0kWCvLGkThqkiBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdLSGUSmmiOLrnf/ypWSHubqtF4D8wslXr7B//W66Patc4bf9YG6H42ZN8Kpemsmq6lAwF6YsuSL7ff9IdIVyxyIzddLS40590STWPO/J6Q+azsCTsPl03tLtDjpg75llsGaw+KX3L/qbSy9qEpIQHpmI2tVDvmedfzpuCbmySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1pvkLbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1pvkLbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3855CC4CEF0;
	Tue, 12 Aug 2025 17:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020893;
	bh=86Dc9U1LbpP4oHafup10qy9NzGaV0kWCvLGkThqkiBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1pvkLbe2sU7jx4eUk37cqAuJrpfftFoVzwU12d0+EhHdLg5qep9jKxOh7ZFolhoR
	 83nA+JPnR0MQuTKEB04U3amAu9Fv4YsiXgOY/cMK5lUxKcodXobE7W/dNrgTKm0V+y
	 OejpzGaLXU51o31NiErVL3T6bBXnutbRh02FEfUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/253] apparmor: ensure WB_HISTORY_SIZE value is a power of 2
Date: Tue, 12 Aug 2025 19:29:31 +0200
Message-ID: <20250812172956.560449832@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 884489590588..29306ec87fd1 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -141,7 +141,8 @@ unsigned int aa_dfa_matchn_until(struct aa_dfa *dfa, unsigned int start,
 
 void aa_dfa_free_kref(struct kref *kref);
 
-#define WB_HISTORY_SIZE 24
+/* This needs to be a power of 2 */
+#define WB_HISTORY_SIZE 32
 struct match_workbuf {
 	unsigned int count;
 	unsigned int pos;
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 3e9e1eaf990e..0e683ee323e3 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -672,6 +672,7 @@ unsigned int aa_dfa_matchn_until(struct aa_dfa *dfa, unsigned int start,
 
 #define inc_wb_pos(wb)						\
 do {								\
+	BUILD_BUG_ON_NOT_POWER_OF_2(WB_HISTORY_SIZE);			\
 	wb->pos = (wb->pos + 1) & (WB_HISTORY_SIZE - 1);		\
 	wb->len = (wb->len + 1) & (WB_HISTORY_SIZE - 1);		\
 } while (0)
-- 
2.39.5



