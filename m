Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87362426D05;
	Tue, 31 Mar 2026 16:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975244; cv=none; b=oKzd0fc5BsjzFAzM8DNSiCttCA3mHOJYYTFZ21zK5TBbaGoWv5/DLkTe6dRCpuSJFQCo8YudeHeIaOZ3BY+x/aG9rWIBpU6NTv/QYzZptIIAncyIbDqiexEnRE4mi5veKSPq4XTuuK4eSEwLDrAsN0qNPT3aDNZ2liSQsrVQwc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975244; c=relaxed/simple;
	bh=O2DCWoNExcme8r7QMDUg8zAyYTCBWOtMpep/m6OMboE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZM4TJrw0EUKpsXUSYhRsYTUf8dSmXuMlWVOZbRkLf5Z72DsIqLcOG6hIE32XwYNgxtWj66aqkEzmGkiFL49Iu9LkEhMJsJ0bva8/Zytqgk6jfVzrOU4gq9De0iViP0o7/61qE5HvWr3yEet6GI3lO7hFsY0wpV/dNl5y3AQwsbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1NM3U+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1NM3U+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D547C19423;
	Tue, 31 Mar 2026 16:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975244;
	bh=O2DCWoNExcme8r7QMDUg8zAyYTCBWOtMpep/m6OMboE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1NM3U+8cwbisLLjQQlM5rB3R0CEtvT5f49ynQH9l2loXlQieHV9auEt/VHqHhbEN
	 f2B+VqHBUndwkdiiUBzcKouVEy1Ni2qzhILEYZP/wJStnj+opdYS8H3nXkNeXCbQCN
	 YilDqB6/av8yo4S42KJ7D+HoIBt6iTC4V2nsM2pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erin Park <erin.park@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.19 219/342] thermal: intel: int340x: soc_slider: Set offset only for balanced mode
Date: Tue, 31 Mar 2026 18:20:52 +0200
Message-ID: <20260331161807.033730469@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 7dfe9846016b15816e287a4650be1ff1b48c5ab4 upstream.

The slider offset can be set via debugfs for balanced mode. The offset
should be only applicable in balanced mode. For other modes, it should
be 0 when writing to MMIO offset,

Fixes: 8306bcaba06d ("thermal: intel: int340x: Add module parameter to change slider offset")
Tested-by: Erin Park <erin.park@intel.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 6.18+ <stable@vger.kernel.org> # 6.18+
[ rjw: Subject and changelog tweaks ]
Link: https://patch.msgid.link/20260324172346.3317145-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_soc_slider.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_soc_slider.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_soc_slider.c
@@ -176,15 +176,21 @@ static inline void write_soc_slider(stru
 
 static void set_soc_power_profile(struct proc_thermal_device *proc_priv, int slider)
 {
+	u8 offset;
 	u64 val;
 
 	val = read_soc_slider(proc_priv);
 	val &= ~SLIDER_MASK;
 	val |= FIELD_PREP(SLIDER_MASK, slider) | BIT(SLIDER_ENABLE_BIT);
 
+	if (slider == SOC_SLIDER_VALUE_MINIMUM || slider == SOC_SLIDER_VALUE_MAXIMUM)
+		offset = 0;
+	else
+		offset = slider_offset;
+
 	/* Set the slider offset from module params */
 	val &= ~SLIDER_OFFSET_MASK;
-	val |= FIELD_PREP(SLIDER_OFFSET_MASK, slider_offset);
+	val |= FIELD_PREP(SLIDER_OFFSET_MASK, offset);
 
 	write_soc_slider(proc_priv, val);
 }


