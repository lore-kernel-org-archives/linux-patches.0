Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FB115E8B;
	Mon, 30 Dec 2024 15:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573651; cv=none; b=C8K8Xh4JbW9TPJDaeyGWCv7i04Qb/q4EqEs7JYcP+3AWegQw1apcGAE8BuRjHjQ3icF8DFC6zEDZ65ohk5fgyfAQi/nGDLRR4Zwn65LbaxuwHkn7W0EPJDP1fy4EgrLCw+V4jHvfazbeRTuTGi5F7efKOKzGatvht3Z+/kNygHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573651; c=relaxed/simple;
	bh=7Fys+seYAcxXSF3+IyLnxlsYsrM4tH3YZFna1XNz4lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nl52ntxjmgq4BPVSKxj2Dx27is/O7O+1kDFnC9MC16bGhqyxV2sCC14mJDG99N6f9yalt9NP/VWR7c2LmRTQpUAIKjUDjtGj73i2L5L7aDkALXK6vwk7wPm3uDt7dBWG0CPqbuxn0kSXtQk1TP14CRZxBiUrSDbjh5zct0XQWmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Do5DNkiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Do5DNkiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BD8C4CED0;
	Mon, 30 Dec 2024 15:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573651;
	bh=7Fys+seYAcxXSF3+IyLnxlsYsrM4tH3YZFna1XNz4lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Do5DNkiTEROL98+LM1ASkkQ19IIpO7I0cIy6ptdiFsDGfswen8mXiMGBXtcYJPzQW
	 fTo5jSJu7L9LOGjpFEQZYCpzFkYJPzBUOKKlI61vQPeD7oJuPuzUIHhpueSju3Zfvi
	 Jz7pzqk0EUgDDmYM8pUFkmA5fdIrZvBYOwDCmgrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Ferris <cferris@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/60] stddef: make __struct_group() UAPI C++-friendly
Date: Mon, 30 Dec 2024 16:42:35 +0100
Message-ID: <20241230154208.240713661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 724c6ce38bbaeb4b3f109b0e066d6c0ecd15446c ]

For the most part of the C++ history, it couldn't have type
declarations inside anonymous unions for different reasons. At the
same time, __struct_group() relies on the latters, so when the @TAG
argument is not empty, C++ code doesn't want to build (even under
`extern "C"`):

../linux/include/uapi/linux/pkt_cls.h:25:24: error:
'struct tc_u32_sel::<unnamed union>::tc_u32_sel_hdr,' invalid;
an anonymous union may only have public non-static data members
[-fpermissive]

The safest way to fix this without trying to switch standards (which
is impossible in UAPI anyway) etc., is to disable tag declaration
for that language. This won't break anything since for now it's not
buildable at all.
Use a separate definition for __struct_group() when __cplusplus is
defined to mitigate the error, including the version from tools/.

Fixes: 50d7bd38c3aa ("stddef: Introduce struct_group() helper macro")
Reported-by: Christopher Ferris <cferris@google.com>
Closes: https://lore.kernel.org/linux-hardening/Z1HZpe3WE5As8UAz@google.com
Suggested-by: Kees Cook <kees@kernel.org> # __struct_group_tag()
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20241219135734.2130002-1-aleksander.lobakin@intel.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/stddef.h       | 13 ++++++++++---
 tools/include/uapi/linux/stddef.h | 15 +++++++++++----
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index dcd50fb2164a..ef892cb1cbb7 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -8,6 +8,13 @@
 #define __always_inline inline
 #endif
 
+/* Not all C++ standards support type declarations inside an anonymous union */
+#ifndef __cplusplus
+#define __struct_group_tag(TAG)		TAG
+#else
+#define __struct_group_tag(TAG)
+#endif
+
 /**
  * __struct_group() - Create a mirrored named and anonyomous struct
  *
@@ -20,13 +27,13 @@
  * and size: one anonymous and one named. The former's members can be used
  * normally without sub-struct naming, and the latter can be used to
  * reason about the start, end, and size of the group of struct members.
- * The named struct can also be explicitly tagged for layer reuse, as well
- * as both having struct attributes appended.
+ * The named struct can also be explicitly tagged for layer reuse (C only),
+ * as well as both having struct attributes appended.
  */
 #define __struct_group(TAG, NAME, ATTRS, MEMBERS...) \
 	union { \
 		struct { MEMBERS } ATTRS; \
-		struct TAG { MEMBERS } ATTRS NAME; \
+		struct __struct_group_tag(TAG) { MEMBERS } ATTRS NAME; \
 	} ATTRS
 
 /**
diff --git a/tools/include/uapi/linux/stddef.h b/tools/include/uapi/linux/stddef.h
index bb6ea517efb5..c53cde425406 100644
--- a/tools/include/uapi/linux/stddef.h
+++ b/tools/include/uapi/linux/stddef.h
@@ -8,6 +8,13 @@
 #define __always_inline __inline__
 #endif
 
+/* Not all C++ standards support type declarations inside an anonymous union */
+#ifndef __cplusplus
+#define __struct_group_tag(TAG)		TAG
+#else
+#define __struct_group_tag(TAG)
+#endif
+
 /**
  * __struct_group() - Create a mirrored named and anonyomous struct
  *
@@ -20,14 +27,14 @@
  * and size: one anonymous and one named. The former's members can be used
  * normally without sub-struct naming, and the latter can be used to
  * reason about the start, end, and size of the group of struct members.
- * The named struct can also be explicitly tagged for layer reuse, as well
- * as both having struct attributes appended.
+ * The named struct can also be explicitly tagged for layer reuse (C only),
+ * as well as both having struct attributes appended.
  */
 #define __struct_group(TAG, NAME, ATTRS, MEMBERS...) \
 	union { \
 		struct { MEMBERS } ATTRS; \
-		struct TAG { MEMBERS } ATTRS NAME; \
-	}
+		struct __struct_group_tag(TAG) { MEMBERS } ATTRS NAME; \
+	} ATTRS
 
 /**
  * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
-- 
2.39.5



