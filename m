Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12604C13D;
	Thu, 30 Jan 2025 14:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245694; cv=none; b=BV4NW6JLa/DCgeXM2MuT4qO80viwmPRrmo+M2DARFHZ3cXd63N06ZLaHdecIK2CA0SVkzQb3RXTkCP9CFWnPt/N/JnNdei1GYf6n3QYHNFNim7E3SWnmsmbGhcdIFwYCIxakTmiprZcfnh1uG1rmQVXHY1iN+mg1wdJGwRkuhFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245694; c=relaxed/simple;
	bh=JK6JNFn8feJa724BTXnezrDSb9Vt+tqK6uWGjjrIjH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g85hW6NYJzTp+ESLLuKijhV3HUna4mwDU9DR325RZ+sZyDHUl8hSNGncCxbJLoxPwatDKJcGH85PeahSqVVnQ0ih7DCDxS67k7UETkWVLSMwqzZFsORmwLpRiyW3iib0Z6wRjMVwP1dU4SlbaAhwKghB/wK3EDp/ve/vKHcQK2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzmBbBZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzmBbBZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA0DC4CED2;
	Thu, 30 Jan 2025 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245693;
	bh=JK6JNFn8feJa724BTXnezrDSb9Vt+tqK6uWGjjrIjH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzmBbBZGPACMOeRoScJccwcL5UBZoa3R8YgGRkVDD9Znt41HgfJp2DOY101KHSCRf
	 5rBH/KKCuKzMtBa+FvMD+8jjGaGA3qJbSQn+havGbiHShjQmWIPCKB7F7UckuZzcq8
	 N1mnBUpr1T5CKxV3NVM+HShEmTHtKred5nq2CgXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 09/40] of/unittest: Add test that of_address_to_resource() fails on non-translatable address
Date: Thu, 30 Jan 2025 14:59:09 +0100
Message-ID: <20250130133500.085480974@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 44748065ed321041db6e18cdcaa8c2a9554768ac ]

of_address_to_resource() on a non-translatable address should return an
error. Additionally, this case also triggers a spurious WARN for
missing #address-cells/#size-cells.

Link: https://lore.kernel.org/r/20250110215030.3637845-1-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest-data/tests-platform.dtsi | 13 +++++++++++++
 drivers/of/unittest.c                        | 14 ++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/of/unittest-data/tests-platform.dtsi b/drivers/of/unittest-data/tests-platform.dtsi
index fa39611071b32..cd310b26b50c8 100644
--- a/drivers/of/unittest-data/tests-platform.dtsi
+++ b/drivers/of/unittest-data/tests-platform.dtsi
@@ -34,5 +34,18 @@ dev@100 {
 				};
 			};
 		};
+
+		platform-tests-2 {
+			// No #address-cells or #size-cells
+			node {
+				#address-cells = <1>;
+				#size-cells = <1>;
+
+				test-device@100 {
+					compatible = "test-sub-device";
+					reg = <0x100 1>;
+				};
+			};
+		};
 	};
 };
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index daf9a2dddd7e0..576e9beefc7c8 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1342,6 +1342,7 @@ static void __init of_unittest_bus_3cell_ranges(void)
 static void __init of_unittest_reg(void)
 {
 	struct device_node *np;
+	struct resource res;
 	int ret;
 	u64 addr, size;
 
@@ -1358,6 +1359,19 @@ static void __init of_unittest_reg(void)
 		np, addr);
 
 	of_node_put(np);
+
+	np = of_find_node_by_path("/testcase-data/platform-tests-2/node/test-device@100");
+	if (!np) {
+		pr_err("missing testcase data\n");
+		return;
+	}
+
+	ret = of_address_to_resource(np, 0, &res);
+	unittest(ret == -EINVAL, "of_address_to_resource(%pOF) expected error on untranslatable address\n",
+		 np);
+
+	of_node_put(np);
+
 }
 
 struct of_unittest_expected_res {
-- 
2.39.5



