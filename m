Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BE7435A9E;
	Thu, 30 Jul 2026 15:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426808; cv=none; b=Xms77K63GQt6n2lQAvILRCmwdcvZygkh3POJTCDbwsZG8Jk7MR1l0DKSIJys0weE8VGN9HHMUaXEs/VOpigVv9X4izfXIky79XDxHmM+cdg/btWk7drqD3z7f14F83ZVkjJB1Ow+z2hR4Y8pmXp/TPBs4i67tTKlqxkUklBiCAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426808; c=relaxed/simple;
	bh=bus3mLQevVJhDa2r/CHciFahcg1UWn3jOQ6spZq7PYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIQCSH6TERmo/ecH0zkXxl3PU6L2SG4bxVL4RLkVddPuLuVmuxjv6CaLpURa9vlG+UA0Q3kXItu50htjHmmP+Uqnk7wnxj8/a7sYmeofe1JQIomLKEfdEXJVy2Jk6RubQ/vfhdk6d6FmYJp/ssNFUbheHfVF3ma6rULp4lsfOG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZL/77Lo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZL/77Lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB831F000E9;
	Thu, 30 Jul 2026 15:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426806;
	bh=ZjiN6x0rflJxX3RUMFRuHpB/uA0AnfgmxjmhSJ1Yrg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZL/77LoTgc8agpioGvije+GCZK94lUtoGJkgtoXhE0bk44PUk1Z4dnUjUQa+J2cA
	 EidcJjahWKUzvza32/xd0Ve0SOAqvK5HurUDyUjjtDdbL99KEQ1xlzjA+7XbU8tHsq
	 fEsbaQ/Sx8GKCqkPMkPW0dU3oVND032xH9GbHlRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 548/602] cleanup: fix scoped_class()
Date: Thu, 30 Jul 2026 16:15:40 +0200
Message-ID: <20260730141447.544994367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
Stable-dep-of: 981ccd97f715 ("dm: avoid leaking the caller's thread keyring via the table device file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cleanup.h |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -277,15 +277,16 @@ static inline class_##_name##_t class_##
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


