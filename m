Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045873;
	b=lKGJE0n2DNgW+59ERUmXq7B2YOkpgirl2qn6w6+d0zyx6pyePqVD4GfzXl42+a4lFe0d
	 7CAL2gs1PG0YruNQI0oNLhCDoxWIQGXwUoO24JcnlTGjRdulZorP8yWARGekBsAoi8EDL
	 jXJJkaHT21cSO7RveRJ6fYQ9MXJllo2XWNPkXSBkp6qRzApcQMgos8lkvRCEYq2A+YL0S
	 0xvJda33XZ3UbLK0KQcaBTelRl0/1fzlOMvhT9sroM1eyJ2cnVIOD/Jcift8nsLQ8GLWx
	 a4U69Bas1Xl1lvBcKUQEBsrgh2huTN1pB06Buujh7SQq2nA3Mk1WltWRjSF6e1rXu2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wu+ZJr12nG0DXwqF5vhpRXVwIn3Yr7csxlotopvpu0I=;
	b=knH3bsJcbTSaGdbk4iYiZbEzNRab0P2pkV8NBbwcwiVBr8kBSTxv1M4X4Es2RYagvFUN
	 0T6Nh19sOec+7YIkKl7JDxRla8OoDXSRy7kGICqylRKT8F+IMCPJU1NxwUaoPVVRqSWNF
	 n8YGMq9GBKrJMGRITlOJL5MSQ6Zt7ufrOwH6pVViChubbce3As75PWuGCijyZG66cyKlQ
	 msE2W8QnDbp5lYcq75z+y6r1yDh2iNoQ9yL44pGriOFt0kBM7JzGr8hU7Km9ysnZxBJfR
	 oPRUboEqY0EjQop8T520GaaY11/QPMa+LfvUv0M0lis5N7qAkt++QSUg8IS2NqX8fZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sI8KjUD/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7874606A320;
	Wed, 18 Nov 2026 23:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sI8KjUD/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1895F1F000C4;
	Wed, 18 Nov 2026 23:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045873;
	bh=wu+ZJr12nG0DXwqF5vhpRXVwIn3Yr7csxlotopvpu0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sI8KjUD/SatFrBfDkxOJsRjZl3o0X3RYLgKUH5bpHd3jWHs21bsfUicFLEYIMuGg1
	 wu5RbeeS+hqcfpXkdp5Fj01nVeEjr6jDCh3NWD1eaE3tscDC11TiTUJqklbYmxitkv
	 irSVss31WXptI4XkApmAXu64uuWbjIMmrUok4DkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiale Yao <yaojiale02@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1072/2857] drm/amdkfd: validate SRAT subtables before parsing
Date: Wed, 18 Nov 2026 15:35:06 +0100
Message-ID: <20261118150240.206212005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 9866cb13ba4d39aa8fed34b765d4aecabe04f02e ]

The KFD SRAT walker reads the first subtable length without checking
that a header is present and trusts subsequent lengths when accessing
CPU and generic affinity records. Invalid firmware lengths can therefore
cause out-of-bounds reads.

Validate the table header, every generic subtable range, and each
supported typed record before reading its fields.

Fixes: ddec8d3be0f8 ("drm/amdkfd: add ACPI SRAT parsing for topology")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d76b655c98e8cc9e791b31502ad274f47dee2aae)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 35 ++++++++++++++++++---------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index 78a5119c86eca..3dde92eecd8ce 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1930,27 +1930,33 @@ static void kfd_find_numa_node_in_srat(struct kfd_dev *kdev)
 		return;
 	}
 
+	if (table_header->length < sizeof(struct acpi_table_srat))
+		goto invalid_srat;
+
 	table_end = (unsigned long)table_header + table_header->length;
 
 	/* Parse all entries looking for a match. */
 	sub_header = (struct acpi_subtable_header *)
 			((unsigned long)table_header +
 			sizeof(struct acpi_table_srat));
-	subtable_len = sub_header->length;
 
-	while (((unsigned long)sub_header) + subtable_len  < table_end) {
-		/*
-		 * If length is 0, break from this loop to avoid
-		 * infinite loop.
-		 */
-		if (subtable_len == 0) {
-			pr_err("SRAT invalid zero length\n");
-			break;
-		}
+	while ((unsigned long)sub_header < table_end) {
+		unsigned long start = (unsigned long)sub_header;
+
+		if (table_end - start < sizeof(*sub_header))
+			goto invalid_srat;
+
+		subtable_len = sub_header->length;
+		if (subtable_len < sizeof(*sub_header) ||
+		    subtable_len > table_end - start)
+			goto invalid_srat;
 
 		switch (sub_header->type) {
 		case ACPI_SRAT_TYPE_CPU_AFFINITY:
 			cpu = (struct acpi_srat_cpu_affinity *)sub_header;
+			if (subtable_len < sizeof(*cpu))
+				goto invalid_srat;
+
 			pxm = *((u32 *)cpu->proximity_domain_hi) << 8 |
 					cpu->proximity_domain_lo;
 			if (pxm > max_pxm)
@@ -1958,6 +1964,9 @@ static void kfd_find_numa_node_in_srat(struct kfd_dev *kdev)
 			break;
 		case ACPI_SRAT_TYPE_GENERIC_AFFINITY:
 			gpu = (struct acpi_srat_generic_affinity *)sub_header;
+			if (subtable_len < sizeof(*gpu))
+				goto invalid_srat;
+
 			bdf = *((u16 *)(&gpu->device_handle[0])) << 16 |
 					*((u16 *)(&gpu->device_handle[2]));
 			if (bdf == pci_id) {
@@ -1974,9 +1983,13 @@ static void kfd_find_numa_node_in_srat(struct kfd_dev *kdev)
 
 		sub_header = (struct acpi_subtable_header *)
 				((unsigned long)sub_header + subtable_len);
-		subtable_len = sub_header->length;
 	}
 
+	goto out;
+
+invalid_srat:
+	pr_err("SRAT contains an invalid subtable\n");
+out:
 	acpi_put_table(table_header);
 
 	/* Workaround bad cpu-gpu binding case */
-- 
2.53.0



