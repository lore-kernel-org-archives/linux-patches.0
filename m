Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970FD1E519;
	Mon, 10 Mar 2025 17:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626790; cv=none; b=CAEcpTI5ptkPXehsHUuAH2bT2OYfmN9KGl3D0WuU4lq/+aQK0c4wA3S70+lWD99xGf7Og9oF/XWGipa0KzJEcZYcCb6AH6Yp2oH2lVJ4zeqA7LXDMWpIdVZJJiKENhbODg3H8YToXezRFZtQgHE1EYb+lNa6ILjRdpCC8oNAWKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626790; c=relaxed/simple;
	bh=4f5wFFho1E2qJ8ant/MBtn6geMsCT5rz2ocUj6WlCaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0IcBkDKoVBULBM8wmttfcS3bc/cLRym/TGjvooNkTdq6xb3iw366rr23oITYmiXWhzQEKwv1YKuZOaWf91wqqbg7J2YkLi/3Gy1Vkcg2a1dDq38uI3MyNVQ43FHC1wKc6A9LDwqrCVW0ZvfUW70vLxGOBH9mqcWskPwJ8R4Dd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9/a31ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9/a31ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23421C4CEE5;
	Mon, 10 Mar 2025 17:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626790;
	bh=4f5wFFho1E2qJ8ant/MBtn6geMsCT5rz2ocUj6WlCaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9/a31caDG4Oyv5cgKHq6OLN45dj7awHinFE4pN9P3BiQT6X64sQaCbrx7xTWcgHF
	 RBMvylgwUI/hJrZf7wGqWHYn/NCinzu0nMDOBXBwj5Jg3AnqUCWRjFafQJTI9bAuHQ
	 j5RhsdMXsLuSkx7xPisBIxgjLusBZ1btPr71CI4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 114/207] cred: return old creds from revert_creds_light()
Date: Mon, 10 Mar 2025 18:05:07 +0100
Message-ID: <20250310170452.345358583@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 95c54bc81791c210b131f2b1013942487e74896f ]

So we can easily convert revert_creds() callers over to drop the
reference count explicitly.

Link: https://lore.kernel.org/r/20241125-work-cred-v2-2-68b9d38bb5b2@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: e04918dc5946 ("cred: Fix RCU warnings in override/revert_creds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cred.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index e4a3155fe409d..382768a9707b5 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -185,9 +185,12 @@ static inline const struct cred *override_creds_light(const struct cred *overrid
 	return old;
 }
 
-static inline void revert_creds_light(const struct cred *revert_cred)
+static inline const struct cred *revert_creds_light(const struct cred *revert_cred)
 {
+	const struct cred *override_cred = current->cred;
+
 	rcu_assign_pointer(current->cred, revert_cred);
+	return override_cred;
 }
 
 /**
-- 
2.39.5



