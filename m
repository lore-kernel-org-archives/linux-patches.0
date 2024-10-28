Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95D018E05A;
	Mon, 28 Oct 2024 06:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096895; cv=none; b=mvVR9SMN/CecuaYou3hUXMnh3FiQces88parBmwf0iFwGHY1SCIBuCyiyqPWPKNd5v3q7WtMCZ5ndBlzroMRvQL/J+cVLXa1g5k2d6gRz0j11DdCFudRKW8zsU2J1/HD3mUrTawohR0BMBJ6rqXEwXA5NKiNazil2HkgfHZJfUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096895; c=relaxed/simple;
	bh=AOaJgxinwtsoGAn2grr4Leha/dNW8X+TTpVIouMqzWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zi/QwTFfWzX5/CllKDfZ2B3tTXXUILO3CC7p7849P7ekOhvSE9DkMeB76lEFYFyc0FyHHKsBNCgpRBZ/ABaqf+uslD/MHM2EqVBun0DXOvfC1ZjKBA6OYtpdflhoZUsCKW5c7A6IRBl7swB4Zeu+AbmsJSBsob/TBAKFuQrWCVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1gRcRpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1gRcRpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6798EC4CEC3;
	Mon, 28 Oct 2024 06:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096895;
	bh=AOaJgxinwtsoGAn2grr4Leha/dNW8X+TTpVIouMqzWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1gRcRpwWrEdqETphm/VKxP/DyB61yEkA+t+PJtIQDIYJFj4SALFhkvPpVW4RGpcp
	 1zfZFP0qIL5mSIPyNSdNnYgKo76CUQA3CDg7HqIUZO3SaQiItKhRX3+Z0Wcs7NvUT9
	 5lcsfFKaWCWL4g9ORGtm7qd16GHlhdXXS1IZD87c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Martin Kletzander <nert.pinx@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/80] x86/resctrl: Avoid overflow in MB settings in bw_validate()
Date: Mon, 28 Oct 2024 07:24:45 +0100
Message-ID: <20241028062252.769431599@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kletzander <nert.pinx@gmail.com>

[ Upstream commit 2b5648416e47933939dc310c4ea1e29404f35630 ]

The resctrl schemata file supports specifying memory bandwidth associated with
the Memory Bandwidth Allocation (MBA) feature via a percentage (this is the
default) or bandwidth in MiBps (when resctrl is mounted with the "mba_MBps"
option).

The allowed range for the bandwidth percentage is from
/sys/fs/resctrl/info/MB/min_bandwidth to 100, using a granularity of
/sys/fs/resctrl/info/MB/bandwidth_gran. The supported range for the MiBps
bandwidth is 0 to U32_MAX.

There are two issues with parsing of MiBps memory bandwidth:

* The user provided MiBps is mistakenly rounded up to the granularity
  that is unique to percentage input.

* The user provided MiBps is parsed using unsigned long (thus accepting
  values up to ULONG_MAX), and then assigned to u32 that could result in
  overflow.

Do not round up the MiBps value and parse user provided bandwidth as the u32
it is intended to be. Use the appropriate kstrtou32() that can detect out of
range values.

Fixes: 8205a078ba78 ("x86/intel_rdt/mba_sc: Add schemata support")
Fixes: 6ce1560d35f6 ("x86/resctrl: Switch over to the resctrl mbps_val list")
Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Martin Kletzander <nert.pinx@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 000e1467b4cde..d00909428b435 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -27,10 +27,10 @@
  * hardware. The allocated bandwidth percentage is rounded to the next
  * control step available on the hardware.
  */
-static bool bw_validate(char *buf, unsigned long *data, struct rdt_resource *r)
+static bool bw_validate(char *buf, u32 *data, struct rdt_resource *r)
 {
-	unsigned long bw;
 	int ret;
+	u32 bw;
 
 	/*
 	 * Only linear delay values is supported for current Intel SKUs.
@@ -40,16 +40,21 @@ static bool bw_validate(char *buf, unsigned long *data, struct rdt_resource *r)
 		return false;
 	}
 
-	ret = kstrtoul(buf, 10, &bw);
+	ret = kstrtou32(buf, 10, &bw);
 	if (ret) {
-		rdt_last_cmd_printf("Non-decimal digit in MB value %s\n", buf);
+		rdt_last_cmd_printf("Invalid MB value %s\n", buf);
 		return false;
 	}
 
-	if ((bw < r->membw.min_bw || bw > r->default_ctrl) &&
-	    !is_mba_sc(r)) {
-		rdt_last_cmd_printf("MB value %ld out of range [%d,%d]\n", bw,
-				    r->membw.min_bw, r->default_ctrl);
+	/* Nothing else to do if software controller is enabled. */
+	if (is_mba_sc(r)) {
+		*data = bw;
+		return true;
+	}
+
+	if (bw < r->membw.min_bw || bw > r->default_ctrl) {
+		rdt_last_cmd_printf("MB value %u out of range [%d,%d]\n",
+				    bw, r->membw.min_bw, r->default_ctrl);
 		return false;
 	}
 
@@ -62,7 +67,7 @@ int parse_bw(struct rdt_parse_data *data, struct resctrl_schema *s,
 {
 	struct resctrl_staged_config *cfg;
 	struct rdt_resource *r = s->res;
-	unsigned long bw_val;
+	u32 bw_val;
 
 	cfg = &d->staged_config[s->conf_type];
 	if (cfg->have_new_ctrl) {
-- 
2.43.0



