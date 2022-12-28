Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59161C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C61CC433D2;
	Wed, 28 Dec 2022 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243997;
	bh=D2nGL7fs+XPP1YjAsf8TRYWowaxa1PIxTxY2oyNpFV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBAwZStgjMR7Xuil5UBd9PbuslBUmOlDYzwqhJvq8fZtG4p91e7MIoSkJ+IePNlKY
	 mBi3b805HY/Noel0DjH7c980fnhqb4IEZUyu6C4Gu9Ydu5FpHvq0F1LSbvk9h68aLH
	 7I8S4PHXK0ov/XUhOI+kbpb5YM21QcQGDvols6xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <Sergey.Semin@baikalelectronics.ru>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0611/1073] dt-bindings: imx6q-pcie: Fix clock names for imx6sx and imx8mq
Date: Wed, 28 Dec 2022 15:36:39 +0100
Message-Id: <20221228144344.640953013@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit b8a83e600bdde93e7da41ea3204b2b3832a3c99b ]

Originally as it was defined the legacy bindings the pcie_inbound_axi and
pcie_aux clock names were supposed to be used in the fsl,imx6sx-pcie and
fsl,imx8mq-pcie devices respectively. But the bindings conversion has been
incorrectly so now the fourth clock name is defined as "pcie_inbound_axi
for imx6sx-pcie, pcie_aux for imx8mq-pcie", which is completely wrong.
Let's fix that by conditionally apply the clock-names constraints based on
the compatible string content.

Link: https://lore.kernel.org/r/20221113191301.5526-2-Sergey.Semin@baikalelectronics.ru
Fixes: 751ca492f131 ("dt-bindings: PCI: imx6: convert the imx pcie controller to dtschema")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/pci/fsl,imx6q-pcie.yaml          | 46 +++++++++++++++++--
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.yaml b/Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.yaml
index 376e739bcad4..49b4f7a32e71 100644
--- a/Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/fsl,imx6q-pcie.yaml
@@ -14,9 +14,6 @@ description: |+
   This PCIe host controller is based on the Synopsys DesignWare PCIe IP
   and thus inherits all the common properties defined in snps,dw-pcie.yaml.
 
-allOf:
-  - $ref: /schemas/pci/snps,dw-pcie.yaml#
-
 properties:
   compatible:
     enum:
@@ -61,7 +58,7 @@ properties:
       - const: pcie
       - const: pcie_bus
       - const: pcie_phy
-      - const: pcie_inbound_axi for imx6sx-pcie, pcie_aux for imx8mq-pcie
+      - enum: [ pcie_inbound_axi, pcie_aux ]
 
   num-lanes:
     const: 1
@@ -175,6 +172,47 @@ required:
   - clocks
   - clock-names
 
+allOf:
+  - $ref: /schemas/pci/snps,dw-pcie.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: fsl,imx6sx-pcie
+    then:
+      properties:
+        clock-names:
+          items:
+            - {}
+            - {}
+            - {}
+            - const: pcie_inbound_axi
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: fsl,imx8mq-pcie
+    then:
+      properties:
+        clock-names:
+          items:
+            - {}
+            - {}
+            - {}
+            - const: pcie_aux
+  - if:
+      properties:
+        compatible:
+          not:
+            contains:
+              enum:
+                - fsl,imx6sx-pcie
+                - fsl,imx8mq-pcie
+    then:
+      properties:
+        clock-names:
+          maxItems: 3
+
 unevaluatedProperties: false
 
 examples:
-- 
2.35.1



