Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47B5168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C966C433D2;
	Mon,  8 May 2023 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544058;
	bh=gUIDdmJlp75RonbBQjmk3e7J+NXMyHru4lVuTYIIG6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNIFI8u1V84DylPeZ0+L4EmcYqtOQ+T16wHMeTONewy3Cqx6QPJ3eimUPaxpUgNOM
	 4lrF7pnwT2fM5YAx03XX78LPLZH3Ut1Ch4UKWcIbsHN0x5GKLtPX1l6qfBELfM9rnu
	 NEaXbqzy+Sy1he2TDSpLMD5LhX8Aq7SC9Hw1eVmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 289/694] platform/x86/amd: pmc: Hide SMU version and program attributes for Picasso
Date: Mon,  8 May 2023 11:42:04 +0200
Message-Id: <20230508094441.667034307@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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
index 4ffb08d2b01bc..6aa10192a3f3b 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -452,12 +452,31 @@ static ssize_t smu_program_show(struct device *d, struct device_attribute *attr,
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



