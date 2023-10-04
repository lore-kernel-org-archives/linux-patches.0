Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F6D21356
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nT5Rc0sO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DDCC433C7;
	Wed,  4 Oct 2023 18:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444377;
	bh=uDvMZHUnvrozPEnuZS3iyiT0yo7aZNRlWdRMzIYTEbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nT5Rc0sO8bHg3WjPcZywdN+379ZYdTvUB0VCCu9ygnGxsYtEUWcRUK7fGy1SXQUN5
	 McN9A2Qv8H9HKnlG93sB3Yyz8vEeAI4TSRuzoSHZvy5miHd/jQ9p3vUWSEXrTEk1HH
	 mpNHqpi/9e3O41BdrNe9R57ta/ZhoA+pKOqBIznk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 211/321] ALSA: hda: intel-sdw-acpi: Use u8 type for link index
Date: Wed,  4 Oct 2023 19:55:56 +0200
Message-ID: <20231004175239.028920351@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 485ddd519fbd89a9d9ac4b02be489e03cbbeebba ]

Use consistently u8 for sdw link index. The id is limited to 4, u8 is
adequate in size to store it.

This change will also fixes the following compiler warning/error (W=1):

sound/hda/intel-sdw-acpi.c: In function ‘sdw_intel_acpi_scan’:
sound/hda/intel-sdw-acpi.c:34:35: error: ‘-subproperties’ directive output may be truncated writing 14 bytes into a region of size between 7 and 17 [-Werror=format-truncation=]
   34 |                  "mipi-sdw-link-%d-subproperties", i);
      |                                   ^~~~~~~~~~~~~~
In function ‘is_link_enabled’,
    inlined from ‘sdw_intel_scan_controller’ at sound/hda/intel-sdw-acpi.c:106:8,
    inlined from ‘sdw_intel_acpi_scan’ at sound/hda/intel-sdw-acpi.c:180:9:
sound/hda/intel-sdw-acpi.c:33:9: note: ‘snprintf’ output between 30 and 40 bytes into a destination of size 32
   33 |         snprintf(name, sizeof(name),
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   34 |                  "mipi-sdw-link-%d-subproperties", i);
      |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

The warnings got brought to light by a recent patch upstream:
commit 6d4ab2e97dcf ("extrawarn: enable format and stringop overflow warnings in W=1")

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230912162617.29178-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-sdw-acpi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/hda/intel-sdw-acpi.c b/sound/hda/intel-sdw-acpi.c
index 5cb92f7ccbcac..b57d72ea4503f 100644
--- a/sound/hda/intel-sdw-acpi.c
+++ b/sound/hda/intel-sdw-acpi.c
@@ -23,7 +23,7 @@ static int ctrl_link_mask;
 module_param_named(sdw_link_mask, ctrl_link_mask, int, 0444);
 MODULE_PARM_DESC(sdw_link_mask, "Intel link mask (one bit per link)");
 
-static bool is_link_enabled(struct fwnode_handle *fw_node, int i)
+static bool is_link_enabled(struct fwnode_handle *fw_node, u8 idx)
 {
 	struct fwnode_handle *link;
 	char name[32];
@@ -31,7 +31,7 @@ static bool is_link_enabled(struct fwnode_handle *fw_node, int i)
 
 	/* Find master handle */
 	snprintf(name, sizeof(name),
-		 "mipi-sdw-link-%d-subproperties", i);
+		 "mipi-sdw-link-%hhu-subproperties", idx);
 
 	link = fwnode_get_named_child_node(fw_node, name);
 	if (!link)
@@ -51,8 +51,8 @@ static int
 sdw_intel_scan_controller(struct sdw_intel_acpi_info *info)
 {
 	struct acpi_device *adev = acpi_fetch_acpi_dev(info->handle);
-	int ret, i;
-	u8 count;
+	u8 count, i;
+	int ret;
 
 	if (!adev)
 		return -EINVAL;
-- 
2.40.1



