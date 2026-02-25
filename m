Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720D62522A7;
	Wed, 25 Feb 2026 01:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984002; cv=none; b=gq+VYJpmjSVzhri9En46kUWd59j3Cqy0wU27N46T1FcL2PM6zFqlPqd0JBUPhV4TOVVbAhsVcuMn0XSvh0YhkNw3OBfyn3bNkq4tqFkO7G/LkDsu0bKWCEIkS3fNPuGz698+KrWrWbZHR9ETWKKX7wVKKmuKvwJEv6lBIw3IISA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984002; c=relaxed/simple;
	bh=QZHFrTU58FyYf49FYoAYKsc3Y9vv2q9w9I/n7ddLr/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQq2huhTOGV+Ekl99/YjSivamnyyIkidSNN42QnqF2uh+t2oBhkCEOXDNjW8fodE18XvNyh0zDdZtBwbVoxbabgUfTConQXHtT5zLiv/ApOff4uMmgegvvXmZ3N0xDJDHiQdd3LQOOfyNdPT+/Nh4QOZEbCECUTQvZ3R+i6tDAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPBPCUuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPBPCUuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313FFC116D0;
	Wed, 25 Feb 2026 01:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984002;
	bh=QZHFrTU58FyYf49FYoAYKsc3Y9vv2q9w9I/n7ddLr/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPBPCUuU8k2GY8P+2ZHJqLcdhKe4XeB+UBo/ew77Jcf7IxXN0YD/4GO63Q8G3Bi9O
	 hgI50HN+te4bAxvNEnAu2gmsrSSlCDEuGRpfeEc5fK/FGICA9aBJGvakJwqaWiIh4b
	 Y6U/WOsLrlEj/GmBP2ti2HbYJj46hWXEWyXn6H2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@google.com>,
	Brian Norris <briannorris@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 237/641] PCI/PM: Avoid redundant delays on D3hot->D3cold
Date: Tue, 24 Feb 2026 17:19:23 -0800
Message-ID: <20260225012354.624424503@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Brian Norris <briannorris@google.com>

[ Upstream commit 4d982084507d663df160546c4c48066a8887ed89 ]

When transitioning to D3cold, __pci_set_power_state() first transitions to
D3hot. If the device was already in D3hot, this adds excess work:

  (a) read/modify/write PMCSR; and
  (b) excess delay (pci_dev_d3_sleep()).

For (b), we already performed the necessary delay on the previous D3hot
entry; this was extra noticeable when evaluating runtime PM transition
latency.

Check whether we're already in the target state before continuing.

Note that __pci_set_power_state() already does this same check for other
state transitions, but D3cold is special because __pci_set_power_state()
converts it to D3hot for the purposes of PMCSR.

This seems to be an oversight in commit 0aacdc957401 ("PCI/PM: Clean up
pci_set_low_power_state()").

Fixes: 0aacdc957401 ("PCI/PM: Clean up pci_set_low_power_state()")
Signed-off-by: Brian Norris <briannorris@google.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
[bhelgaas: reverse test to match other "dev->current_state == state" cases]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251003154008.1.I7a21c240b30062c66471329567a96dceb6274358@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2f0da5dbbba40..08a8c17ba4b12 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1488,6 +1488,9 @@ static int pci_set_low_power_state(struct pci_dev *dev, pci_power_t state, bool
 	   || (state == PCI_D2 && !dev->d2_support))
 		return -EIO;
 
+	if (dev->current_state == state)
+		return 0;
+
 	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 	if (PCI_POSSIBLE_ERROR(pmcsr)) {
 		pci_err(dev, "Unable to change power state from %s to %s, device inaccessible\n",
-- 
2.51.0



