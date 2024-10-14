Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956193A1B6;
	Mon, 14 Oct 2024 15:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919070; cv=none; b=lMvVR9Djzly96y29CdXC2Ym8S4PTvaHkqwSXj3fQgcyu3FevmQrz+pM95GBZ4yycnAp/HR6uckE2N0JFHkdyAxYIkuwzp9M0V9cP4Mtog3K8j074bUcPNGz7FGfZoqPrPSntWXFgXaAjIYikCFV90IQlR8iTUJ1lPkjlZFxsW7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919070; c=relaxed/simple;
	bh=Gzf2hbvJgABFhaphtbMhidaom1Gm22Q4WF4VOp7ejEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuOsWofnQvQx4UAXWgKe2CAu14B5WoKmb4+tNQrQdT+0GEaNMX0FYIt3LtBSUIxSN8g04G6SvjlqIkfDDzFnk4hbkHoEKX9EEEPQZQVFpoXfUBWaZoD5TwvCOiLjHvh/vP2RzDs2jjpDZ7DtlnHbo7nqRKP2TQhvgEEe0430Exs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1UGaEU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1UGaEU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073A4C4CEC3;
	Mon, 14 Oct 2024 15:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919070;
	bh=Gzf2hbvJgABFhaphtbMhidaom1Gm22Q4WF4VOp7ejEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1UGaEU2NUAs0Y4lJWUH2C5dPgKLX7JyI+/E2bx73a2vpTnVMYUhjElEZtsHZMAYm
	 viX1qLlv1B9XTnfJBVnFYGS1AFwuoCJobSEDXwsIrMoCwSMapzaM7D93xnKex1tnni
	 u+PMLSE7ZgJN5MtBDTl1xhP39reqz7WgPxftsots=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 505/798] powerpc/pseries: Use correct data types from pseries_hp_errorlog struct
Date: Mon, 14 Oct 2024 16:17:39 +0200
Message-ID: <20241014141237.821835249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haren Myneni <haren@linux.ibm.com>

[ Upstream commit b76e0d4215b6b622127ebcceaa7f603313ceaec4 ]

_be32 type is defined for some elements in pseries_hp_errorlog
struct but also used them u32 after be32_to_cpu() conversion.

Example: In handle_dlpar_errorlog()
hp_elog->_drc_u.drc_index = be32_to_cpu(hp_elog->_drc_u.drc_index);

And later assigned to u32 type
dlpar_cpu() - u32 drc_index = hp_elog->_drc_u.drc_index;

This incorrect usage is giving the following warnings and the
patch resolve these warnings with the correct assignment.

arch/powerpc/platforms/pseries/dlpar.c:398:53: sparse: sparse:
incorrect type in argument 1 (different base types) @@
expected unsigned int [usertype] drc_index @@
got restricted __be32 [usertype] drc_index @@
...
arch/powerpc/platforms/pseries/dlpar.c:418:43: sparse: sparse:
incorrect type in assignment (different base types) @@
expected restricted __be32 [usertype] drc_count @@
got unsigned int [usertype] @@

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408182142.wuIKqYae-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202408182302.o7QRO45S-lkp@intel.com/
Signed-off-by: Haren Myneni <haren@linux.ibm.com>

v3:
- Fix warnings from using incorrect data types in pseries_hp_errorlog
  struct
