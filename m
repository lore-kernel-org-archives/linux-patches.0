Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062267;
	b=bzkcQixchE1G56LwZb1Y5jU0JI3sBXLHtobXINBqCvvx1kTGeKLSL3rbo1PAhbAKavgk
	 AtIFvXkhzL0tIVeqvVANU6m6I+rH7QigeaN3wWQ8ak+DO8WVsnFlXxRizjitPlBG8uhY5
	 ExBjTZOE2tCTjNr7+YIH0UwOpDDDvrW/F2e0KTS54WY/GlwbLbKPAqL/UcffqeL+OtxOT
	 PrExBXz/gqs31wg0cZCOzBtO4Dq7dEoGBNvo90s2Hp5B+PESFfZMYUW/729gdUG7RRxkB
	 IdblqaxOto/mVsFvM+jAdop7sRgJDXgYrTUWbBW5yj4WHCGc+UiFHeWtfjdsb10i+wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jF5/p7fim6x1bQE9EFuhQhOfsFXCad2CcRdRBK8yKys=;
	b=q5AfpflJWHVktI/3zB6y5ceXakHRarwGq55EelJ1gwjg8vZGn6eyy7V5/CofeKf4DlDq
	 CnJ47gwWMj0v6ZFtn+NCHVQDAma7uftEXOC3Do6xUQyzJmlqhKfhNwTsTOxSg04Dq4qWJ
	 GtT4uYgESZ3Sd35Qoyp4oyc3w2qP7abRwYoc+3Gunw3ml4uuSQr/d28+edvgsFaCyQ8fD
	 5Mgbg2xyNaM2KRx+syBF3nPSgMHZja+Po7E72zrDjcDHyaU7qA/5Ulse5Wdw7pqp1tlrE
	 AJGID9JXcNKZ1REvCFe3JQH+CNmTN52lUkvobN4wzeD6VHb1xFFZrI2701GgqaR1uDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SZW53Cww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0CA60A3801;
	Sat,  7 Nov 2026 14:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SZW53Cww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC021F0089F;
	Sat,  7 Nov 2026 14:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062267;
	bh=jF5/p7fim6x1bQE9EFuhQhOfsFXCad2CcRdRBK8yKys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZW53CwwjWN8JLfKvRgpkQyWtDCfR6inbpID6iJzVxv14xTD/asGHddXjcSriKMih
	 s9qw09ib9o7Vecx7xpsIGIO9IyH/YVFwiiwtbNIZTKS6BXHPlBaDOw1pR/bsAHVBkY
	 XTjAys4ed+uiiSLfe8zMXZNhs4bOLrG+Hy2LG+3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Jiqian Chen <Jiqian.Chen@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1210/1536] xen-pciback: Fix pcistub_device ref leak in pcistub_get_gsi_from_sbdf()
Date: Sat,  7 Nov 2026 08:53:46 -0500
Message-ID: <20261107135031.739069170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit cfaf31becde901f7a2376d36db628f8be0bc7283 ]

pcistub_get_gsi_from_sbdf() obtains the stub device with
pcistub_device_find(), which returns it with its kref incremented, and
returns psdev->gsi without dropping that reference again.  The caller
cannot release it either, so every lookup leaks one reference to the
stub device.

Release the reference after reading gsi.

Fixes: 2fae6bb7be32 ("xen/privcmd: Add new syscall to get gsi from dev")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jiqian Chen <Jiqian.Chen@amd.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260916171141.2086627-1-vulab@iscas.ac.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xen-pciback/pci_stub.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 8b3006078d003..3ed3de3851f54 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -234,13 +234,16 @@ static int pcistub_get_gsi_from_sbdf(unsigned int sbdf)
 	int bus = PCI_BUS_NUM(sbdf);
 	int slot = PCI_SLOT(sbdf);
 	int func = PCI_FUNC(sbdf);
+	int gsi;
 
 	psdev = pcistub_device_find(domain, bus, slot, func);
-
 	if (!psdev)
 		return -ENODEV;
 
-	return psdev->gsi;
+	gsi = psdev->gsi;
+	pcistub_device_put(psdev);
+
+	return gsi;
 }
 #endif
 
-- 
2.53.0



