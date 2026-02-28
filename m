Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D388E34403E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301805; cv=none; b=HyLViHNcRsSXrU0OR5O3t3FTZtjbN2P1xocfA/alaLZ9ucDTTX+y2jXPOXUJk7OMZWmlmjKm+xK2Exq99fhZWKdtWR/cUaUkQ9ELPJUJYi7QSLg0/Y66tWAinuyJT9ntxGbsUZaviJIXa5PVAS/k9BhC59YyAPBNAokWmULfIyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301805; c=relaxed/simple;
	bh=/AJc6BecKYywsVSFdLZ765vyIbVxJNErHai8iFQYrjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRVh1wdD/+Z4g8itCwZMGajDsGqM8+DlpAsG1iFahJGFkx+FavfRdUHGVwknqE2T2gnEqrvomvanYIWWVRoAvUjxQdKkiffT3zARaVj0ehHTSmwzUQJOig97PwII3d/baXvNkaH3Ry5qFNbjMd1234v0NChIvD/Pxcun4K2jF5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJ5s3ZYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJ5s3ZYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFC7C19424;
	Sat, 28 Feb 2026 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301805;
	bh=/AJc6BecKYywsVSFdLZ765vyIbVxJNErHai8iFQYrjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ5s3ZYytWVLCVTycLoQwXPAcfFdELoTZVdc+wfK0MuTNlVIK1I+6ws2X59Bp6Ikc
	 LbWRCwh0vXIfHU11/pzLqYmUEOnhPEpEN+OONFuIkmktnIIQuRUUGIou4FDvFfe6mn
	 xjVTfsQV61/rJzRoIkQP1rOB9v/yr3v8f4CFpsPYbBefA9IGblm0S+HdYuT10WHswg
	 xVBeCfoI6xIJzn1hgKYVJjiw8TASLaLmcrTKui4wVCIa+sWu1ZMe9JdHn2cCi1hRVp
	 1jHiwWW0zy1QlZtsI36rHXeqIrHHW6NNqq2avZFTRTBzhc9+PVsgkrMeT2P/8cF3Lo
	 RuUX+3nxQWN0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tuo Li <islituo@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/385] of: unittest: fix possible null-pointer dereferences in of_unittest_property_copy()
Date: Sat, 28 Feb 2026 12:57:20 -0500
Message-ID: <20260228180011.1568201-218-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tuo Li <islituo@gmail.com>

[ Upstream commit d289cb7fcefe41a54d8f9c6d0e0947f5f82b15c6 ]

This function first duplicates p1 and p2 into new, and then checks whether
the duplication succeeds. However, if the duplication fails (e.g.,
kzalloc() returns NULL in __of_prop_dup()), new will be NULL but is still
dereferenced in __of_prop_free(). To ensure that the unit test continues to
run even when duplication fails, add a NULL check before calling
__of_prop_free().

Fixes: 1c5e3d9bf33b ("of: Add a helper to free property struct")
Signed-off-by: Tuo Li <islituo@gmail.com>
Link: https://patch.msgid.link/20260105071438.156186-1-islituo@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 63b5b435bd3ae..ba223736237e8 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -795,11 +795,13 @@ static void __init of_unittest_property_copy(void)
 
 	new = __of_prop_dup(&p1, GFP_KERNEL);
 	unittest(new && propcmp(&p1, new), "empty property didn't copy correctly\n");
-	__of_prop_free(new);
+	if (new)
+		__of_prop_free(new);
 
 	new = __of_prop_dup(&p2, GFP_KERNEL);
 	unittest(new && propcmp(&p2, new), "non-empty property didn't copy correctly\n");
-	__of_prop_free(new);
+	if (new)
+		__of_prop_free(new);
 #endif
 }
 
-- 
2.51.0