v2:
- Remove pr_info() and TODO comments
- Update more information in the commit logs

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240822025028.938332-1-haren@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/dlpar.c          | 17 -----------------
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |  2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c | 16 ++++++++--------
 arch/powerpc/platforms/pseries/pmem.c           |  2 +-
 4 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 498d6efcb5ae7..a78f5e1685d27 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -343,23 +343,6 @@ int handle_dlpar_errorlog(struct pseries_hp_errorlog *hp_elog)
 {
 	int rc;
 
-	/* pseries error logs are in BE format, convert to cpu type */
-	switch (hp_elog->id_type) {
-	case PSERIES_HP_ELOG_ID_DRC_COUNT:
-		hp_elog->_drc_u.drc_count =
-				be32_to_cpu(hp_elog->_drc_u.drc_count);
-		break;
-	case PSERIES_HP_ELOG_ID_DRC_INDEX:
-		hp_elog->_drc_u.drc_index =
-				be32_to_cpu(hp_elog->_drc_u.drc_index);
-		break;
-	case PSERIES_HP_ELOG_ID_DRC_IC:
-		hp_elog->_drc_u.ic.count =
-				be32_to_cpu(hp_elog->_drc_u.ic.count);
-		hp_elog->_drc_u.ic.index =
-				be32_to_cpu(hp_elog->_drc_u.ic.index);
-	}
-
 	switch (hp_elog->resource) {
 	case PSERIES_HP_ELOG_RESOURCE_MEM:
 		rc = dlpar_memory(hp_elog);
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index e0a7ac5db15d9..12a6d154f4b4b 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -748,7 +748,7 @@ int dlpar_cpu(struct pseries_hp_errorlog *hp_elog)
 	u32 drc_index;
 	int rc;
 
-	drc_index = hp_elog->_drc_u.drc_index;
+	drc_index = be32_to_cpu(hp_elog->_drc_u.drc_index);
 
 	lock_device_hotplug();
 
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 051a777ba1b27..dbb25d347fce8 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -876,16 +876,16 @@ int dlpar_memory(struct pseries_hp_errorlog *hp_elog)
 	case PSERIES_HP_ELOG_ACTION_ADD:
 		switch (hp_elog->id_type) {
 		case PSERIES_HP_ELOG_ID_DRC_COUNT:
-			count = hp_elog->_drc_u.drc_count;
+			count = be32_to_cpu(hp_elog->_drc_u.drc_count);
 			rc = dlpar_memory_add_by_count(count);
 			break;
 		case PSERIES_HP_ELOG_ID_DRC_INDEX:
-			drc_index = hp_elog->_drc_u.drc_index;
+			drc_index = be32_to_cpu(hp_elog->_drc_u.drc_index);
 			rc = dlpar_memory_add_by_index(drc_index);
 			break;
 		case PSERIES_HP_ELOG_ID_DRC_IC:
-			count = hp_elog->_drc_u.ic.count;
-			drc_index = hp_elog->_drc_u.ic.index;
+			count = be32_to_cpu(hp_elog->_drc_u.ic.count);
+			drc_index = be32_to_cpu(hp_elog->_drc_u.ic.index);
 			rc = dlpar_memory_add_by_ic(count, drc_index);
 			break;
 		default:
@@ -897,16 +897,16 @@ int dlpar_memory(struct pseries_hp_errorlog *hp_elog)
 	case PSERIES_HP_ELOG_ACTION_REMOVE:
 		switch (hp_elog->id_type) {
 		case PSERIES_HP_ELOG_ID_DRC_COUNT:
-			count = hp_elog->_drc_u.drc_count;
+			count = be32_to_cpu(hp_elog->_drc_u.drc_count);
 			rc = dlpar_memory_remove_by_count(count);
 			break;
 		case PSERIES_HP_ELOG_ID_DRC_INDEX:
-			drc_index = hp_elog->_drc_u.drc_index;
+			drc_index = be32_to_cpu(hp_elog->_drc_u.drc_index);
 			rc = dlpar_memory_remove_by_index(drc_index);
 			break;
 		case PSERIES_HP_ELOG_ID_DRC_IC:
-			count = hp_elog->_drc_u.ic.count;
-			drc_index = hp_elog->_drc_u.ic.index;
+			count = be32_to_cpu(hp_elog->_drc_u.ic.count);
+			drc_index = be32_to_cpu(hp_elog->_drc_u.ic.index);
 			rc = dlpar_memory_remove_by_ic(count, drc_index);
 			break;
 		default:
diff --git a/arch/powerpc/platforms/pseries/pmem.c b/arch/powerpc/platforms/pseries/pmem.c
index 3c290b9ed01b3..0f1d45f32e4a4 100644
--- a/arch/powerpc/platforms/pseries/pmem.c
+++ b/arch/powerpc/platforms/pseries/pmem.c
@@ -121,7 +121,7 @@ int dlpar_hp_pmem(struct pseries_hp_errorlog *hp_elog)
 		return -EINVAL;
 	}
 
-	drc_index = hp_elog->_drc_u.drc_index;
+	drc_index = be32_to_cpu(hp_elog->_drc_u.drc_index);
 
 	lock_device_hotplug();
 
-- 
2.43.0



