Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82648EEB9;
	Tue, 23 Jan 2024 00:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968256; cv=none; b=VrYUtymS2lzZteZiz8n3rTqhHM+NQ0AxKZe5QpfcmU+4XUiLaYqzBPUfy1EPx8Uh894rU8Ac4+DL+c4Q2Wmnthxe9Sbflmn8zvzb/GUuqtJO4BkuOmxi/6ZB99cnl2tIqr5C8IYbCpvl+lAbtRFyjdjTpDAMFnHDPo6s1x4Eg+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968256; c=relaxed/simple;
	bh=BpLuFv1sUtutd208Cbadf/SRTLtJKF5RKobj052ohtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQT5KWIMU77KeogmFzIjcRHIpxpymXeoPf+VwTYMJQFcRn8rz35vfIMqtoJJRyA8yuskq0Zt2VWaAb40jHKfnFys4gwPxaLEBOhnsxBRClAsjA4FxIAfy0D5hBGIpjWmxuss1VBVG8TsPY6hPezgtVczivTMWnFkgFMKzddFyus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpMjh7xg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpMjh7xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBA2C433F1;
	Tue, 23 Jan 2024 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968256;
	bh=BpLuFv1sUtutd208Cbadf/SRTLtJKF5RKobj052ohtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpMjh7xgLvfHN+YQI364Ic9EQtQlnV529gXiks/IaOcJmuat5Q1CMSBzvI7ApxyMQ
	 aBvCPtxD+ULuSd/0mVvRNi/C+p5P8zDJ52DmaLBtjG7BzodKmtw2Dtx6FFtOYkXyhQ
	 jqF47TthR1sRGLDHcUXK1fazyBAQ0wlBC5srsbOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 4.19 026/148] coresight: etm4x: Fix width of CCITMIN field
Date: Mon, 22 Jan 2024 15:56:22 -0800
Message-ID: <20240122235713.475586882@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

From: James Clark <james.clark@arm.com>

commit cc0271a339cc70cae914c3ec20edc2a8058407da upstream.

CCITMIN is a 12 bit field and doesn't fit in a u8, so extend it to u16.
This probably wasn't an issue previously because values higher than 255
never occurred.

But since commit 4aff040bcc8d ("coresight: etm: Override TRCIDR3.CCITMIN
on errata affected cpus"), a comparison with 256 was done to enable the
errata, generating the following W=1 build error:

  coresight-etm4x-core.c:1188:24: error: result of comparison of
  constant 256 with expression of type 'u8' (aka 'unsigned char') is
  always false [-Werror,-Wtautological-constant-out-of-range-compare]

   if (drvdata->ccitmin == 256)

Cc: stable@vger.kernel.org
Fixes: 2e1cdfe184b5 ("coresight-etm4x: Adding CoreSight ETM4x driver")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310302043.as36UFED-lkp@intel.com/
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20231101115206.70810-1-james.clark@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -363,7 +363,7 @@ struct etmv4_drvdata {
 	u8				ctxid_size;
 	u8				vmid_size;
 	u8				ccsize;
-	u8				ccitmin;
+	u16				ccitmin;
 	u8				s_ex_level;
 	u8				ns_ex_level;
 	u8				q_support;


