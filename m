Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE9917E90E;
	Mon, 27 May 2024 19:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836850; cv=none; b=OPVhD0rLJy5LfqdeUpVfMuXxVMj0JGq02mmgDaC/9YvGxiV3Ywpbqwz9Uk55gQj8zYtJl5UB9Lg3ynnbXbAy+i/1WqloU1JEpvG+LYn5nmvu5OLFysM78EZc1pEAJDrN3r/CbqXj9wcvT0ep2PQ7QVKciS+1Q9V8rpZCW/dyoic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836850; c=relaxed/simple;
	bh=1yeafLFuJZ3oPyqt92yiVSFqB2tt71ZWMr1gfEj+qgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iL6CvoNAlrJXDDM0XNtgeN0Y1J2YKrorcrEg/rhbh1Fqat9k0vFikz47w3hsVeBECqiQJbE9Pp+MV28pKNyJlKVZO2gadzGw9C8br0ucTgciv4PWMUFJBjD/TpdwKaLyHXm8CLx+1/Ro5kC888adol4DIF9svCutn+DQA7WCAj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZpTkIp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZpTkIp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CD4C2BBFC;
	Mon, 27 May 2024 19:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836850;
	bh=1yeafLFuJZ3oPyqt92yiVSFqB2tt71ZWMr1gfEj+qgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZpTkIp1ypHzshx+47op7eRGrpFschdripAAZF1QsiamYbxYeopUI9a8IIQtslQq5
	 8MjKmKACFpG1F6N8BOIjwmq4Z1yNH92MhJq0FMqZCKxd0Onbv2Bx5Vehc7WLOifDiU
	 PXl0wCQpD7W7KbVIQEmBRYa45m/RiLUjyD9HzqQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 211/427] selftests/resctrl: fix clang build failure: use LOCAL_HDRS
Date: Mon, 27 May 2024 20:54:18 +0200
Message-ID: <20240527185622.077655082@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit d8171aa4ca72f1a67bf3c14c59441d63c1d2585f ]

First of all, in order to build with clang at all, one must first apply
Valentin Obst's build fix for LLVM [1]. Once that is done, then when
building with clang, via:

    make LLVM=1 -C tools/testing/selftests

...the following error occurs:

   clang: error: cannot specify -o when generating multiple output files

This is because clang, unlike gcc, won't accept invocations of this
form:

    clang file1.c header2.h

Fix this by using selftests/lib.mk facilities for tracking local header
file dependencies: add them to LOCAL_HDRS, leaving only the .c files to
be passed to the compiler.

[1] https://lore.kernel.org/all/20240329-selftests-libmk-llvm-rfc-v1-1-2f9ed7d1c49f@valentinobst.de/

Fixes: 8e289f454289 ("selftests/resctrl: Add resctrl.h into build deps")
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/resctrl/Makefile b/tools/testing/selftests/resctrl/Makefile
index 2deac2031de9e..021863f86053a 100644
--- a/tools/testing/selftests/resctrl/Makefile
+++ b/tools/testing/selftests/resctrl/Makefile
@@ -5,6 +5,8 @@ CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := resctrl_tests
 
+LOCAL_HDRS += $(wildcard *.h)
+
 include ../lib.mk
 
-$(OUTPUT)/resctrl_tests: $(wildcard *.[ch])
+$(OUTPUT)/resctrl_tests: $(wildcard *.c)
-- 
2.43.0



