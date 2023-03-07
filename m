Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA94ABA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50368C433D2;
	Tue,  7 Mar 2023 17:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210824;
	bh=gqJnJUGl7wxn/SZ+P5h6Yr2ecI+jIRuAo9iv8iQb0mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6xDDOwijMcOWONi/abMy/lZfKu3zQPdcJcNp2fWEgGM0vkWwosVb7cLprbaZEIC0
	 I8SPy2xMxT4tBlpW0Lswn5Ee19yK6E5HaY5gcC497wS1qjoI/FOMDnDURhEjDgtiJX
	 RbBwan7U+LljtJMC9Lt/rsK98M6KhWdCunBpYiq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam James <sam@gentoo.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0666/1001] gcc-plugins: drop -std=gnu++11 to fix GCC 13 build
Date: Tue,  7 Mar 2023 17:57:18 +0100
Message-Id: <20230307170050.517594512@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sam James <sam@gentoo.org>

[ Upstream commit 5a6b64adc18d9adfb497a529ff004d59b6df151f ]

The latest GCC 13 snapshot (13.0.1 20230129) gives the following:
```
cc1: error: cannot load plugin ./scripts/gcc-plugins/randomize_layout_plugin.so
 :./scripts/gcc-plugins/randomize_layout_plugin.so: undefined symbol: tree_code_type
```

This ends up being because of https://gcc.gnu.org/git/gitweb.cgi?p=gcc.git;h=b0241ce6e37031
upstream in GCC which changes the visibility of some types used by the kernel's
plugin infrastructure like tree_code_type.

After discussion with the GCC folks, we found that the kernel needs to be building
plugins with the same flags used to build GCC - and GCC defaults to gnu++17
right now. The minimum GCC version needed to build the kernel is GCC 5.1
and GCC 5.1 already defaults to gnu++14 anyway, so just drop the flag, as
all GCCs that could be used to build GCC already default to an acceptable
version which was >= the version we forced via flags until now.

Bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108634
Signed-off-by: Sam James <sam@gentoo.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230201230009.2252783-1-sam@gentoo.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index b34d11e226366..320afd3cf8e82 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -29,7 +29,7 @@ GCC_PLUGINS_DIR = $(shell $(CC) -print-file-name=plugin)
 plugin_cxxflags	= -Wp,-MMD,$(depfile) $(KBUILD_HOSTCXXFLAGS) -fPIC \
 		  -include $(srctree)/include/linux/compiler-version.h \
 		  -DPLUGIN_VERSION=$(call stringify,$(KERNELVERSION)) \
-		  -I $(GCC_PLUGINS_DIR)/include -I $(obj) -std=gnu++11 \
+		  -I $(GCC_PLUGINS_DIR)/include -I $(obj) \
 		  -fno-rtti -fno-exceptions -fasynchronous-unwind-tables \
 		  -ggdb -Wno-narrowing -Wno-unused-variable \
 		  -Wno-format-diag
-- 
2.39.2



