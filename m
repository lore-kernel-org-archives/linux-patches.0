Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677314A29;
	Thu, 15 Aug 2024 00:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683323; cv=none; b=OaNz6wY3Lb1cZ4OWk97Aq/CFPFGWLX8R48X2JuDM0QC9zGJYXvgAczuwKWZPNgJ/JPahOlIWE4NqeW7rG/UJYfdXRIpACZEeI8XG6BInKIkvDN3CNGEveZpcmouUgqUKc+g4K/QrkpCjo43axfFFbeGUnjFfzaoHxS8jaU8xQ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683323; c=relaxed/simple;
	bh=Q3VdSNLlJxpHBDel1dRJrqDUVKGxy4HCdDD6EClBOPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lJnK/eyiSFaOWn7526gzLNx7YCrVm55vHnTSZQP57hafWtcwL5ejQAd7/E0vUcPbFonIHYCfV4lZaCGhbC1T0+Bjv7xFpJPW9wTHxgtg18uOENPSYko5dZ4AkEowaJSQI5iiKJMPTASYH9I4d2MARG6+BxVMHcZCoqWUHRoDFK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRtUF79I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRtUF79I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9C3C4AF0A;
	Thu, 15 Aug 2024 00:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683322;
	bh=Q3VdSNLlJxpHBDel1dRJrqDUVKGxy4HCdDD6EClBOPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRtUF79IU14sh6fETE6mRvPYm4ak255uAYLrb7k2NLosZ/jzqAVOTs/tXMoNFKHdL
	 lzBDL2f66MghANRhOdGsfjmMhgnaALQzaP8tHXa3xRGZi9MmYGk7Qz4UGaMHbyc7Xg
	 7x+pkbSid0FtXRGblMdxcWW/r6UYHNI5aN0+bijtkFM9dqAk/kNOSnWLxKMw5z/t5U
	 NJBbbf/912vqSAeAWPUPgfxya1m164WQUsqQt+Z/WY0pVWLZIKbq6sm3nhtxrMQJTr
	 Xgwoz6mPTevKwMYFglzNrz/nvooJMXWVE/o/1AHigJBBKbsd5krq1cXbM7LbNkgZcj
	 XFdZmpE3aW1zA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 02/12] clk: test: Introduce clk_hw_unregister_kunit()
Date: Wed, 14 Aug 2024 17:55:08 -0700
Message-ID: <20240815005520.1192374-3-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
In-Reply-To: <20240815005520.1192374-1-sboyd@kernel.org>
References: <20240815005520.1192374-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Tests will need to unregister a clk_hw at a specific point during the
test. Add a clk_hw_unregister_kunit() function that releases the kunit
action created in a function like clk_hw_register_kunit() so that code
is kept tidy.

Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---

I need to introduce a kunit_release_action_or_fail() API.

 drivers/clk/clk_kunit_helpers.c | 25 +++++++++++++++++++++++++
 include/kunit/clk.h             |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/clk/clk_kunit_helpers.c b/drivers/clk/clk_kunit_helpers.c
index 52fd25594c96..87f97329ae0c 100644
--- a/drivers/clk/clk_kunit_helpers.c
+++ b/drivers/clk/clk_kunit_helpers.c
@@ -203,5 +203,30 @@ int of_clk_hw_register_kunit(struct kunit *test, struct device_node *node, struc
 }
 EXPORT_SYMBOL_GPL(of_clk_hw_register_kunit);
 
+/**
+ * clk_hw_unregister_kunit() - Force a clk_hw to be unregistered that is
+ * managed by {of_}clk_hw_register_kunit()
+ * @test: The test context
+ * @hw: link to hardware-specific clock data passed to {of_}clk_hw_register_kunit()
+ *
+ * Just like clk_hw_unregister(), except that the clk_hw must have been registered by
+ * a KUnit helper like clk_hw_register_kunit(). This removes the deferred KUnit action
+ * made earlier in the test and unregisters the clk immediately.
+ *
+ * Usually a test will use clk_hw_register_kunit() and let the deferred action
+ * unregister the clk automatically after the test case concludes. This
+ * function can be used to unregister the clk_hw immediately.
+ *
+ * Return: 0 on success or a negative errno value on failure to find the deferred action.
+ */
+int clk_hw_unregister_kunit(struct kunit *test, struct clk_hw *hw)
+{
+	kunit_release_action(test, clk_hw_unregister_wrapper, hw);
+	/* TODO: Find the action and fail */
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(clk_hw_unregister_kunit);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("KUnit helpers for clk providers and consumers");
diff --git a/include/kunit/clk.h b/include/kunit/clk.h
index 73bc99cefe7b..c513fec8099b 100644
--- a/include/kunit/clk.h
+++ b/include/kunit/clk.h
@@ -24,5 +24,6 @@ int clk_prepare_enable_kunit(struct kunit *test, struct clk *clk);
 int clk_hw_register_kunit(struct kunit *test, struct device *dev, struct clk_hw *hw);
 int of_clk_hw_register_kunit(struct kunit *test, struct device_node *node,
 			     struct clk_hw *hw);
+int clk_hw_unregister_kunit(struct kunit *test, struct clk_hw *hw);
 
 #endif
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

