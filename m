Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656D13E49C7;
	Tue, 21 Jul 2026 18:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658789; cv=none; b=Ux/J2S+LtQ6pwJuL/oIfBXD+xElAW6MUpE5CgcRe/hgJomvL1RyijR0pNNc8muIJhJS0THrxng3MENuxvpTI406YGCOQof/Kit2iIlD0Prz63ps8Q+wgC6Eij7RUXFQV6qgmLUqgw7ucm+PmpN/Kt81qaIuA1diFh6lsgCh07nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658789; c=relaxed/simple;
	bh=QhFjyHQB8nOdhGbPlIpXv+Pyn+9sIblUcIHKmvuJPm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCyPQicSAohs2uBcNFFc7cc/TKhsT0fDrPVaLxidyT1eRrjoP/LJuH7XoZcSzd6zcZT+/ajAvB0qEPZL/KS9vF3WjMRdOMw9bosYyjc31vbSsXtPvSrQBr1XETL0p3QoRR+Efv+P5cSdOaL6nJEeIEEIwiv4q58v2lftsvL/nPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmAObpox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmAObpox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD481F000E9;
	Tue, 21 Jul 2026 18:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658788;
	bh=r8arQvSvGa7lkF+QYUTIknduRwXiCC3yOP0BS/YQFL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmAObpoxqtp9C7H3wPSWf84SYr55ISUrZp7QEZL4gTx9Acz7j3rG7z3v6fxOw4718
	 A5Vlt02b2qCQmkLTlMwL/KLX+HrHz7MJ++/An6Yy+TgYbk2BgJIV4ONGLMhDQz5Sle
	 AdGN8/XB5vhLBUOosUHcQheN1y+JyunBsxdoewWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.18 1276/1611] fpga: dfl: add bounds check in dfh_get_param_size()
Date: Tue, 21 Jul 2026 17:23:12 +0200
Message-ID: <20260721152544.145679642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1133,6 +1133,8 @@ static int dfh_get_param_size(void __iom
 			return -EINVAL;
 
 		size += next * sizeof(u64);
+		if (size > max)
+			return -EINVAL;
 
 		if (FIELD_GET(DFHv1_PARAM_HDR_NEXT_EOP, v))
 			return size;


