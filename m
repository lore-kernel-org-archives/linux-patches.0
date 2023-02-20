Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A475663B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1F9C433D2;
	Mon, 20 Feb 2023 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900558;
	bh=GeOdsghwt0sP1aMTsUVwep3X6R0jlPuPxsCNWBTH28I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AM4Mzs9TP+tFpuhszPCtYK70AopM5X4kfED6crof2A6q5lQbmIdVRJD0UkExRNd8X
	 6mh/xZ9dmDnjxftUyRR+X7cGlyPNt3bamgnp7+T3K53wP5NhbU5oZLbWkF+7r2nVyL
	 DPvdZWX8yrFn+etfybm28gbBLcGpg1BsLnpn7iDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Nies <michael.nies@netclusive.com>,
	YingChi Long <me@inclyc.cn>,
	Borislav Petkov <bp@suse.de>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.19 70/89] Revert "x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN"
Date: Mon, 20 Feb 2023 14:36:09 +0100
Message-Id: <20230220133555.594592089@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit a00d020f18dbe0666e221d929846f1b591b27c20 which is
commit 55228db2697c09abddcb9487c3d9fa5854a932cd upstream.

_Alignof is not in the gcc version that the 4.19.y kernel still
supports (4.6), so this change needs to be reverted as it breaks the
build on those older compiler versions.

Reported-by: Michael Nies <michael.nies@netclusive.com>
Link: https://lore.kernel.org/r/HE1PR0902MB188277E37DED663AE440510BE1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217013
Cc: YingChi Long <me@inclyc.cn>
Cc: Borislav Petkov <bp@suse.de>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/init.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -138,6 +138,9 @@ static void __init fpu__init_system_gene
 unsigned int fpu_kernel_xstate_size;
 EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
 
+/* Get alignment of the TYPE. */
+#define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
+
 /*
  * Enforce that 'MEMBER' is the last field of 'TYPE'.
  *
@@ -145,8 +148,8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size
  * because that's how C aligns structs.
  */
 #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \
-	BUILD_BUG_ON(sizeof(TYPE) !=         \
-		     ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))
+	BUILD_BUG_ON(sizeof(TYPE) != ALIGN(offsetofend(TYPE, MEMBER), \
+					   TYPE_ALIGN(TYPE)))
 
 /*
  * We append the 'struct fpu' to the task_struct:


