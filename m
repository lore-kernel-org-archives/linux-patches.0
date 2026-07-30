Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F911383983;
	Thu, 30 Jul 2026 15:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426805; cv=none; b=fOytes8M82bJqeqbEzjAobrFS5Qo1hcoDOLsrOONDD5+Xcy8jcSFoz9gXyWrnPS5ZTtoBc9fa8lRWFOJuToFLTAW2GjPH0smPLntXdi+d+ExbiJ1fYVcc628FkTJK9cBLXGPWxlww7c+bCoqYeyHcaImAVXp+J/EwVS7QepLnGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426805; c=relaxed/simple;
	bh=UAmA29yWEaqB6xq0MlEBQgh1VkWbfrH2RbUy8D3UXdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7evzzj5egfEMXo6u2rJrRCz7aot9d8NDy4LjpIz3TCM64aWhj8z46fGe9R2rpIRAIYp0kREI82vseNgcPpsMycYc3S5NwhMtMuT1R8TqYtKzioOyajJqde14oysNS1L2DD9HauZgxcQO9a+0ZH0kBLsAaDuJh7Z1+qNQM2yI8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtdqjUIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtdqjUIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9DD1F000E9;
	Thu, 30 Jul 2026 15:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426804;
	bh=NF4QJKd2TzGZIRsbmuhXPn2TPVLa1bR9q0lB3JIKnRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OtdqjUInuDJjIT9jj6no45abmifs7VtT0c2YWznXAeSB3gxd38En0dwHze6KIuVmu
	 1lUEk+Xv/P2U9Io1hCK/h0JMxBEQ9riCGtTFeWFnl12C/wGCqrkMlVeP7eejXjVfMS
	 sxCnYcI4/FJsBM2lbJgq0qevkgLXuEm4sDbjmuDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 547/602] cleanup: add a scoped version of CLASS()
Date: Thu, 30 Jul 2026 16:15:39 +0200
Message-ID: <20260730141447.523764723@linuxfoundation.org>
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

[ Upstream commit 5c21c5f22d0701ac6c1cafc0e8de4bf42e5c53e5 ]

This will make it possible to use:

scoped_class() {
}

constructs to limit variables to certain scopes and still perform
auto-cleanup.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 981ccd97f715 ("dm: avoid leaking the caller's thread keyring via the table device file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cleanup.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -277,6 +277,14 @@ static inline class_##_name##_t class_##
 	class_##_name##_t var __cleanup(class_##_name##_destructor) =	\
 		class_##_name##_constructor
 
+#define scoped_class(_name, var, args)                          \
+	for (CLASS(_name, var)(args);                           \
+	     __guard_ptr(_name)(&var) || !__is_cond_ptr(_name); \
+	     ({ goto _label; }))                                \
+		if (0) {                                        \
+_label:                                                         \
+			break;                                  \
+		} else
 
 /*
  * DEFINE_GUARD(name, type, lock, unlock):


