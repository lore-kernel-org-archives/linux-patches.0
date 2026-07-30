Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DC844AB9C;
	Thu, 30 Jul 2026 15:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425370; cv=none; b=B+JTYWjyT1MZYeKUoPlhZbv91DD7QyViNNviQ7UNS2A/qPaCEx++mNp7uUQB7JnARy/DB3fBF7AQNidYFfGTXaTwU80xjhoRaapVlUqXf+7dESubSRfsJfdV5B2fdneUK2KR9uknKQgctnooI5vdKB+aBd2mUzxY/AaShPyUXh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425370; c=relaxed/simple;
	bh=98fiqmIbvoD7Gl8woqgW0TmtETE7VY4OYzM1hccimYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJMWW6rW/sfqxp/tpnX509wNaD8CVtMj7g0/qGDTmmqN7zpTijJsPpxb5CiOojCe9dYLqJabPcvtYR2KRb3GqNEqrqbU696SYANuQcEuYGa8PPdf2RZde89Hucu/voyXbGt0qBRyPlu+Y+Qm9wK8TUk37JQlezFAPXU5FAdhDYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYuG84l+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYuG84l+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9021F000E9;
	Thu, 30 Jul 2026 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425369;
	bh=H0WF/GFV7keBOXlv9SJeu6qPn0U+hs43WtRpGOz7zvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYuG84l+zfmtU7MIiIh+aDGEGjPJLvs1xcqxs+J0avcKuS5cWwifUOw1P+Q7Ry4DE
	 kBnhpU76oUqRwhq13idPK4mhIETCACwoTdr2l7eZTdveBpNY3b14uppvNIvUr+V4ca
	 CbYyxAGulwMl4VtNCF2bvRqlshmlAwaCooB58P2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 012/602] seqlock: Allow KASAN to fail optimizing
Date: Thu, 30 Jul 2026 16:06:44 +0200
Message-ID: <20260730141436.254780815@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit b94d45b6bbb42571ec225d3be0e7457c8765a5b4 upstream.

Some KASAN builds are failing to properly optimize this code --
luckily we don't care about core quality for KASAN builds, so just
exclude it.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Closes: https://lore.kernel.org/oe-kbuild-all/202510251641.idrNXhv5-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/seqlock.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -1211,11 +1211,14 @@ static __always_inline void __scoped_seq
 
 extern void __scoped_seqlock_invalid_target(void);
 
-#if defined(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION < 90000
+#if (defined(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION < 90000) || defined(CONFIG_KASAN)
 /*
  * For some reason some GCC-8 architectures (nios2, alpha) have trouble
  * determining that the ss_done state is impossible in __scoped_seqlock_next()
  * below.
+ *
+ * Similarly KASAN is known to confuse compilers enough to break this. But we
+ * don't care about code quality for KASAN builds anyway.
  */
 static inline void __scoped_seqlock_bug(void) { }
 #else


