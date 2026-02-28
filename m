Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C2F301F0D;
	Sat, 28 Feb 2026 17:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301427; cv=none; b=N1GPTwhcicNxFQiOcRw9ySnyCknYNC+hX7p3QwrVEImeE+MlzrdsbsUU2GqcsF6ldlbq+cXzZkE45gcTN1a2JkuITqa3oir5oKpbZBbfnr4Ha1i46oiiy1okG9WFP5ykCdN4UJ24aJ3XsLAM4X5MXd5riN32xm4fdlLZEbRnX9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301427; c=relaxed/simple;
	bh=bCX3xrgJz/OqLbwF3/TCMmwl4wvf4/kKWWEmbbdhnSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUbdHiJ1RIU+J2tDTzBp2fSLp1MCLbqm1GEWWghDGlmrr/XFRVj8KvMjDhrDZNafhNc12gKlkz23n6Xa4PD+zElgB4HbA56xjPVAdqX+DU0U+z6gJohTcxAs2H0bOvCD4ZfRN1KJsK+YesxAFX5NlRaQJIWzAJ8NItvQsVGI7V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBm8JW4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBm8JW4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E677C116D0;
	Sat, 28 Feb 2026 17:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301427;
	bh=bCX3xrgJz/OqLbwF3/TCMmwl4wvf4/kKWWEmbbdhnSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBm8JW4F1Yf/nnTB/rON447KeVvEcqpkiFM13FGcmlmZ+337QnQScQi5ZXFAw0D7Q
	 P4DXT8mI2e/8VBF3X4IbQU1lxjqyQoLitTnIIIwK6FCAnITWjS/4Y4YBsSOG+blPY2
	 Y605U5CoPHZVzHlrWOt6fyD+W12VYskEcyng3bBIWrH1DLZQ99ZwqsR7f0nDQU5xF5
	 aE887Q3YD7z3EKfjor/UDCeIt9euIMHDgDEUmXyh8wAFWyelrNPiFaEWCARmiqYlpG
	 Lg4oT0n714bjrb/WfHXrFHe6nxGVpYu5WTTp7lmYy8ZQMKrLE4XiS3pUUTcPi3vJ1U
	 BBMowThU9bgKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	r772577952@gmail.com,
	stable@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 617/752] xfs: check return value of xchk_scrub_create_subord
Date: Sat, 28 Feb 2026 12:45:28 -0500
Message-ID: <20260228174750.1542406-617-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit ca27313fb3f23e4ac18532ede4ec1c7cc5814c4a ]

Fix this function to return NULL instead of a mangled ENOMEM, then fix
the callers to actually check for a null pointer and return ENOMEM.
Most of the corrections here are for code merged between 6.2 and 6.10.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: 1a5f6e08d4e379 ("xfs: create subordinate scrub contexts for xchk_metadata_inode_subtype")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jiaming Zhang <r772577952@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/common.c | 3 +++
 fs/xfs/scrub/repair.c | 3 +++
 fs/xfs/scrub/scrub.c  | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index e6145c2eda02a..975c879c8d7f5 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1399,6 +1399,9 @@ xchk_metadata_inode_subtype(
 	int			error;
 
 	sub = xchk_scrub_create_subord(sc, scrub_type);
+	if (!sub)
+		return -ENOMEM;
+
 	error = sub->sc.ops->scrub(&sub->sc);
 	xchk_scrub_free_subord(sub);
 	return error;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index efd5a7ccdf624..4d45d39e67f11 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1136,6 +1136,9 @@ xrep_metadata_inode_subtype(
 	 * setup/teardown routines.
 	 */
 	sub = xchk_scrub_create_subord(sc, scrub_type);
+	if (!sub)
+		return -ENOMEM;
+
 	error = sub->sc.ops->scrub(&sub->sc);
 	if (error)
 		goto out;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 3c3b0d25006ff..c312f0a672e65 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -634,7 +634,7 @@ xchk_scrub_create_subord(
 
 	sub = kzalloc(sizeof(*sub), XCHK_GFP_FLAGS);
 	if (!sub)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	sub->old_smtype = sc->sm->sm_type;
 	sub->old_smflags = sc->sm->sm_flags;
-- 
2.51.0

