Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7DC387B06;
	Tue, 16 Dec 2025 12:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888292; cv=none; b=GAUO0kcJZVsS6MZ4oLv4vxnHxUep/5rpHEU/alMgK6Z+Tf0zgWz1umUDwmRY5K/vtJoHzd9fqYA7lMuggNV5FD4n9OWXhpHsqmtE4cTe7fer9Yetoid9dDKWECjuXUcf4CJPi3kh2jKQvK8Q8VF63exeRt9JN/huRjP6ju7nLnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888292; c=relaxed/simple;
	bh=GcaqIK3m6qeYHMP1TKFeVtUK+GGhb6ADKQ5Wfeuf+24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZTOlRhEIv+2QGjhrLQ7AkIo9o135ZkLnZ4TbGAzorG/7Q5NBkkwjWbWMRxMf9go21jVRU/LH41N5EtjkskMkiiHhPft8g9ElhGn7q+m9npWgI8V9DPUa75u3qXGGqU+vuwQb9+RjzH9fZVZzRLp3PnkI6ykHfxnjmBTZS7EW98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFvQUiFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFvQUiFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA572C4CEF1;
	Tue, 16 Dec 2025 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888292;
	bh=GcaqIK3m6qeYHMP1TKFeVtUK+GGhb6ADKQ5Wfeuf+24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFvQUiFquIVdRy1NkmTu/Z0+rff9bhr8yf0RrJTEJjpDuEyVHCkLmZtkE80s3QKuX
	 /Kr3sCAQudTxAlNEH0AHiUWiFKimfJh+FQikuIvJYvKHO/Igl+SX7gZ4Szfi/JL+Wt
	 OCY73GZBt+2w9qnDDGdBtgzxcfN0pMTMI1EFBHOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <rabenda.cn@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 457/614] of: Skip devicetree kunit tests when RISCV+ACPI doesnt populate root node
Date: Tue, 16 Dec 2025 12:13:44 +0100
Message-ID: <20251216111417.925049909@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 546dbb0223102813ffb5bbcb9443a47c3183f195 ]

Starting with commit 69a8b62a7aa1 ("riscv: acpi: avoid errors caused by
probing DT devices when ACPI is used"), riscv images no longer populate
devicetree if ACPI is enabled. This causes unit tests to fail which require
the root node to be set.

  # Subtest: of_dtb
  # module: of_test
  1..2
  # of_dtb_root_node_found_by_path: EXPECTATION FAILED at drivers/of/of_test.c:21
  Expected np is not null, but is
  # of_dtb_root_node_found_by_path: pass:0 fail:1 skip:0 total:1
  not ok 1 of_dtb_root_node_found_by_path
  # of_dtb_root_node_populates_of_root: EXPECTATION FAILED at drivers/of/of_test.c:31
  Expected of_root is not null, but is
  # of_dtb_root_node_populates_of_root: pass:0 fail:1 skip:0 total:1
  not ok 2 of_dtb_root_node_populates_of_root

Skip those tests for RISCV if the root node is not populated.

Fixes: 69a8b62a7aa1 ("riscv: acpi: avoid errors caused by probing DT devices when ACPI is used")
Cc: Han Gao <rabenda.cn@gmail.com>
Cc: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Paul Walmsley <pjw@kernel.org>  # arch/riscv
Link: https://patch.msgid.link/20251023160415.705294-1-linux@roeck-us.net
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_kunit_helpers.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_kunit_helpers.c b/drivers/of/of_kunit_helpers.c
index 7b3ed5a382aaa..f6ed1af8b62aa 100644
--- a/drivers/of/of_kunit_helpers.c
+++ b/drivers/of/of_kunit_helpers.c
@@ -18,8 +18,9 @@
  */
 void of_root_kunit_skip(struct kunit *test)
 {
-	if (IS_ENABLED(CONFIG_ARM64) && IS_ENABLED(CONFIG_ACPI) && !of_root)
-		kunit_skip(test, "arm64+acpi doesn't populate a root node");
+	if ((IS_ENABLED(CONFIG_ARM64) || IS_ENABLED(CONFIG_RISCV)) &&
+	    IS_ENABLED(CONFIG_ACPI) && !of_root)
+		kunit_skip(test, "arm64/riscv+acpi doesn't populate a root node");
 }
 EXPORT_SYMBOL_GPL(of_root_kunit_skip);
 
-- 
2.51.0



