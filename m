Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA48734FF5A;
	Tue, 16 Dec 2025 11:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885681; cv=none; b=DivCB7BivXG3eQfPifp81uZDsQAjfTqb3Am93bnlw9tYPxorzjEUrqRaMZ0OUQ/4fOeVGm+NS8MYd5/9uoKlo0rwh9ODEjaRQvO42qjwIku5MeUZMJgMxRJyZAW0akdS+YeNEKqPq1N34jwJ/tVPdNUAP8d3YjH7FxH5XBfogJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885681; c=relaxed/simple;
	bh=5TBHEkD/R7GNev4rtH3f5fC86+X9istmc1n5K+Vp64k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+0sT/lGlnzcwYF3UVEU3sMKLx4YB/ucXAPgc8cRpsCd/c/3mId+tKGpoZSrYXAiIgA4BV4MhUmV8/bptWL/zRR4tOxQZJmmnY3FfmW4llokwwt8IeOu/uLwaFEnl9MbVf+83RGuMkJtHrjq2cWwhp+dIJZsse5Xr76M/CpwfrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPmKPJDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPmKPJDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C29C4CEF1;
	Tue, 16 Dec 2025 11:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885681;
	bh=5TBHEkD/R7GNev4rtH3f5fC86+X9istmc1n5K+Vp64k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPmKPJDL7z9Mr641jCV4s3DAIphYPztyFn2ABweE8cZjRNm05cABM9dEnSE7SqQts
	 rUuXN7nVq36X3pNKvCW4bmj9XR6B2XfDEhAPArDoi+phGDHqBlq401C9cUX0fuagEO
	 6FDglLoeY1P71ssa0tn3kDGOU7SY9ftlrujrE82A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 169/507] cleanup: fix scoped_class()
Date: Tue, 16 Dec 2025 12:10:10 +0100
Message-ID: <20251216111351.641416326@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 4e97bae1b412cd6ed8053b3d8a242122952985cc ]

This is a class, not a guard so why on earth is it checking for guard
pointers or conditional lock acquisition? None of it makes any sense at
all.

I'm not sure what happened back then. Maybe I had a brief psychedelic
period that I completely forgot about and spaced out into a zone where
that initial macro implementation made any sense at all.

Link: https://patch.msgid.link/20251103-work-creds-init_cred-v1-1-cb3ec8711a6a@kernel.org
Fixes: 5c21c5f22d07 ("cleanup: add a scoped version of CLASS()")
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cleanup.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 2573585b7f068..19c7e475d3a4d 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -290,15 +290,16 @@ static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
 	class_##_name##_t var __cleanup(class_##_name##_destructor) =	\
 		class_##_name##_constructor
 
-#define scoped_class(_name, var, args)                          \
-	for (CLASS(_name, var)(args);                           \
-	     __guard_ptr(_name)(&var) || !__is_cond_ptr(_name); \
-	     ({ goto _label; }))                                \
-		if (0) {                                        \
-_label:                                                         \
-			break;                                  \
+#define __scoped_class(_name, var, _label, args...)        \
+	for (CLASS(_name, var)(args); ; ({ goto _label; })) \
+		if (0) {                                   \
+_label:                                                    \
+			break;                             \
 		} else
 
+#define scoped_class(_name, var, args...) \
+	__scoped_class(_name, var, __UNIQUE_ID(label), args)
+
 /*
  * DEFINE_GUARD(name, type, lock, unlock):
  *	trivial wrapper around DEFINE_CLASS() above specifically
-- 
2.51.0



