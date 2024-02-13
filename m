Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEA35FEFD;
	Tue, 13 Feb 2024 17:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845374; cv=none; b=Y2k7dbz3F9/c/nK9eOyqXD5OeLZyTPOxZFeEviJpT0lM+x5wKZHOY65GkAtuYuP/V6+f0uBieqbhFws5Ij5pvL/oL85vh3JqVJqeYrTQ2KkQzZ0WVniTJg+O+dD+wB+TP20nihItBwDve/pbPk6a8PMEyqiSRz1o5cQf0w7yE0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845374; c=relaxed/simple;
	bh=2Bjp44ywFoN0PazWgQc3fZjNp3L2A9eyV2AIf3ku824=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aR8hXXw+N2/M98Op21jTlUGDBK7iqMCvUSQNHSobTjmdvfqt39t0tNgJv+OR1Q/q9CJA1uI6heAN3MudzJopg8xOvR2R8d8Yaavw/+QuSSXMEz0AQEVUcQGf2zbweNoCqNoMJ8uE3bjG72QZpFuvcBPWfT5s4VcV1Z0dE7kmJDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4cOh0sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4cOh0sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732B3C433C7;
	Tue, 13 Feb 2024 17:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845373;
	bh=2Bjp44ywFoN0PazWgQc3fZjNp3L2A9eyV2AIf3ku824=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4cOh0sbNqkx7u74fHi2pHvoaAceqSsGemkn6RJqzxwEcrlog4kyZfPPWALXfJ8gV
	 +BZlrqQmCbI4IPQIEYdMq+tIPIpdmF0xMgBqvxQ3eeqQE97/MAsDRcWxLAVwqfV7hX
	 5Zjzb15/oEMcJDxoduSvShpWnCvv2pst0QM8Upmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/121] hwmon: (coretemp) Fix out-of-bounds memory access
Date: Tue, 13 Feb 2024 18:21:10 +0100
Message-ID: <20240213171854.775517574@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 4e440abc894585a34c2904a32cd54af1742311b3 ]

Fix a bug that pdata->cpu_map[] is set before out-of-bounds check.
The problem might be triggered on systems with more than 128 cores per
package.

Fixes: 7108b80a542b ("hwmon/coretemp: Handle large core ID value")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240202092144.71180-2-rui.zhang@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: fdaf0c8629d4 ("hwmon: (coretemp) Fix bogus core_id to attr name mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index ba82d1e79c13..e78c76919111 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -509,18 +509,14 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	if (pkg_flag) {
 		attr_no = PKG_SYSFS_ATTR_NO;
 	} else {
-		index = ida_alloc(&pdata->ida, GFP_KERNEL);
+		index = ida_alloc_max(&pdata->ida, NUM_REAL_CORES - 1, GFP_KERNEL);
 		if (index < 0)
 			return index;
+
 		pdata->cpu_map[index] = topology_core_id(cpu);
 		attr_no = index + BASE_SYSFS_ATTR_NO;
 	}
 
-	if (attr_no > MAX_CORE_DATA - 1) {
-		err = -ERANGE;
-		goto ida_free;
-	}
-
 	tdata = init_temp_data(cpu, pkg_flag);
 	if (!tdata) {
 		err = -ENOMEM;
-- 
2.43.0



