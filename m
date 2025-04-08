Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2C526B0A2;
	Tue,  8 Apr 2025 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115994; cv=none; b=pc07CC4h2i5PwWP+h3f8A32N/3k7ZgJSQH3uB8mobcJiAzH+NRRsc9VhFd+gBKm/gQtfxBe5q/TtjBlsIvhKkozEZSpHrrK6h/1HDoUVWqnp/93x5b+/yA4BJEUpJmpnqiSpVMx2RvfpB2iuU2vua3cWJZqsIvuFRRqdxidO0p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115994; c=relaxed/simple;
	bh=pwWZORsjgRlShLnqNdke0yZnbSpz+1iZxfDAfJEk7Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ok2q6ca+bItOQOpPLW43uYaeN5ZdBqYLsxyzx+Jbdl7Ldw4zyp3KfRksUvf1jeO8qrcYfRxzh9+brHeOT7XNVvGBybaQVz8Smi92AqYP9n1TUrIiEQKC3SJzlDeqeVX7JbRJOB9WB1I/7usNvEIDklo81QGNTJsW3gIDcKOKF5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGRHXu17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGRHXu17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34926C4CEE7;
	Tue,  8 Apr 2025 12:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115994;
	bh=pwWZORsjgRlShLnqNdke0yZnbSpz+1iZxfDAfJEk7Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGRHXu17OAm7kiMkm3LW+F/caCP2da+9BCQEe1L4J9tqc/7gNuOcL5IMrAvg3rbCK
	 L9OxFo2592A8O2pTAlGZ28Ey6azS1GSf5DQyV2Bd4k+72CYXptbWY+q/+j5nWHByKH
	 n/rZsacSSvjRhrXHgDujEuHeYZH6V0b3+2de031g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	David Gow <davidgow@google.com>,
	Kees Cook <kees@kernel.org>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 181/204] kunit/overflow: Fix UB in overflow_allocation_test
Date: Tue,  8 Apr 2025 12:51:51 +0200
Message-ID: <20250408104825.629732002@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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
 


