Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00B74ED184;
	Thu, 17 Sep 2026 17:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664467; cv=none; b=ga95ip+JjFxNa6NBgFrLiwosj5nEm8yH++1nLyTk0MdZJMtJMKCDG/CQDwTBJPBFFfn44L8V4xH1oyraVt4y3YgPFMpWPPaFAzMR1lzn+0UblDtyvYxMajsFU24giSjsjEiH5VtJXE4PwxbEqvF1UDNP45CQMAit07nJSzjK76g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664467; c=relaxed/simple;
	bh=gmYlqeeXtqMkjl6QlKIf+amRNnjef67xFVQXA2y08oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItBpoGzuKaVROoA3BhSfYvy4zEE/mc/c2dM6lEReogZdWL7YiGB6igADSkbncPj7ZTtQZ8y7XHYUMPcYf3LKQHTgEMW5CmWPSynjnlyLEYrawnqsgR3hqRbd4QvIU9gSjKIuah0csvR9r2B9TZg5AxFkdgn5jyeNzfhUarrYMWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vL2vKUhq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vL2vKUhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C101F00893;
	Thu, 17 Sep 2026 17:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664464;
	bh=PBYmlxH6ZQgOp4uVsUAWYBuoCpL4BdPiqXbFd0URpU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vL2vKUhqRp/mUWvOeo+e2MgcurEX1CFV4A+r450entUhLUSyNvRyuQlJRc4SFcxyx
	 ZC+iu2Nc9sdXe7mvbVBoetrKphgK8HrCIWdGPh/9SitvvfSugDJghiCChCp0ep/TuK
	 fHnqRauC0xuDARaBqfwCjLE7U43vSlv8hetOfyDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0381/1250] ata: libata-pmp: add JMicron JMS562 quirk
Date: Thu, 17 Sep 2026 16:02:56 +0100
Message-ID: <20260917151602.374107831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit c62aff1174cf88e10716c7513702443c47551fc6 ]

JMicron JMS562, as used in QNAP QDA-A2AR RAID1 adapters, may
keep the exported ATA device not ready while the array is rebuilding.

In this state, libata may repeatedly try to softreset and classify
the fan-out link.  On the affected adapter, this can time out, make
PMP/SCR access fail, and eventually disable the fan-out link before
the RAID volume is exported.

A failing boot shows the fan-out link failing SRST, PMP access
timing out, SCR read failing, and the link being disabled:

  ata4.00: softreset failed (device not ready)
  ata4.15: qc timeout after 3000 msecs (cmd 0xe4)
  ata4.00: failed to read SCR 0 (Emask=0x4)
  ata4.00: failed to recover link after 3 tries, disabling

After that, the root filesystem on the exported RAID volume cannot
be found.

Add JMS562 to the existing JMicron PMP quirk that disables LPM,
avoids softreset on fan-out links, and assumes an ATA device.  This
prevents libata from dropping the exported RAID volume during rebuild
recovery.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-pmp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 48ac09d9031e6..299b1823e0d09 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -457,8 +457,13 @@ static void sata_pmp_quirks(struct ata_port *ap)
 		 * otherwise.  Don't try hard to recover it.
 		 */
 		ap->pmp_link[ap->nr_pmp_links - 1].flags |= ATA_LFLAG_NO_RETRY;
-	} else if (vendor == 0x197b && (devid == 0x2352 || devid == 0x0325)) {
+	} else if (vendor == 0x197b &&
+		   (devid == 0x0562 || devid == 0x2352 || devid == 0x0325)) {
 		/*
+		 * 0x0562: JMicron JMS562, as used in QNAP QDA-A2AR RAID1
+		 *         adapters.  The exported device may stay not ready
+		 *         while the array is rebuilding, and SRST/classify can
+		 *         time out before the RAID volume is exported.
 		 * 0x2352: found in Thermaltake BlackX Duet, jmicron JMB350?
 		 * 0x0325: jmicron JMB394.
 		 */
-- 
2.53.0



