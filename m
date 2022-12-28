Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40E41C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536F5C433EF;
	Wed, 28 Dec 2022 16:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245772;
	bh=RcIYVwf70pmzs7nidFY13OIN+AVbosDXuvB0Aa50h+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdErcH84Rg7Ik2K6m+g5EBGhSqiLM7i/ElXVaoDUvje5YyVtHLP0BxP73xF7Hys/P
	 4nAXA0NcghWsxhEFLVlKQYfR1Eas7t12ouZ9AxI0hF2vf4Nk37OMXt+5S2WNkbSSzJ
	 GVq7K7fShHyQskpNsGgztMu8MzyQGmuC0Nx8b6so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0952/1073] bpf: Fix a BTF_ID_LIST bug with CONFIG_DEBUG_INFO_BTF not set
Date: Wed, 28 Dec 2022 15:42:20 +0100
Message-Id: <20221228144353.893129627@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yonghong Song <yhs@fb.com>

[ Upstream commit beb3d47d1d3d7185bb401af628ad32ee204a9526 ]

With CONFIG_DEBUG_INFO_BTF not set, we hit the following compilation error,
  /.../kernel/bpf/verifier.c:8196:23: error: array index 6 is past the end of the array
  (that has type 'u32[5]' (aka 'unsigned int[5]')) [-Werror,-Warray-bounds]
        if (meta->func_id == special_kfunc_list[KF_bpf_cast_to_kern_ctx])
                             ^                  ~~~~~~~~~~~~~~~~~~~~~~~
  /.../kernel/bpf/verifier.c:8174:1: note: array 'special_kfunc_list' declared here
  BTF_ID_LIST(special_kfunc_list)
  ^
  /.../include/linux/btf_ids.h:207:27: note: expanded from macro 'BTF_ID_LIST'
  #define BTF_ID_LIST(name) static u32 __maybe_unused name[5];
                            ^
  /.../kernel/bpf/verifier.c:8443:19: error: array index 5 is past the end of the array
  (that has type 'u32[5]' (aka 'unsigned int[5]')) [-Werror,-Warray-bounds]
                 btf_id == special_kfunc_list[KF_bpf_list_pop_back];
                           ^                  ~~~~~~~~~~~~~~~~~~~~
  /.../kernel/bpf/verifier.c:8174:1: note: array 'special_kfunc_list' declared here
  BTF_ID_LIST(special_kfunc_list)
  ^
  /.../include/linux/btf_ids.h:207:27: note: expanded from macro 'BTF_ID_LIST'
  #define BTF_ID_LIST(name) static u32 __maybe_unused name[5];
  ...

Fix the problem by increase the size of BTF_ID_LIST to 16 to avoid compilation error
and also prevent potentially unintended issue due to out-of-bound access.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20221123155759.2669749-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/btf_ids.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 2aea877d644f..2b9872008428 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -204,7 +204,7 @@ extern struct btf_id_set8 name;
 
 #else
 
-#define BTF_ID_LIST(name) static u32 __maybe_unused name[5];
+#define BTF_ID_LIST(name) static u32 __maybe_unused name[16];
 #define BTF_ID(prefix, name)
 #define BTF_ID_FLAGS(prefix, name, ...)
 #define BTF_ID_UNUSED
-- 
2.35.1



