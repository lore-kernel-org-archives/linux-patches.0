Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DD6268FEB;
	Tue,  8 Apr 2025 12:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113748; cv=none; b=bBiuMZqhgo3IS1T8WN6/OnH4/nVOWUkH81b/e3aJuZJdL7w5ptJi+8h39hbcr5zde6gnZ+vrUlq5sTbhIDBBe80Ca9HynRwHQwXSba8aHg3TvcEwueqPyg4pkQ4xi/p00a0gD5dqg76BTd3c6b2ggLT7Gv8i12gIN2JAtAVaHoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113748; c=relaxed/simple;
	bh=ygbmMzpyDuyFd5WvfjGcu92I8bUA7d+l7ebhLIKRi2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCBocZsE32d/9/KHAmFOa6mhbwmDmFqExwwBpRBRhwOpdI5nrJ5o4t1KKnyCZDAD09zlD2Og0Ep06pO4hNU1dIjqbI/Zly2xa4f4v69/NNHqs6bjADDi8171YH8+P6ealRk1Je33/T3xHHFtDOjcq+IkjSpf6IQkBIi3DoyBrGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfFCokHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfFCokHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8234AC4CEE5;
	Tue,  8 Apr 2025 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113747;
	bh=ygbmMzpyDuyFd5WvfjGcu92I8bUA7d+l7ebhLIKRi2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfFCokHe/5YY1Yt1SOV56ioL8xAe2JkC5h1XvEtF1DeiSjrBAyM17i7iTrhVTMS2J
	 oB9XKdEj/tiKILytTJV0Q1iNbokHB0liKBTHXCJM9JYMznnRRToVDZJciEfy3uAZgP
	 uGoHV0Udhhxc7RwZHr5o8rSFx009GHDXUEzEMG9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	David Gow <davidgow@google.com>,
	Kees Cook <kees@kernel.org>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 242/268] kunit/overflow: Fix UB in overflow_allocation_test
Date: Tue,  8 Apr 2025 12:50:53 +0200
Message-ID: <20250408104835.115937617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Orlov <ivan.orlov0322@gmail.com>

commit 92e9bac18124682c4b99ede9ee3bcdd68f121e92 upstream.

The 'device_name' array doesn't exist out of the
'overflow_allocation_test' function scope. However, it is being used as
a driver name when calling 'kunit_driver_create' from
'kunit_device_register'. It produces the kernel panic with KASAN
enabled.

Since this variable is used in one place only, remove it and pass the
device name into kunit_device_register directly as an ascii string.

Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Reviewed-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/r/20240815000431.401869-1-ivan.orlov0322@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/overflow_kunit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/overflow_kunit.c
+++ b/lib/overflow_kunit.c
@@ -608,7 +608,6 @@ DEFINE_TEST_ALLOC(devm_kzalloc,  devm_kf
 
 static void overflow_allocation_test(struct kunit *test)
 {
-	const char device_name[] = "overflow-test";
 	struct device *dev;
 	int count = 0;
 
@@ -618,7 +617,7 @@ static void overflow_allocation_test(str
 } while (0)
 
 	/* Create dummy device for devm_kmalloc()-family tests. */
-	dev = root_device_register(device_name);
+	dev = root_device_register("overflow-test");
 	KUNIT_ASSERT_FALSE_MSG(test, IS_ERR(dev),
 			       "Cannot register test device\n");
 


