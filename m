Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F2233120C;
	Mon, 29 Dec 2025 16:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025282; cv=none; b=m59Dwqfphm4zNk2YWqo9LyBnVq2I7ZAncgrN1wgrxcda4HfsHOjmyv2IFqV0xHmtOHPg1r/goqVmkiJUF/G5HmhRIWD9B+N2USY1qbz5JiJENox/oDr+e9jecGpJKRZhyBmLDGTPFl/bG5oY/xbaWJ9IdLA++mPdiMnsFU/N/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025282; c=relaxed/simple;
	bh=gkt4NVLNFnQZjQd/PHUYc+t2CmKsofm6W76Z3eRRLdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZF95OexPAjDMIe4OSJaQUSbD8UN7jrpo9Mg1Gy3jnmldR/cnkOmMlkm4B3RlhclBPjHE0w+9Tsz1T+XrPrW6dadHgRqEdlff0rsGsSqv63gy2YOEfR7vDlJn/KbAtVjAne/9ccWTRcCG3dj1fm6FVEI0iB8wbqp2XJDQ6HlKhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1cXthin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1cXthin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22AEC4CEF7;
	Mon, 29 Dec 2025 16:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025282;
	bh=gkt4NVLNFnQZjQd/PHUYc+t2CmKsofm6W76Z3eRRLdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1cXthinuyGkdiC1bvL8io/KrYXEWNXqJF2VxvgUgu1tPZIxBgrUtvMzdeGw0qoX6
	 cguOfIXXfIjXIPgkTs6pJi4YhffkefDIliZXn8tT9WQ1PrHfsJsMcX1GHStGlMBjbR
	 Ql/BnwcAd2NWT+SHXjdnET/tKJ5cmJwH2SPxCvK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 158/430] ACPI: CPPC: Fix missing PCC check for guaranteed_perf
Date: Mon, 29 Dec 2025 17:09:20 +0100
Message-ID: <20251229160730.175024212@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Pengjie Zhang <zhangpengjie2@huawei.com>

commit 6ea3a44cef28add2d93b1ef119d84886cb1e3c9b upstream.

The current implementation overlooks the 'guaranteed_perf'
register in this check.

If the Guaranteed Performance register is located in the PCC
subspace, the function currently attempts to read it without
acquiring the lock and without sending the CMD_READ doorbell
to the firmware. This can result in reading stale data.

Fixes: 29523f095397 ("ACPI / CPPC: Add support for guaranteed performance")
Signed-off-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Cc: 4.20+ <stable@vger.kernel.org> # 4.20+
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20251210132227.1988380-1-zhangpengjie2@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1366,7 +1366,8 @@ int cppc_get_perf_caps(int cpunum, struc
 	/* Are any of the regs PCC ?*/
 	if (CPC_IN_PCC(highest_reg) || CPC_IN_PCC(lowest_reg) ||
 		CPC_IN_PCC(lowest_non_linear_reg) || CPC_IN_PCC(nominal_reg) ||
-		CPC_IN_PCC(low_freq_reg) || CPC_IN_PCC(nom_freq_reg)) {
+		CPC_IN_PCC(low_freq_reg) || CPC_IN_PCC(nom_freq_reg) ||
+		CPC_IN_PCC(guaranteed_reg)) {
 		if (pcc_ss_id < 0) {
 			pr_debug("Invalid pcc_ss_id\n");
 			return -ENODEV;


