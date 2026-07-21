Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2C8372B5E;
	Tue, 21 Jul 2026 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654687; cv=none; b=Dsu7hePaUza85jTpPaWrLONXEtsLQ6HzfS2aPQ7684VvGgbFSpGhQ+o/skVvfitBLfGbwSz/YdyYKxOLMv036i4LjDIOTcWAxo8DyVFEwC6k8+IBwgSVlE8nn5LWV+cdZuLyzJ2inXXGOJ7f010YrQNo9x+lSYeITNvajhg2iBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654687; c=relaxed/simple;
	bh=gJWHkTL+oCPNqo7vI4L/qxLfGoG8H7TNRZil6JyaXbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/NncZMWY+EMVm0u3VDjzlSLku2VZel6wyCddr4Sw5Lr5FOC29WF9QzKS4y7VVuAp4ur6tHkngz3gt0YEYwf8sEIOruggH0eH8aeh7ATc77DrRnfK3f9eWiYsOmfmSyfI6Mq5eNJQC9g8F7nB5v+7gBntw/WaKkbeF74s5mZPXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYf9gFl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYf9gFl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A6C1F000E9;
	Tue, 21 Jul 2026 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654686;
	bh=dU28ymFyQCN20hhY/A3097wPv3ye4xTjc8IaNv7USDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYf9gFl1L/wSYR+t+s4EEH3M0N0OOnUGH4TzEnJZoYIgdQiigt15+XYQ4yhqsk23K
	 ZpJ1cmzgkVjaWpxpDplr2Jbd52SFredsg266G2TnuFuBTQ2J65lN+siQexvTinKtD+
	 d1VESNtOMKS2lG5OLxUJnMU4KObFGexcAPPJuNsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 7.1 1756/2077] fpga: dfl: add bounds check in dfh_get_param_size()
Date: Tue, 21 Jul 2026 17:23:49 +0200
Message-ID: <20260721152634.163499576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Alba Vives <sebasjosue84@gmail.com>

commit 9e8bc49f91f3f81d957c4f1c1f09fe94e2f88f6a upstream.

dfh_get_param_size() can return a parameter size larger than the feature
region because the loop bounds check is evaluated before incrementing
size. If the EOP (End of Parameters) bit is set in the same iteration,
the inflated size is returned without re-validation against max.

This can cause create_feature_instance() to call memcpy_fromio() with a
size exceeding the ioremap'd region when a malicious FPGA device provides
crafted DFHv1 parameter headers.

Add a bounds check after the size increment to ensure the accumulated
size never exceeds the feature boundary.

Fixes: 4747ab89b4a6 ("fpga: dfl: add basic support for DFHv1")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Alba Vives <sebasjosue84@gmail.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260518190742.61426-2-sebasjosue84@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/dfl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -1132,6 +1132,8 @@ static int dfh_get_param_size(void __iom
 			return -EINVAL;
 
 		size += next * sizeof(u64);
+		if (size > max)
+			return -EINVAL;
 
 		if (FIELD_GET(DFHv1_PARAM_HDR_NEXT_EOP, v))
 			return size;


