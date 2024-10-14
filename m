Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D279C1AB530;
	Mon, 14 Oct 2024 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917054; cv=none; b=E6ZfJKSr2jrtgNx5rsZzFnLnIxkuxO7khuJCXyhQmHhYAJbq09Su+04qj/+zWJggw2UNxvrGgS8+NV+vJbSrEAC14WPnhaAJirhFk3KVMukVcy8kZbbxQdw9uTSM+q4JHtYIsfvInWWrF1HUbs2ZdqIuoiQiELTi5k64+Bv1bek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917054; c=relaxed/simple;
	bh=AC/v4ASkjB2oulCGsa5YPm7Ku5m6Nl0XbR1i7U2hz3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDA+HpCt9YdaMyMqbM7jGLXgkf9eC2m7FM3LwfThaxTyhtabIgVh65xqQu4MdLUrEqw3S5X0slPwMB84nJIzgVK3FTXdmqUTEjNvEEf/9NZT5JwftNStYXMg5h0tfhfbik5f/yL/Dh3nobmEKtPjz7uOEL99YcsdG2CUUsAorBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HE6xpJfF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HE6xpJfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE48C4CEC7;
	Mon, 14 Oct 2024 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917054;
	bh=AC/v4ASkjB2oulCGsa5YPm7Ku5m6Nl0XbR1i7U2hz3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HE6xpJfFD+l2m22TI9aEVRp0O8bYb72iuZlni/EFf1cqSgoNeOP3NCGFd6W0N6XA3
	 n8ktZ+Q8/8YILt0jdNiDD0p/vRhUKFjuAIVlezumZXX47a279AfGtgCTcGYJuaTQNZ
	 FrTVqJ383A1BC1IfES1h99WY1I66EXRaUoD5k9ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/213] powercap: intel_rapl_tpmi: Ignore minor version change
Date: Mon, 14 Oct 2024 16:20:44 +0200
Message-ID: <20241014141048.356309063@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

[ Upstream commit 1d390923974cc233245649cf23833e06b15a9ef7 ]

The hardware definition of every TPMI feature contains a major and minor
version. When there is a change in the MMIO offset or change in the
definition of a field, hardware will change major version. For addition
of new fields without modifying existing MMIO offsets or fields, only
the minor version is changed.

If the driver has not been updated to recognize a new hardware major
version, it cannot provide the RAPL interface to users due to possible
register layout incompatibilities. However, the driver does not need to
be updated every time the hardware minor version changes because in that
case it will just miss some new functionality exposed by the hardware.

The current implementation causes the driver to refuse to work for any
hardware version change which is unnecessarily restrictive.

If there is a minor version mismatch, log an information message and
continue, but if there is a major version mismatch, log a warning and
exit (as before).

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20240930081801.28502-4-rui.zhang@intel.com
Fixes: 9eef7f9da928 ("powercap: intel_rapl: Introduce RAPL TPMI interface driver")
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_tpmi.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/powercap/intel_rapl_tpmi.c b/drivers/powercap/intel_rapl_tpmi.c
index f6b7f085977ce..0085e59856166 100644
--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -15,7 +15,8 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
-#define TPMI_RAPL_VERSION 1
+#define TPMI_RAPL_MAJOR_VERSION 0
+#define TPMI_RAPL_MINOR_VERSION 1
 
 /* 1 header + 10 registers + 5 reserved. 8 bytes for each. */
 #define TPMI_RAPL_DOMAIN_SIZE 128
@@ -154,11 +155,21 @@ static int parse_one_domain(struct tpmi_rapl_package *trp, u32 offset)
 	tpmi_domain_size = tpmi_domain_header >> 16 & 0xff;
 	tpmi_domain_flags = tpmi_domain_header >> 32 & 0xffff;
 
-	if (tpmi_domain_version != TPMI_RAPL_VERSION) {
-		pr_warn(FW_BUG "Unsupported version:%d\n", tpmi_domain_version);
+	if (tpmi_domain_version == TPMI_VERSION_INVALID) {
+		pr_warn(FW_BUG "Invalid version\n");
 		return -ENODEV;
 	}
 
+	if (TPMI_MAJOR_VERSION(tpmi_domain_version) != TPMI_RAPL_MAJOR_VERSION) {
+		pr_warn(FW_BUG "Unsupported major version:%ld\n",
+			TPMI_MAJOR_VERSION(tpmi_domain_version));
+		return -ENODEV;
+	}
+
+	if (TPMI_MINOR_VERSION(tpmi_domain_version) > TPMI_RAPL_MINOR_VERSION)
+		pr_info("Ignore: Unsupported minor version:%ld\n",
+			TPMI_MINOR_VERSION(tpmi_domain_version));
+
 	/* Domain size: in unit of 128 Bytes */
 	if (tpmi_domain_size != 1) {
 		pr_warn(FW_BUG "Invalid Domain size %d\n", tpmi_domain_size);
-- 
2.43.0



