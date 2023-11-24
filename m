Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174D02E621;
	Fri, 24 Nov 2023 18:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCLf5vAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CB0C433C8;
	Fri, 24 Nov 2023 18:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850817;
	bh=iagWXwayRQGSU6JhYdch3FlZvR+v4rdGJphssj6XX28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCLf5vApunkv/YyuZuc2Do3IULqZAUi63s7uk8lrfAeQUfTDjjQsFYs0XvgUOEk+8
	 9bc9FotZ7eLfuxvfwgzLbANEGecQf04iPipRB9w6sFj1omFLxdlc7NEStlT8VtJap9
	 xkWQlblB+jB+zI40b6AtWmkRhyTKmUGdH4nG5UGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 201/491] pds_core: fix up some format-truncation complaints
Date: Fri, 24 Nov 2023 17:47:17 +0000
Message-ID: <20231124172030.542720020@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 7c02f6ae676a954216a192612040f9a0cde3adf7 ]

Our friendly kernel test robot pointed out a couple of potential
string truncation issues.  None of which were we worried about,
but can be relatively easily fixed to quiet the complaints.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310211736.66syyDpp-lkp@intel.com/
Fixes: 45d76f492938 ("pds_core: set up device and adminq")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20231113183257.71110-3-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.h    | 2 +-
 drivers/net/ethernet/amd/pds_core/dev.c     | 8 ++++++--
 drivers/net/ethernet/amd/pds_core/devlink.c | 2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index e545fafc48196..b1c1f1007b065 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -15,7 +15,7 @@
 #define PDSC_DRV_DESCRIPTION	"AMD/Pensando Core Driver"
 
 #define PDSC_WATCHDOG_SECS	5
-#define PDSC_QUEUE_NAME_MAX_SZ  32
+#define PDSC_QUEUE_NAME_MAX_SZ  16
 #define PDSC_ADMINQ_MIN_LENGTH	16	/* must be a power of two */
 #define PDSC_NOTIFYQ_LENGTH	64	/* must be a power of two */
 #define PDSC_TEARDOWN_RECOVERY	false
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index f77cd9f5a2fda..eb178728edba9 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -254,10 +254,14 @@ static int pdsc_identify(struct pdsc *pdsc)
 	struct pds_core_drv_identity drv = {};
 	size_t sz;
 	int err;
+	int n;
 
 	drv.drv_type = cpu_to_le32(PDS_DRIVER_LINUX);
-	snprintf(drv.driver_ver_str, sizeof(drv.driver_ver_str),
-		 "%s %s", PDS_CORE_DRV_NAME, utsname()->release);
+	/* Catching the return quiets a Wformat-truncation complaint */
+	n = snprintf(drv.driver_ver_str, sizeof(drv.driver_ver_str),
+		     "%s %s", PDS_CORE_DRV_NAME, utsname()->release);
+	if (n > sizeof(drv.driver_ver_str))
+		dev_dbg(pdsc->dev, "release name truncated, don't care\n");
 
 	/* Next let's get some info about the device
 	 * We use the devcmd_lock at this level in order to
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index d9607033bbf21..d2abf32b93fe3 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -104,7 +104,7 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	struct pds_core_fw_list_info fw_list;
 	struct pdsc *pdsc = devlink_priv(dl);
 	union pds_core_dev_comp comp;
-	char buf[16];
+	char buf[32];
 	int listlen;
 	int err;
 	int i;
-- 
2.42.0



