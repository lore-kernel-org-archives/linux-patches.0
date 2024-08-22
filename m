Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815839461;
	Thu, 22 Aug 2024 00:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724286275; cv=none; b=lmjLkLPPc+KetC6Pb4jKOJlgY8mSFJqpn16UCHoqNWEsDfzadYbpf84k26MmHUZDg64KbWlD6LlYWDumZZHez3h/E/Nduyb6CaitOB1ueCIVUbk5HbURm9eZG/lOyrOUKOoos8ANwkezhZKHE8IhnYbUxeIoy0qI3PQTpe0coL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724286275; c=relaxed/simple;
	bh=G1cjRB6XIiXUXCpI8pAIT4Y8paG5Zk4ulJFTOEXnFv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYfCY8yo8HftCUcxhKJ4JH2fO+yldEclXOsvmZJ1RmtnclE4Orv1z8iof8sHwyqc9hzAPapQKWc7qZPxmTBrBPj+JIKCQAY7euJP+s+jHGrCwcO+ki6wsr0VOoy34C7ZYCnJDLrac5ddFp7Js1QpEN1TUAjbQxHXGeh1P+cVHZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ne4PuUHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ne4PuUHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B36C4AF0E;
	Thu, 22 Aug 2024 00:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724286275;
	bh=G1cjRB6XIiXUXCpI8pAIT4Y8paG5Zk4ulJFTOEXnFv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ne4PuUHDg2IyUAOeLZlIlOErG8rmNfp/uAiGoFHlIGAyA9/5Ia3atSqZ+RsiyJVeC
	 CfFKVSAb44ELq8/gPmHo7DuIAz8eVYQAFX0qq1n+57Q5+tOUjVbWR0igp6C2k8DQ0z
	 CrDHWYkmnEhf330QCePoEk/6jAU+IBCd7enMF0uC25DJjh8eHhFJ4NKVitzognGEj6
	 2XGLBE/fLByNGxLDAHzbDG6wbWOrqX6CISv02g0KAunA9iyYV3UN3URj9gQnNrRrEJ
	 yfwcnmBuw0cbmIiFhuSDj82IG2iW7GvdwnAcMTj6yO2zFx4ivF8tjR4QS5cRrYlnWX
	 Sd0Asqu6jEVSA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 1/3] clk: test: Add test managed of_clk_add_hw_provider()
Date: Wed, 21 Aug 2024 17:24:28 -0700
Message-ID: <20240822002433.1163814-2-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822002433.1163814-1-sboyd@kernel.org>
References: <20240822002433.1163814-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test managed version of of_clk_add_hw_provider() that
automatically unregisters the clk_hw provider upon test conclusion.

Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk_kunit_helpers.c | 30 ++++++++++++++++++++++++++++++
 include/kunit/clk.h             |  4 ++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/clk/clk_kunit_helpers.c b/drivers/clk/clk_kunit_helpers.c
index 52fd25594c96..68a28e70bb61 100644
--- a/drivers/clk/clk_kunit_helpers.c
+++ b/drivers/clk/clk_kunit_helpers.c
@@ -203,5 +203,35 @@ int of_clk_hw_register_kunit(struct kunit *test, struct device_node *node, struc
 }
 EXPORT_SYMBOL_GPL(of_clk_hw_register_kunit);
 
+KUNIT_DEFINE_ACTION_WRAPPER(of_clk_del_provider_wrapper,
+			    of_clk_del_provider, struct device_node *);
+
+/**
+ * of_clk_add_hw_provider_kunit() - Test managed of_clk_add_hw_provider()
+ * @test: The test context
+ * @np: Device node pointer associated with clock provider
+ * @get: Callback for decoding clk_hw
+ * @data: Context pointer for @get callback.
+ *
+ * Just like of_clk_add_hw_provider(), except the clk_hw provider is managed by
+ * the test case and is automatically unregistered after the test case
+ * concludes.
+ *
+ * Return: 0 on success or a negative errno value on failure.
+ */
+int of_clk_add_hw_provider_kunit(struct kunit *test, struct device_node *np,
+				 struct clk_hw *(*get)(struct of_phandle_args *clkspec, void *data),
+				 void *data)
+{
+	int ret;
+
+	ret = of_clk_add_hw_provider(np, get, data);
+	if (ret)
+		return ret;
+
+	return kunit_add_action_or_reset(test, of_clk_del_provider_wrapper, np);
+}
+EXPORT_SYMBOL_GPL(of_clk_add_hw_provider_kunit);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("KUnit helpers for clk providers and consumers");
diff --git a/include/kunit/clk.h b/include/kunit/clk.h
index 73bc99cefe7b..0afae7688157 100644
--- a/include/kunit/clk.h
+++ b/include/kunit/clk.h
@@ -25,4 +25,8 @@ int clk_hw_register_kunit(struct kunit *test, struct device *dev, struct clk_hw
 int of_clk_hw_register_kunit(struct kunit *test, struct device_node *node,
 			     struct clk_hw *hw);
 
+int of_clk_add_hw_provider_kunit(struct kunit *test, struct device_node *np,
+				 struct clk_hw *(*get)(struct of_phandle_args *clkspec, void *data),
+				 void *data);
+
 #endif
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

