Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9F6149E06;
	Tue, 25 Jun 2024 09:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309010; cv=none; b=r2O/imC2g6ktLx3zy9pKNnd0YbPR70mZObf/h6hn8jSlXoasLFkOTylbMFyuF6541NvqKIJ3nZ5r9PrPrpQ5L1p0viMupDVsp/50Y8A2FUEZHtYwjPrNsZ0DJ8U9NVSnnxmtwHzVLywiD6XSI3HHZ0RFd/q+MzDuTga+gq5mDZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309010; c=relaxed/simple;
	bh=7Gcq2YMrWt9Z5FwwR5NY9I0BhQTmphVAKQYOHmQleGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G2A/qUq6H0ujc7Cy3Mk0IBoEpAHsPVlZOS0GUTCrYBUwMQ05l3DQ7F3Rqmkagu1o/jX238XbIGZxMRicywTrUEENOWHARoIDzqDJgpYH8Czhlf+U78EhP2PFD3+2nsk9aPS17A5/6r2wkfBAg+4R2vnjfMXSOhi593w719eklB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULCu2oyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULCu2oyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4D7C32781;
	Tue, 25 Jun 2024 09:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309010;
	bh=7Gcq2YMrWt9Z5FwwR5NY9I0BhQTmphVAKQYOHmQleGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULCu2oyWC68iJ720tRV6Bv3R4tJ3hgf9Lg3X1zFHTCn71lIit9orFENEUukwYmQEu
	 zpsx4Zl0+x69xaoG9mQNIbfPX+m3KF+SxwJGJ9YIYMqTxoudF2sO5Cjyl0UOrzc9ho
	 8G4eXt4eT8cIbnRMSMBIafr16REu3HCf7WKUexrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/192] MIPS: Routerboard 532: Fix vendor retry check code
Date: Tue, 25 Jun 2024 11:32:17 +0200
Message-ID: <20240625085539.667943874@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ae9daffd9028f2500c9ac1517e46d4f2b57efb80 ]

read_config_dword() contains strange condition checking ret for a
number of values. The ret variable, however, is always zero because
config_access() never returns anything else. Thus, the retry is always
taken until number of tries is exceeded.

The code looks like it wants to check *val instead of ret to see if the
read gave an error response.

Fixes: 73b4390fb234 ("[MIPS] Routerboard 532: Support for base system")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/pci/ops-rc32434.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/pci/ops-rc32434.c b/arch/mips/pci/ops-rc32434.c
index 874ed6df97683..34b9323bdabb0 100644
--- a/arch/mips/pci/ops-rc32434.c
+++ b/arch/mips/pci/ops-rc32434.c
@@ -112,8 +112,8 @@ static int read_config_dword(struct pci_bus *bus, unsigned int devfn,
 	 * gives them time to settle
 	 */
 	if (where == PCI_VENDOR_ID) {
-		if (ret == 0xffffffff || ret == 0x00000000 ||
-		    ret == 0x0000ffff || ret == 0xffff0000) {
+		if (*val == 0xffffffff || *val == 0x00000000 ||
+		    *val == 0x0000ffff || *val == 0xffff0000) {
 			if (delay > 4)
 				return 0;
 			delay *= 2;
-- 
2.43.0



