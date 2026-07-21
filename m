Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F329356746;
	Tue, 21 Jul 2026 19:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663780; cv=none; b=u6k5M9UhSEBz1w2GaHJXq20Hois3tdwiWj9+xOz2OJVnnpu2PPkY3GJY1zU+a8YeT/6lsm8lSsOiI2PEf2KzRc7sWm7Fh/NPMCpSy6KRj1DbHDQEEkEW4uSh5ugkhF0MFKekWwCop6I0atsrWs76K/ZiGz5rlYaBVSW4La0SQ0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663780; c=relaxed/simple;
	bh=uxO61UHTivV4bNVlr6Vc77LuVkQyIJsPbMF/yMAfQ1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k41mhZSXc66u3lS8w+LRBJ1sZSsphZturBXyJXi1lapTqbBmA44k4LO+BzU2K3KAZnhKAAX0Yw5eFnANldmZyfriWIC2ncjd1GJeHCAtZ/Dkt+Ot0x4V8jhkWqO6csY2U5PvB7EI5RcF0Nuv+tLyNkaFQ+8wRQ4V3FgmWQ35odI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaUKt5Hb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaUKt5Hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4791F000E9;
	Tue, 21 Jul 2026 19:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663779;
	bh=r6oMQc3cWzxWvMR5s6y9lg16VzsneZRAFKMaxsiaon0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaUKt5Hb3g5uWMiqKotRcgm1cGKDsRL8ePKzNb65JXe0ClMd0AcddpUtq89bX+El8
	 ldEr7S4RkFGH6Z/Siih3P1k+hSTLK7ks4uM3rq93VPJCujbseVgrlc4LbAJ7d4xinz
	 dOW2LGJux+48LpF8Se6lqPCsVG5wMAlrM1N+0pjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.12 0951/1276] fpga: dfl: add bounds check in dfh_get_param_size()
Date: Tue, 21 Jul 2026 17:23:14 +0200
Message-ID: <20260721152507.310309597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1117,6 +1117,8 @@ static int dfh_get_param_size(void __iom
 			return -EINVAL;
 
 		size += next * sizeof(u64);
+		if (size > max)
+			return -EINVAL;
 
 		if (FIELD_GET(DFHv1_PARAM_HDR_NEXT_EOP, v))
 			return size;


