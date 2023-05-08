Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7BE168A2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDC6C4339B;
	Mon,  8 May 2023 10:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541954;
	bh=MXOSj8FDK+cq8x1skx99yF12oRJ+1ZAw+RA86ASI2xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0p5DAtuSL1j+Y2pHgElELDofZx8G1LqdRANAr9xX+1cMCJNLNlEW/3uK8kYZKveaV
	 ajKOcRgG8bp5+aaQ+ciAvNEAClwLwUqGAIk6pJQ5b40SH2pKVM81QCnTnRBbKBU8uZ
	 wR3uAVNDJGZfZs/Zi3o4Gojp3pztLSrjHNIP46MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 248/663] platform/x86/amd: pmc: Hide SMU version and program attributes for Picasso
Date: Mon,  8 May 2023 11:41:14 +0200
Message-Id: <20230508094436.310778668@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 5ec9ee0d464750d72972d5685edf675824e259a1 ]

As the command to get version isn't supported on Picasso, we shouldn't
be exposing this into sysfs either.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2449
Fixes: 7f1ea75d499a ("platform/x86/amd: pmc: Add sysfs files for SMU")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230409185348.556161-3-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 0553a6419bb90..bc8397635428e 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -426,12 +426,31 @@ static ssize_t smu_program_show(struct device *d, struct device_attribute *attr,
 static DEVICE_ATTR_RO(smu_fw_version);
 static DEVICE_ATTR_RO(smu_program);
 
+static umode_t pmc_attr_is_visible(struct kobject *kobj, struct attribute *attr, int idx)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct amd_pmc_dev *pdev = dev_get_drvdata(dev);
+
+	if (pdev->cpu_id == AMD_CPU_ID_PCO)
+		return 0;
+	return 0444;
+}
+
 static struct attribute *pmc_attrs[] = {
 	&dev_attr_smu_fw_version.attr,
 	&dev_attr_smu_program.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(pmc);
+
+static struct attribute_group pmc_attr_group = {
+	.attrs = pmc_attrs,
+	.is_visible = pmc_attr_is_visible,
+};
+
+static const struct attribute_group *pmc_groups[] = {
+	&pmc_attr_group,
+	NULL,
+};
 
 static int smu_fw_info_show(struct seq_file *s, void *unused)
 {
-- 
2.39.2



