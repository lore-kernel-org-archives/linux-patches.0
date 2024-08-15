Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03CC79FE;
	Thu, 15 Aug 2024 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683324; cv=none; b=Ri/AHrW+Sk//Jc/q8I8vlI6K/Q/UbECchZEiffZFXjKTgPbyzMM36yD9F+DjgV8N+fICCBbGLK7TzUdJeEXa9HsUZCAmhHkQRfN5h7kPQVWXSLkHQIgl3w4TpH2MJ57CKHsmpu+/WLQKGaHaXYam4EGCNBT1OLs9cX11eDQEwXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683324; c=relaxed/simple;
	bh=1SvAIb0o+W/r+iOeMYugG0sJ9hFeev4b5yjOhrI5OIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=esDBuKI2OwkBCGpiJoHZNhjcgBt7OjNWJaOyik5WGgyXEZ2kC39VPqLEL3gk6TFiRrvZlfpaWmREQuHtfkwFSk7CHPnjF8Faly95HX5OOFYyGqnHnG5X+8uMEhkJfghwJHS9kQ9pm6pc7d7hRWjD1Y/LH5My6L7r4UhZVvUF1q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=So1diBBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="So1diBBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9F6C4AF0E;
	Thu, 15 Aug 2024 00:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683323;
	bh=1SvAIb0o+W/r+iOeMYugG0sJ9hFeev4b5yjOhrI5OIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=So1diBBVd0GY0mswIy/taBP/Td0isOPFNzqiYpjz7M6tNCRtfF5LMZHsl3cGCBC6V
	 P4Ox22bjU7xe5tEAZtBiOYkZZktI/w3re13p9yIA3JpZD504Mk8k/GsbUu0EfnBDuc
	 07wyAww6bvKFE9GCY+odwAfU1nwqaAj3FrqMIu1WvLDbYwmezBiNYoQJ/7hbwAkPSk
	 ynROpKXeAkl09vaAXazuB9XsaD8CGn6cKAXiS8GUbvrU8+oPdeJF5VAnuzw949KQuj
	 feBM8ZKCmVLwllgRZmwfewijaLgy8AyjDumMCkHgMuFIQhamhLZGf8tnGEtskoWH7n
	 yGXcrfByIvadQ==
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
Subject: [PATCH 03/12] clk: test: Introduce clk_put_kunit()
Date: Wed, 14 Aug 2024 17:55:09 -0700
Message-ID: <20240815005520.1192374-4-sboyd@kernel.org>
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

Tests will need to put a clk at a specific point during the test. Add a
clk_put_kunit() function that releases the kunit action created by a
function like clk_get_kunit() so that code is kept tidy.

Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk_kunit_helpers.c | 21 +++++++++++++++++++++
 include/kunit/clk.h             |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/clk/clk_kunit_helpers.c b/drivers/clk/clk_kunit_helpers.c
index 87f97329ae0c..ddb9f2de1083 100644
--- a/drivers/clk/clk_kunit_helpers.c
+++ b/drivers/clk/clk_kunit_helpers.c
@@ -153,6 +153,27 @@ clk_hw_get_clk_prepared_enabled_kunit(struct kunit *test, struct clk_hw *hw,
 }
 EXPORT_SYMBOL_GPL(clk_hw_get_clk_prepared_enabled_kunit);
 
+/**
+ * clk_put_kunit() - Force a clk_put() call on a clk managed by the @test
+ * @test: The test context
+ * @clk: Clk consumer to put with clk_put()
+ *
+ * Just like clk_put(), except the clk must be managed by the @test, i.e.
+ * returned from something like clk_get_kunit(). clk_put() will be called
+ * immediately and the deferred action will be removed.
+ *
+ * Return: 0 on success or a negative errno value on failure to find the
+ * deferred action.
+ */
+int clk_put_kunit(struct kunit *test, struct clk *clk)
+{
+	kunit_release_action(test, clk_put_wrapper, clk);
+	/* TODO: Find the action and fail */
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(clk_put_kunit);
+
 KUNIT_DEFINE_ACTION_WRAPPER(clk_hw_unregister_wrapper,
 			    clk_hw_unregister, struct clk_hw *);
 
diff --git a/include/kunit/clk.h b/include/kunit/clk.h
index c513fec8099b..d37fa6b87c2b 100644
--- a/include/kunit/clk.h
+++ b/include/kunit/clk.h
@@ -18,6 +18,7 @@ clk_hw_get_clk_kunit(struct kunit *test, struct clk_hw *hw, const char *con_id);
 struct clk *
 clk_hw_get_clk_prepared_enabled_kunit(struct kunit *test, struct clk_hw *hw,
 				      const char *con_id);
+int clk_put_kunit(struct kunit *test, struct clk *clk);
 
 int clk_prepare_enable_kunit(struct kunit *test, struct clk *clk);
 
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

