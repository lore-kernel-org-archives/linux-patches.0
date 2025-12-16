Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75713557F6;
	Tue, 16 Dec 2025 11:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886226; cv=none; b=NKGVETFLCDk6f/rCx29FljauFAJ+FWLQll6z5nh+MMNC2e4d/CrgR9ZmMSM1rWnVQLVcC9H26hk7SjBJGe1t0wJ+j299O9+RktwCoznTsU8qZ1qodAmLkLW+RxvL7ngBXmcaYVf/Z42HJuLxFwRfEnLI1VCK/Jarhj2qaStMtpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886226; c=relaxed/simple;
	bh=75tKB7lwYifiKkw2xa4WthiRsArGbgB2fP35whytsWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GewXryInwfL/n6YWPE7lz5JKTeVCWGlkP5qofH+FqBcyQWBbMG/b+Kk1qJoFjA9p4fQsrp0mqGflqM5JnA9toBdW0akQyJHNxXYcZc5oQf0Jp3L6mrtA6ZrhwYw3qlv/WyqxKgYgbgUiRJ817VNKmyIJzDpqol1bnlzD8pkr1uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRD6U/9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRD6U/9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18042C4CEF1;
	Tue, 16 Dec 2025 11:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886226;
	bh=75tKB7lwYifiKkw2xa4WthiRsArGbgB2fP35whytsWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRD6U/9owx+7tLofsPQxaYol3q+qBVAbWJfAY7dfzePmwkpfyNVjqpv0+92DO0VNY
	 bAqdxZKiQcu3mmT0th6A5Q43rChhlBhZDhUpcOsL0ucS9qOuO0hylW1+qqKfP9FKLb
	 QsM6n3JkIHtL3t8KTERdu9ri8sV4rjOW46fYax6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <rabenda.cn@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 374/507] of: Skip devicetree kunit tests when RISCV+ACPI doesnt populate root node
Date: Tue, 16 Dec 2025 12:13:35 +0100
Message-ID: <20251216111359.009722206@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



