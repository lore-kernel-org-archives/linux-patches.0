Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAB420F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAE0C433C7;
	Fri, 21 Jul 2023 19:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967224;
	bh=G/HagFpMJipIOiLeSF9lgKr5W2UXZ6CWRY5iuj+Z9dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpmJo7YF8TEkHPREWqsDLBH1+HegrIobUiNASp4L/dn9J7jgv4S7sujJG/1nzNW3R
	 Mc+IH9tYBCybyJl6EDSfdQpJg13lfjG9kbrpI3kKcavlMXeDLXYVRV+CFaHcsaLmDJ
	 np0ZjI1FP9Ijtrnj5er5O8d6eCTLFycACYUrlwXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin David <valentin.david@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 088/223] tpm: Do not remap from ACPI resources again for Pluton TPM
Date: Fri, 21 Jul 2023 18:05:41 +0200
Message-ID: <20230721160524.613186613@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Valentin David <valentin.david@gmail.com>

commit b1c1b98962d17a922989aa3b2822946bbb5c091f upstream.

For Pluton TPM devices, it was assumed that there was no ACPI memory
regions. This is not true for ASUS ROG Ally. ACPI advertises
0xfd500000-0xfd5fffff.

Since remapping is already done in `crb_map_pluton`, remapping again
in `crb_map_io` causes EBUSY error:

[    3.510453] tpm_crb MSFT0101:00: can't request region for resource [mem 0xfd500000-0xfd5fffff]
[    3.510463] tpm_crb: probe of MSFT0101:00 failed with error -16

Cc: stable@vger.kernel.org # v6.3+
Fixes: 4d2732882703 ("tpm_crb: Add support for CRB devices based on Pluton")
Signed-off-by: Valentin David <valentin.david@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_crb.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index d43a0d7b97a8..1a5d09b18513 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -563,15 +563,18 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
 	u32 rsp_size;
 	int ret;
 
-	INIT_LIST_HEAD(&acpi_resource_list);
-	ret = acpi_dev_get_resources(device, &acpi_resource_list,
-				     crb_check_resource, iores_array);
-	if (ret < 0)
-		return ret;
-	acpi_dev_free_resource_list(&acpi_resource_list);
-
-	/* Pluton doesn't appear to define ACPI memory regions */
+	/*
+	 * Pluton sometimes does not define ACPI memory regions.
+	 * Mapping is then done in crb_map_pluton
+	 */
 	if (priv->sm != ACPI_TPM2_COMMAND_BUFFER_WITH_PLUTON) {
+		INIT_LIST_HEAD(&acpi_resource_list);
+		ret = acpi_dev_get_resources(device, &acpi_resource_list,
+					     crb_check_resource, iores_array);
+		if (ret < 0)
+			return ret;
+		acpi_dev_free_resource_list(&acpi_resource_list);
+
 		if (resource_type(iores_array) != IORESOURCE_MEM) {
 			dev_err(dev, FW_BUG "TPM2 ACPI table does not define a memory resource\n");
 			return -EINVAL;
-- 
2.41.0



