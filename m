Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036020;
	b=c/Ydn3HUZJijZNeBfFmc0HPY1dz9Bi7SkXh8iNxNYYoYVrPXztxFu+k6I/2Z/erpcchx
	 iaWU9QuV88fpll4tPTaPS1bd2H7glOR+BGBhgtRNRHxqvzJxcdXLzmKfOUbFbuWGSwSTF
	 vem0jzwQ0Od6AhrMk+829Mt0EPDqp5qwb+MvpnX66B4xyvCjBasrW80UKPEkgdPZ8PsUN
	 CwiaIc4KAiGn3WTgehjZcMQn5VgcLQoU86pE7naqqdKUR9Si/yqAiH0ZXgq+WyMR/OAKM
	 WNqYO3njWqVsrO+2B3hr/iv+/aojBl8NiywnehBnmPSrFF2mBfkjOSm/+YOxK7VmUkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B66tzjRRStC6Yvv1kgPeFtsffP+19Y5nNMOVpbTN+6A=;
	b=Ra9icqwfKiEMmAzYr2Kix6XY89oqxbEf4B1kyBp9geawCXVNvKkoJNo6ikDMJOSGHoQ0
	 7jsEbeQ6ditqvFRT1W7g68x2iQwDlmYg46DhdEYkUWx+tLfdqv8e+Z4MSbWjHwlvhhqWz
	 lxO5UcvwZ2VBvqJiHc4RoI5O3qHyhDyeVrubuZmvPAUxp+PNcqOx9bxaf3HQHYBPzClMj
	 hI6aGDt92PpnJky5FEOR5/IvWCopUXCc65OvTxZw67bP/H/Pr0/rZqn/1Ai+kjGg436hZ
	 DsPVgTdfCgiS60FaMaB2AuWsuCl8EZ0EPBll+AlY0MKvpLfwCBJsZK9GaoA/SZ45CHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NVZA4M0Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534A8606A320;
	Wed, 18 Nov 2026 21:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NVZA4M0Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37521F000C4;
	Wed, 18 Nov 2026 21:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036020;
	bh=B66tzjRRStC6Yvv1kgPeFtsffP+19Y5nNMOVpbTN+6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVZA4M0Yi8LvNXNHUWDReR4obTUZkvHDLqScZoXOtmCMWS4OMuvn+2PSh/OHBAND1
	 IkEXrVJdNhKfOdk0j8+trmyv5ccb7Mu0iVbq8p5auoHSRkfYn/sm4FQ862l/L78VTs
	 AFpHBiijCOjjHmYTlh3aQBbo9F8LZCPOm7QkcISo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qzhuo@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0909/3318] EDAC/i10nm: Fix mdev reference leak in i10nm_get_ddr_munits()
Date: Wed, 18 Nov 2026 15:25:31 +0100
Message-ID: <20261118150346.780334972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit f0d8c34b3b5e845113581d7d3b24ddaa61bce1f0 ]

In i10nm_get_ddr_munits(), get_ddr_munit() returns a PCI device with
its reference count incremented.  If ioremap() fails to map the MMIO
space of the memory controller, the function returns -ENODEV without
putting the reference held by mdev, leaking it.

Put the device reference before returning on the ioremap failure path.

[Tony: Dropped the Cc: stable tag]

Fixes: c545f5e41225 ("EDAC/i10nm: Skip the absent memory controllers")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qzhuo@nvidia.com>
Link: https://patch.msgid.link/20260916091251.1997522-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index ac345aae4942e..b388ca955b522 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -745,6 +745,7 @@ static int i10nm_get_ddr_munits(void)
 
 			mbase = ioremap(base + off, size);
 			if (!mbase) {
+				pci_dev_put(mdev);
 				i10nm_printk(KERN_ERR, "Failed to ioremap 0x%llx\n",
 					     base + off);
 				return -ENODEV;
-- 
2.53.0



