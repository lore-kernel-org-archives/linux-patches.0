Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C135B136E2A;
	Wed,  3 Jul 2024 11:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004913; cv=none; b=HyGI1SA7G6TJssh3rlDnGSFuLvkhDNV23MK8XA6cF1J48FBCEs1zT0brBoDbhM7hh9N6jCf0I3QKB2UdCUrpzVncEL09Y0nn1/XWO16VJ2xaDNzfkqQuoXCpt0fM2ZvMqpnaxAGoEY4unaUhFnGs24akW5BPe/VjXGqai6gLV1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004913; c=relaxed/simple;
	bh=dq88UPTgs37jU4Y0kwRNi9Xfw5uTN9dMt8B6ieJCYYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqs3zpjdF2jhWx4PQuRw5VKXUM/WBdvhkUQ406bw7MXdqBC32sS1CVlMFSNmtmYtdZQwm8GHHiMTM8W6Qu228qJSKV+rKz03lKqtuBLoSkdchlyQcPRpOOxNycMoLfWqGzbILQMTTnw27s8Bad+FAwlidvGg2oamlD9L9NAbWyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gfym+0lx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gfym+0lx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AA0C2BD10;
	Wed,  3 Jul 2024 11:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004913;
	bh=dq88UPTgs37jU4Y0kwRNi9Xfw5uTN9dMt8B6ieJCYYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gfym+0lxH8oKcTPkquQWoG777VGmAljizAKUmjTWlTgtHf0hhNrJMBkEB19vXRKDO
	 Tqc/Z1De4DqzZ+WY7eT4i6pEf+Ix2f75BMfGCe/4e1j+TUmMOpPkBuThDVFa+VLore
	 ZEXk2R4SSXvUIEWJptcUkzz83/85QBsvUkJa7/KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Luya Tshimbalanga <luya@fedoraproject.org>
Subject: [PATCH 5.10 199/290] ACPI: x86: Add a quirk for Dell Inspiron 14 2-in-1 for StorageD3Enable
Date: Wed,  3 Jul 2024 12:39:40 +0200
Message-ID: <20240703102911.680694639@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 018d6711c26e4bd26e20a819fcc7f8ab902608f3 ]

Dell Inspiron 14 2-in-1 has two ACPI nodes under GPP1 both with _ADR of
0, both without _HID.  It's ambiguous which the kernel should take, but
it seems to take "DEV0".  Unfortunately "DEV0" is missing the device
property `StorageD3Enable` which is present on "NVME".

To avoid this causing problems for suspend, add a quirk for this system
to behave like `StorageD3Enable` property was found.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216440
Reported-and-tested-by: Luya Tshimbalanga <luya@fedoraproject.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: e79a10652bbd ("ACPI: x86: Force StorageD3Enable on more products")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index b3fb428461c6f..3a3f09b6cbfc9 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -198,7 +198,24 @@ static const struct x86_cpu_id storage_d3_cpu_ids[] = {
 	{}
 };
 
+static const struct dmi_system_id force_storage_d3_dmi[] = {
+	{
+		/*
+		 * _ADR is ambiguous between GPP1.DEV0 and GPP1.NVME
+		 * but .NVME is needed to get StorageD3Enable node
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=216440
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 14 7425 2-in-1"),
+		}
+	},
+	{}
+};
+
 bool force_storage_d3(void)
 {
-	return x86_match_cpu(storage_d3_cpu_ids);
+	const struct dmi_system_id *dmi_id = dmi_first_match(force_storage_d3_dmi);
+
+	return dmi_id || x86_match_cpu(storage_d3_cpu_ids);
 }
-- 
2.43.0



