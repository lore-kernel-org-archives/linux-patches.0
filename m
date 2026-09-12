Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709C737204A;
	Sat, 12 Sep 2026 07:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197121; cv=none; b=SswmCof8gzKvK9xNLVeo+Rl8RHLu7vWtGieX3Y/RSe/sbv4IXW/Xo08xqfHYzkcpr3fOqoJXGi3dS69/QQJrIhjqM1UPmtDFD8VS4u0mBU9nxeeqObzpjAbrEzy9AMT+HDaQcqeABEYILs7Lxl1ql8e0d2N0qWLbzWwgo6b2ryQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197121; c=relaxed/simple;
	bh=4MvahwS5TaIiLcD49WM/KQ9GgONniLqrSP9iwoDDC2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtLJReJZDE27OpeChLbADfxNQ9lXyrKn6ZBhNwZJv+oI/UgO2uzntIhLD8XchS15ZxA37c3LCL/+6oxD/ChXjVH0eHn+GMg99Mhu1VOkbTA8oQzLMkfS8oJWZJkSpcFJywjY2xELXtCu9xhtTX5EMRhFdwJaHJioAGlx9BCC9tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vfpvo4Ik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vfpvo4Ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DCE1F000FF;
	Sat, 12 Sep 2026 07:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197120;
	bh=7B/bL1EYaDub+ZNL/7sUWTdmgQ7yJYelxboCX1K5HKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vfpvo4IkV9ka8QhGI2HCiOE5MGU68/ivYEmdzRzZkIQmyZcD3mS8UFU6Jc+R7MJGO
	 KNLmZ+CQBlykGQCmqJtfkUBuBz4X8CZ3zlgzjW9oyMS0XFOGsNpDwX49mtpGOTc83x
	 QyGfMRoG+Tk7wdwj5fDabZDNOk4/X/MeH2KTOy/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0106/1815] perf/x86/intel/uncore: Factor out box setup code
Date: Sat, 12 Sep 2026 08:30:56 +0200
Message-ID: <20260912065651.495479400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit ae7ca8796ddac708db592c5a68555414c451afcc ]

The PCI uncore PMU path already implements a lazy registration model:
the PMU is registered when the first active box appears and
unregistered when the last active box is removed.

Factor this registration management into a shared helper, so the same
code can be reused by the MSR and MMIO paths in later changes.

No functional change intended.

Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260611160033.66760-6-zide.chen@intel.com
Stable-dep-of: 174f0582e38a ("perf/x86/intel/uncore: Fix uncore_box ref/unref ordering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 40 ++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index eae335df7634e..06ef89f6ccc28 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1148,6 +1148,29 @@ uncore_pci_find_dev_pmu(struct pci_dev *pdev, const struct pci_device_id *ids)
 	return pmu;
 }
 
+static int uncore_box_setup(struct intel_uncore_pmu *pmu,
+			    struct intel_uncore_box *box)
+{
+	int ret;
+
+	uncore_box_init(box);
+
+	/* First active box registers the pmu. */
+	if (atomic_inc_return(&pmu->activeboxes) > 1)
+		return 0;
+
+	ret = uncore_pmu_register(pmu);
+	if (ret) {
+		atomic_dec(&pmu->activeboxes);
+		goto err;
+	}
+
+	return 0;
+err:
+	uncore_box_exit(box);
+	return ret;
+}
+
 /*
  * Register the PMU for a PCI device
  * @pdev: The PCI device.
@@ -1174,20 +1197,13 @@ static int uncore_pci_pmu_register(struct pci_dev *pdev,
 	box->dieid = die;
 	box->pci_dev = pdev;
 	box->pmu = pmu;
-	uncore_box_init(box);
 
-	pmu->boxes[die] = box;
-	if (atomic_inc_return(&pmu->activeboxes) > 1)
-		return 0;
-
-	/* First active box registers the pmu */
-	ret = uncore_pmu_register(pmu);
-	if (ret) {
-		atomic_dec(&pmu->activeboxes);
-		pmu->boxes[die] = NULL;
-		uncore_box_exit(box);
+	ret = uncore_box_setup(pmu, box);
+	if (!ret)
+		pmu->boxes[die] = box;
+	else
 		kfree(box);
-	}
+
 	return ret;
 }
 
-- 
2.53.0



