Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F01346E012;
	Tue, 21 Jul 2026 18:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659589; cv=none; b=SJ75netrW4ilEI3k33YAWlbBOBY0cn9DE9aKa07mGPvO0lqD/cFHDrcI3qVPSxD42gnK4VZe3HhVe5GANJ8g6p4QWSoZe9eFfRt/E0eozZbToBQnL0KmEWXUQkeqxbhHgpP7kTRtRTOn1smHd43pkPhBhtz1bJV8CfAO91nrIqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659589; c=relaxed/simple;
	bh=bcCDVIkdlXYxZigvgSYBDs91xQrtZa0N9gix+QMw9Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=av3SUaKAE1T1ZSeYlXHOa7v98K7T3QM7yXyzyCwWH4LQyjsDXCcMo0WL9oI8x3sOSm66gud+IqfDfg3L3SQ248YnbsZ4TkVzJR4SNslo7F4GaFWM33RDTbK7vZA2ExzhgDxqMm0kt6vsvjHeJABAtH5BGZbEvwMtlVvMPNXqkk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mH1UFxdk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mH1UFxdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC82A1F000E9;
	Tue, 21 Jul 2026 18:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659587;
	bh=ZWJHtoH+KVxL7bOWdfedUpZTfztFnlmXac/Tm5lIMdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mH1UFxdkSd7uwYs3bqcNxFaRSb547w9Swv9wLariIs8Cgp/8xvEqyjN5B7MXhcBF6
	 mz5KHEe44xIPu0RZ79wtZWZljvkxxQneTs6qjIbQNlYtjC3Y6elXTAGRc8r9F3VtRQ
	 QJh5/S1KkuqwPa5KWoRDxqFcQfIpPpFhm7WQgRJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 6.18 1534/1611] PCI: Free saved list without holding pci_bus_sem
Date: Tue, 21 Jul 2026 17:27:30 +0200
Message-ID: <20260721152549.952597801@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 1d8a0506f69895b7cfd9d5c4546761c508231a8a ]

Freeing the saved list does not require holding pci_bus_sem, so the
critical section can be made shorter.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
Link: https://patch.msgid.link/20251113162628.5946-6-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2465,8 +2465,8 @@ cleanup:
 		pci_claim_resource(dev, i);
 		pci_setup_bridge(dev->subordinate);
 	}
-	free_list(&saved);
 	up_read(&pci_bus_sem);
+	free_list(&saved);
 
 	return ret;
 }


