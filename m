Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D230233B966;
	Tue, 16 Dec 2025 11:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884723; cv=none; b=sP9iXLWglr2cEoIJfmo12dalpkmeX4oIKMRF0Oc8z/6jZ2oP4z95mzytZBY3XzXJ+9QcwzOviEnG0MWsMI5HfgDsRSA3Rnul/FclbmJ4nmVF/MkO4Xk4DvflawsKmX9zRQh0UuLSlVh2+K9QBl1+7rWF0Ry5LnKLY2B3DAATU9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884723; c=relaxed/simple;
	bh=oZMsFywdm7Ky51yN+lojpxOJlkAuff19+mDOSG8QVrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2xaEdZEz/MX6M/YzTWMDTHx6K8LVEl0XRld5jExSryGgX8GoSdIABXEhkA9BJSBZmjt6LN7KO47vnm8ck/aISuNTmd5anLtOUPGIROzb4f2UbeCGPlerZzHvZhjhdGHLiA72QqbB4SKSFmJxM2ihRSDrdRism0UAdtLaOnQzL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5XwQ3iz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5XwQ3iz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F56FC4CEF1;
	Tue, 16 Dec 2025 11:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884723;
	bh=oZMsFywdm7Ky51yN+lojpxOJlkAuff19+mDOSG8QVrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5XwQ3izuQGK25pV1QdoACj5vHnOEPgHZwlkFbd+3KntMY64HHAM/DgRjzwEoR1Sg
	 nXw+ypUoOqE1+Lvi2Pjp4DUGgYl9XsdWFJJDS/EIpRbIUZ7EeWoSX31yaDhbnSMShA
	 f5YbWwBVxU00UuSea+Kth8/AQ3UTONow8fcnMSiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <rabenda.cn@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/354] of: Skip devicetree kunit tests when RISCV+ACPI doesnt populate root node
Date: Tue, 16 Dec 2025 12:13:33 +0100
Message-ID: <20251216111329.825669578@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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



