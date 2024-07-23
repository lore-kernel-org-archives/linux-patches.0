Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844F113C3F5;
	Tue, 23 Jul 2024 18:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759878; cv=none; b=u8MKZbhcfVOjx1oEpWLB24yKgBX1yOt2i2iLrAYpttrajMEeOINnSYOLdATobPAspxx7pQnW1MXFEroZoeesV+Sx7ZIRAcMMoDY0JHBhalfOY8eblwMwcHlu5vsTd+PW5cgaNnVyWUlMlXRAl2ybvHscj+Cqwk1VnZximq5/EpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759878; c=relaxed/simple;
	bh=BvqoXcM2NMOeBZdTsz5jCGUlhX78bACRrVJXko4sFBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCXNTzsl8ud6ygGXQ7agBD1D0DYPIq+dAvaYgsJ+gcyyADgCtTt+7TZc3Bn5qBvfM55FosukCBstVKE8q3HWRezH44wxTharM71zaLibCRBJarJ5BX8sL1yyyOs5AntZkFU7kFIfOcN/V8+mN5kGc+SMnV6IIojK2g4wa4VeK/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aB7NFa/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aB7NFa/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09053C4AF0A;
	Tue, 23 Jul 2024 18:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759878;
	bh=BvqoXcM2NMOeBZdTsz5jCGUlhX78bACRrVJXko4sFBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aB7NFa/nrWxTdt4uzDhLNwG9VKPXT/HWLyIwc9gEWcc90BL85FQhFp61Ur1CwX9NH
	 eytwaFPHMqnGS9fP9PsSa7MzOXTxG3xz/DyHSzfmaeG0ekRcnxsyqLZ2TVKMKS23yw
	 HPJkxZIFio8/AUIhgSxcN8XCJpJKWSc92ZfRLFEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	John Hubbard <jhubbard@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 028/163] selftests/futex: pass _GNU_SOURCE without a value to the compiler
Date: Tue, 23 Jul 2024 20:22:37 +0200
Message-ID: <20240723180144.560077169@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit cb708ab9f584f159798b60853edcf0c8b67ce295 ]

It's slightly better to set _GNU_SOURCE in the source code, but if one
must do it via the compiler invocation, then the best way to do so is
this:

    $(CC) -D_GNU_SOURCE=

...because otherwise, if this form is used:

    $(CC) -D_GNU_SOURCE

...then that leads the compiler to set a value, as if you had passed in:

    $(CC) -D_GNU_SOURCE=1

That, in turn, leads to warnings under both gcc and clang, like this:

    futex_requeue_pi.c:20: warning: "_GNU_SOURCE" redefined

Fix this by using the "-D_GNU_SOURCE=" form.

Reviewed-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/futex/functional/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index a392d0917b4e5..994fa3468f170 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 INCLUDES := -I../include -I../../ $(KHDR_INCLUDES)
-CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES) $(KHDR_INCLUDES)
+CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE= -pthread $(INCLUDES) $(KHDR_INCLUDES)
 LDLIBS := -lpthread -lrt
 
 LOCAL_HDRS := \
-- 
2.43.0



