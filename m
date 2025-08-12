Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFD61A9F89;
	Tue, 12 Aug 2025 18:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021688; cv=none; b=OoECa0bJzYisuTwfBZjnIGS8QKWnOeY4r57C3rDURM6Z5cI3Dukdt22akv5ktINjlWHkq0Efzm2/bRjxwu3NwOg79DHSTMZJszOppHkvLaUDSkyu4+nKKC8Cz+qOqdw6HO5qUxWE1JoJsF1Jz6eeruQChEHG63hziY58QDjLYgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021688; c=relaxed/simple;
	bh=UoiMupQ2hCXIIRdsIRo1cuIQRLhBMuq4ejDzNdtNZrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5uvG1fG5pCp+SJ8XV6B1NMERPK4iBIL3AWdiv1JSDymu1KtMbPL8XP+TEI3MR63fXnQ90VeXUXv1kZNJzgMaqEgszy1fbde+C7KIWCrmSgKQ0aFGI1pdcxusPaAumrNq1HdCF1iut3+hXXnw6ajBK1SQwvOVbV1qYmA9H7b9Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg0g8rrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg0g8rrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E15CC4CEF0;
	Tue, 12 Aug 2025 18:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021687;
	bh=UoiMupQ2hCXIIRdsIRo1cuIQRLhBMuq4ejDzNdtNZrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xg0g8rrvuk+QIXLG9o2tCEPb/9XSDdir8O4OYp1rlXtWbtAwLAmC8CU9bPFjPLj9E
	 ZVeDi9P7AaG/EEcr+wiITSMSVfmQb1cJP5o25xSAq08KEio2MOHT102oa3d3YeXPD5
	 UZPEJfj/Wjy9r4KK7SFewLwjI05zLcqEOfKuVRok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/262] apparmor: ensure WB_HISTORY_SIZE value is a power of 2
Date: Tue, 12 Aug 2025 19:29:10 +0200
Message-ID: <20250812172959.996095924@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 58fbf67139b9..5b6f16242e60 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -141,7 +141,8 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 
 void aa_dfa_free_kref(struct kref *kref);
 
-#define WB_HISTORY_SIZE 24
+/* This needs to be a power of 2 */
+#define WB_HISTORY_SIZE 32
 struct match_workbuf {
 	unsigned int count;
 	unsigned int pos;
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index b97ef5e1db73..76709b7c6519 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -670,6 +670,7 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 
 #define inc_wb_pos(wb)						\
 do {								\
+	BUILD_BUG_ON_NOT_POWER_OF_2(WB_HISTORY_SIZE);			\
 	wb->pos = (wb->pos + 1) & (WB_HISTORY_SIZE - 1);		\
 	wb->len = (wb->len + 1) & (WB_HISTORY_SIZE - 1);		\
 } while (0)
-- 
2.39.5



