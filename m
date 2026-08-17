Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F96175A6B;
	Mon, 17 Aug 2026 14:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977651; cv=none; b=IBM63AssM66nLND0sod3v5oNANQNRE0z83LkSN4WrdQzOwb07L3SB0L4hb3NFWhJY/P4Gkge2OJ4iNymB4XqB7x9D/ZDPpXUoTDndTf7NHjcsqgIV8pCF18yJJVs9lEDgtWE/WicseDFLEBx1CHRxRtEvqVWpC8U/ZKIuhL75Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977651; c=relaxed/simple;
	bh=cRZKWZ3DbaAm1Xxy7Vr8GNssKJzFF8bp/bNCCo86QcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0ZqcyQsV8mMHqJTUeb/NysMPrFZFocr/5WfSWxNRuIrcgrvYMA/bQck3gnl5GZMvEn6dueJVJb8iAi8sjLLIIG8SpFtsWfFoqrdNrACNcsJARuPiEukfZnzYF2wOs33CBApxhRj9z9P90vQXWkV7StS4zChrE73zN8MZot1avQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTOmVlbr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTOmVlbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE311F000E9;
	Mon, 17 Aug 2026 14:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977650;
	bh=cNIZz/thK4eMXuURj7TiHV+WvO31earGHKSLUQb/fzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTOmVlbro+2UmH8gS2S+cBtfZ36+IR0ql9NRcB7w1wlrdSTxOvmIPR/M+7ms0l5Hu
	 h7X3Vu65zg/gOwd4JsWubU5ESxXTGu6z/2bpsfYmHuCOdoyNdGgWUAXHP6JzderGIV
	 HixYpVPgCcwMkQXK0uQdr1+8ASoIDlSxEfNIotaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/456] ata: pata_sl82c105: fix bridge revision use-after-free
Date: Mon, 17 Aug 2026 15:33:05 +0200
Message-ID: <20260817132554.828982340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 7700a31039cdc6715cb6cce7e7a664ee4e945f67 ]

pci_get_slot() returns a referenced PCI device. Commit 44c10138fd4b
("PCI: Change all drivers to use pci_device->revision") replaced a
configuration-space read with direct access to the cached revision field,
but left that access after pci_dev_put(). The bridge may therefore be freed
before its revision is read.

Read the revision before dropping the reference.

Fixes: 44c10138fd4b ("PCI: Change all drivers to use pci_device->revision")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_sl82c105.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 8487470e2e01e..c32f3b490bb35 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -265,6 +265,7 @@ static struct ata_port_operations sl82c105_port_ops = {
 static int sl82c105_bridge_revision(struct pci_dev *pdev)
 {
 	struct pci_dev *bridge;
+	u8 revision;
 
 	/*
 	 * The bridge should be part of the same device, but function 0.
@@ -286,8 +287,9 @@ static int sl82c105_bridge_revision(struct pci_dev *pdev)
 	/*
 	 * We need to find function 0's revision, not function 1
 	 */
+	revision = bridge->revision;
 	pci_dev_put(bridge);
-	return bridge->revision;
+	return revision;
 }
 
 static void sl82c105_fixup(struct pci_dev *pdev)
-- 
2.53.0



