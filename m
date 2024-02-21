Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83F578B4B;
	Wed, 21 Feb 2024 13:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521582; cv=none; b=bsKMCO2eX/GtA8+1GuwLsjkkyxVscuXokFknI/OFcAbajpu8iP+oCNnVXFCHyd53LUXjNU0aztAApfOnsLPPKV+gGNsx9abyfdgQVneNiDfpKf6FoAA9veNPi65W+o8P/d8B1euPzzsWJRli7s39VgHqS1huy4tHM94+2ftnUKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521582; c=relaxed/simple;
	bh=I7aMRVhFtrnVT2TNbbG/fwU9vQm6G0K12auf8aaYgXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAL6YCWUIh3k/R38m+UjQdPIGc56zPp55FvLuprHRtv54PQPfpEbHrJ31Zm0M1dzHxFxdwKQtIlef1wlc1sx7t6odkc0TmiHpr0+XcCwNpfDx+ed/+3BzpSrymPLMHhGbcyYtlq+DL76w8rP9Tu3+9b1D1yiqW1VI1t9LtPZMG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ypy1DKlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ypy1DKlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302CDC433F1;
	Wed, 21 Feb 2024 13:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521582;
	bh=I7aMRVhFtrnVT2TNbbG/fwU9vQm6G0K12auf8aaYgXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ypy1DKluS+vlrIZkotTGmtrid7w9uOG+ynM4kLAE7domo3oBMPFuhf+W6ylC71C7T
	 u0XEsLh6IUIKwcEHQT0dCviPEz6f9N6kMTe7302osDvhDyAV3VdhOawe4ofDVczuBF
	 +l0tAcz1qorghNk2yQtKWadUT/ip/7pLpvMXAKRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/202] hwmon: (coretemp) Fix bogus core_id to attr name mapping
Date: Wed, 21 Feb 2024 14:07:32 +0100
Message-ID: <20240221125936.575975679@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit fdaf0c8629d4524a168cb9e4ad4231875749b28c ]

Before commit 7108b80a542b ("hwmon/coretemp: Handle large core ID
value"), there is a fixed mapping between
1. cpu_core_id
2. the index in pdata->core_data[] array
3. the sysfs attr name, aka "tempX_"
The later two always equal cpu_core_id + 2.

After the commit, pdata->core_data[] index is got from ida so that it
can handle sparse core ids and support more cores within a package.

However, the commit erroneously maps the sysfs attr name to
pdata->core_data[] index instead of cpu_core_id + 2.

As a result, the code is not aligned with the comments, and brings user
visible changes in hwmon sysfs on systems with sparse core id.

For example, before commit 7108b80a542b ("hwmon/coretemp: Handle large
core ID value"),
/sys/class/hwmon/hwmon2/temp2_label:Core 0
/sys/class/hwmon/hwmon2/temp3_label:Core 1
/sys/class/hwmon/hwmon2/temp4_label:Core 2
/sys/class/hwmon/hwmon2/temp5_label:Core 3
/sys/class/hwmon/hwmon2/temp6_label:Core 4
/sys/class/hwmon/hwmon3/temp10_label:Core 8
/sys/class/hwmon/hwmon3/temp11_label:Core 9
after commit,
/sys/class/hwmon/hwmon2/temp2_label:Core 0
/sys/class/hwmon/hwmon2/temp3_label:Core 1
/sys/class/hwmon/hwmon2/temp4_label:Core 2
/sys/class/hwmon/hwmon2/temp5_label:Core 3
/sys/class/hwmon/hwmon2/temp6_label:Core 4
/sys/class/hwmon/hwmon2/temp7_label:Core 8
/sys/class/hwmon/hwmon2/temp8_label:Core 9

Restore the previous behavior and rework the code, comments and variable
names to avoid future confusions.

Fixes: 7108b80a542b ("hwmon/coretemp: Handle large core ID value")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Link: https://lore.kernel.org/r/20240202092144.71180-3-rui.zhang@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 6832569c9bac..d06e88477588 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -393,7 +393,7 @@ static int get_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 }
 
 static int create_core_attrs(struct temp_data *tdata, struct device *dev,
-			     int attr_no)
+			     int index)
 {
 	int i;
 	static ssize_t (*const rd_ptr[TOTAL_ATTRS]) (struct device *dev,
@@ -405,13 +405,20 @@ static int create_core_attrs(struct temp_data *tdata, struct device *dev,
 	};
 
 	for (i = 0; i < tdata->attr_size; i++) {
+		/*
+		 * We map the attr number to core id of the CPU
+		 * The attr number is always core id + 2
+		 * The Pkgtemp will always show up as temp1_*, if available
+		 */
+		int attr_no = tdata->is_pkg_data ? 1 : tdata->cpu_core_id + 2;
+
 		snprintf(tdata->attr_name[i], CORETEMP_NAME_LENGTH,
 			 "temp%d_%s", attr_no, suffixes[i]);
 		sysfs_attr_init(&tdata->sd_attrs[i].dev_attr.attr);
 		tdata->sd_attrs[i].dev_attr.attr.name = tdata->attr_name[i];
 		tdata->sd_attrs[i].dev_attr.attr.mode = S_IRUGO;
 		tdata->sd_attrs[i].dev_attr.show = rd_ptr[i];
-		tdata->sd_attrs[i].index = attr_no;
+		tdata->sd_attrs[i].index = index;
 		tdata->attrs[i] = &tdata->sd_attrs[i].dev_attr.attr;
 	}
 	tdata->attr_group.attrs = tdata->attrs;
@@ -469,23 +476,22 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	struct platform_data *pdata = platform_get_drvdata(pdev);
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 eax, edx;
-	int err, index, attr_no;
+	int err, index;
 
 	/*
-	 * Find attr number for sysfs:
-	 * We map the attr number to core id of the CPU
-	 * The attr number is always core id + 2
-	 * The Pkgtemp will always show up as temp1_*, if available
+	 * Get the index of tdata in pdata->core_data[]
+	 * tdata for package: pdata->core_data[1]
+	 * tdata for core: pdata->core_data[2] .. pdata->core_data[NUM_REAL_CORES + 1]
 	 */
 	if (pkg_flag) {
-		attr_no = PKG_SYSFS_ATTR_NO;
+		index = PKG_SYSFS_ATTR_NO;
 	} else {
 		index = ida_alloc_max(&pdata->ida, NUM_REAL_CORES - 1, GFP_KERNEL);
 		if (index < 0)
 			return index;
 
 		pdata->cpu_map[index] = topology_core_id(cpu);
-		attr_no = index + BASE_SYSFS_ATTR_NO;
+		index += BASE_SYSFS_ATTR_NO;
 	}
 
 	tdata = init_temp_data(cpu, pkg_flag);
@@ -517,20 +523,20 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 		}
 	}
 
-	pdata->core_data[attr_no] = tdata;
+	pdata->core_data[index] = tdata;
 
 	/* Create sysfs interfaces */
-	err = create_core_attrs(tdata, pdata->hwmon_dev, attr_no);
+	err = create_core_attrs(tdata, pdata->hwmon_dev, index);
 	if (err)
 		goto exit_free;
 
 	return 0;
 exit_free:
-	pdata->core_data[attr_no] = NULL;
+	pdata->core_data[index] = NULL;
 	kfree(tdata);
 ida_free:
 	if (!pkg_flag)
-		ida_free(&pdata->ida, index);
+		ida_free(&pdata->ida, index - BASE_SYSFS_ATTR_NO);
 	return err;
 }
 
-- 
2.43.0



