Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D40139FF7;
	Fri, 24 Nov 2023 18:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0d3FUD23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A499EC433C7;
	Fri, 24 Nov 2023 18:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850802;
	bh=b/kW9XHR/LbHVxXK60gK3mMiGWEhWQMJXk0dttM42Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0d3FUD23JYBvOFYU/2OhTagtAGh/QPJRZJ4IO7Ctu5y0al90Mc1uaaYPn303qHzrv
	 d8IZUSlgrLoULcHK/kh49xZ3WFKPzZkCLpSHRXvCflLYxH65h/kVSxcqdcExCpnOF0
	 pePKRTvW83XDmzMJKvPmGqCUhoBW1kQ6KlmdqCFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KP Singh <kpsingh@kernel.org>,
	linux-hardening@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Bill Wendling <morbo@google.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 170/491] gcc-plugins: randstruct: Only warn about true flexible arrays
Date: Fri, 24 Nov 2023 17:46:46 +0000
Message-ID: <20231124172029.578507512@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 1ee60356c2dca938362528404af95b8ef3e49b6a ]

The randstruct GCC plugin tried to discover "fake" flexible arrays
to issue warnings about them in randomized structs. In the future
LSM overhead reduction series, it would be legal to have a randomized
struct with a 1-element array, and this should _not_ be treated as a
flexible array, especially since commit df8fc4e934c1 ("kbuild: Enable
-fstrict-flex-arrays=3"). Disable the 0-sized and 1-element array
discovery logic in the plugin, but keep the "true" flexible array check.

Cc: KP Singh <kpsingh@kernel.org>
Cc: linux-hardening@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311021532.iBwuZUZ0-lkp@intel.com/
Fixes: df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
Reviewed-by: Bill Wendling <morbo@google.com>
Acked-by: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20231104204334.work.160-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 951b74ba1b242..5e5744b65f8a9 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -273,8 +273,6 @@ static bool is_flexible_array(const_tree field)
 {
 	const_tree fieldtype;
 	const_tree typesize;
-	const_tree elemtype;
-	const_tree elemsize;
 
 	fieldtype = TREE_TYPE(field);
 	typesize = TYPE_SIZE(fieldtype);
@@ -282,20 +280,12 @@ static bool is_flexible_array(const_tree field)
 	if (TREE_CODE(fieldtype) != ARRAY_TYPE)
 		return false;
 
-	elemtype = TREE_TYPE(fieldtype);
-	elemsize = TYPE_SIZE(elemtype);
-
 	/* size of type is represented in bits */
 
 	if (typesize == NULL_TREE && TYPE_DOMAIN(fieldtype) != NULL_TREE &&
 	    TYPE_MAX_VALUE(TYPE_DOMAIN(fieldtype)) == NULL_TREE)
 		return true;
 
-	if (typesize != NULL_TREE &&
-	    (TREE_CONSTANT(typesize) && (!tree_to_uhwi(typesize) ||
-	     tree_to_uhwi(typesize) == tree_to_uhwi(elemsize))))
-		return true;
-
 	return false;
 }
 
-- 
2.42.0



