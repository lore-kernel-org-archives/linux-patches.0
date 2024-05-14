Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C135984A46;
	Tue, 14 May 2024 11:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686133; cv=none; b=MUW1fHoKsTMkpcXeDErWikv7Wj49awIYm49a6vCRrJoxQqSRgKRXstANO1cBU5lmbPBMQXEQ/0W3QtFDDpKYnZeknTrJudvRqIhc/EzFl/zJZKlUkXNL8Nk6Bg0Ws+2NJg5v+4/PHuzuIRjPFaUomfEX/VhM4eYNYCi+UC9aSFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686133; c=relaxed/simple;
	bh=Sn2YEJpI4uVSXE996F1SOgr0CPfJ9bksY8SFSkq+/9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4KC+QcgDOc6tpzNGpBt1UozvIXad+wvydV8YwavkY9W3Q28jiYMsSa+S0/YB1nDW77AVmkK6iQ8/a3YMDnh0qc6khG3IH/IFFL0gJYr0Pt5HwFISIwG+YNfIFh9WmabYwq4/03z9XPz4SoSGtCIhHZuwUHFZxW66p2h8spPUbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=To8Ra3Fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="To8Ra3Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B067C2BD10;
	Tue, 14 May 2024 11:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686133;
	bh=Sn2YEJpI4uVSXE996F1SOgr0CPfJ9bksY8SFSkq+/9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=To8Ra3FnsJ4/zL+xj+nKiQ2yYjQh6kRo0halQ7yy1qwi2OFoggOz3zoyxbHHssJL+
	 p7kTw7xhojjC+sHAOZ47n2d9J88ZWUwWIGE0dvi5M2Fg+4yUxUNdFUp/BVDO7ehiPF
	 0DOibyiR8RmywSEPehFoWfX3+cOF2fhCsujjQ+pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/236] pinctrl: intel: Make use of struct pinfunction and PINCTRL_PINFUNCTION()
Date: Tue, 14 May 2024 12:16:34 +0200
Message-ID: <20240514101021.561135672@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 999b85bfd765f273208cd7348b2977d3c5ae0753 ]

Since pin control provides a generic data type and a macro for
the pin function definition, use them in the Intel driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: fed6d9a8e6a6 ("pinctrl: baytrail: Fix selecting gpio pinctrl state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c |  6 +++---
 drivers/pinctrl/intel/pinctrl-intel.h | 13 ++++++++-----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 954a412267402..8542053d4d6d0 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -362,7 +362,7 @@ static const char *intel_get_function_name(struct pinctrl_dev *pctldev,
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
-	return pctrl->soc->functions[function].name;
+	return pctrl->soc->functions[function].func.name;
 }
 
 static int intel_get_function_groups(struct pinctrl_dev *pctldev,
@@ -372,8 +372,8 @@ static int intel_get_function_groups(struct pinctrl_dev *pctldev,
 {
 	struct intel_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
 
-	*groups = pctrl->soc->functions[function].groups;
-	*ngroups = pctrl->soc->functions[function].ngroups;
+	*groups = pctrl->soc->functions[function].func.groups;
+	*ngroups = pctrl->soc->functions[function].func.ngroups;
 	return 0;
 }
 
diff --git a/drivers/pinctrl/intel/pinctrl-intel.h b/drivers/pinctrl/intel/pinctrl-intel.h
index 65628423bf639..46f5f7d1565fe 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.h
+++ b/drivers/pinctrl/intel/pinctrl-intel.h
@@ -36,11 +36,13 @@ struct intel_pingroup {
 
 /**
  * struct intel_function - Description about a function
+ * @func: Generic data of the pin function (name and groups of pins)
  * @name: Name of the function
  * @groups: An array of groups for this function
  * @ngroups: Number of groups in @groups
  */
 struct intel_function {
+	struct pinfunction func;
 	const char *name;
 	const char * const *groups;
 	size_t ngroups;
@@ -158,11 +160,12 @@ struct intel_community {
 		.modes = __builtin_choose_expr(__builtin_constant_p((m)), NULL, (m)),	\
 	}
 
-#define FUNCTION(n, g)				\
-	{					\
-		.name = (n),			\
-		.groups = (g),			\
-		.ngroups = ARRAY_SIZE((g)),	\
+#define FUNCTION(n, g)							\
+	{								\
+		.func = PINCTRL_PINFUNCTION((n), (g), ARRAY_SIZE(g)),	\
+		.name = (n),						\
+		.groups = (g),						\
+		.ngroups = ARRAY_SIZE((g)),				\
 	}
 
 /**
-- 
2.43.0



