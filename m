Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F195F21B191;
	Sat, 30 May 2026 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165594; cv=none; b=PQbR+J4KO7fBZ7rlCKBWRSRrPlq5rPm1RJrJIf/FKeio3JIbC3HkzlViT6mlXm++Z4DCY+iQeh/L8Qm5go+gHRCZU8T5FKmvmNfZmbxATQm1BX8URg4orvrohCFZMie7xiGQHY2NsruNNbbrm1K+jmAP3OTJFjmhf5a94hG/lOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165594; c=relaxed/simple;
	bh=7tJeQLitcQgGsusKSAdWyKfxMavBOtT3B3wrwkonUIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhuYmYlWwVmtICvVpM2shczqbOADH7oiNmP88LiZBelPwVfmypHNrjVB2zDkGe3u3wMvDKRc3h7EpAJ2g2oS2vlj7AQ8NHZfihJSQ4Fbj27W6GV+I9ulQkpdx0CJDg+b4xAAV6ke4V02lV3BkIuaziB7rml3Kz5qNg9T5Mf7srk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0m0ouUom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0m0ouUom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A381F00893;
	Sat, 30 May 2026 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165593;
	bh=kwAWAI4eZ95lfsZxZ0Fw9l5YF/y2ILBqC5JBv/ezKuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0m0ouUomRle4rNBBB745AQHUhX2RhaHEg7wGK0z9elua3V5bAR4wgQLbe1fb7Tfnx
	 1RWxUE/+5STM2b1ZWzynpEtrjUnxgjZIFMgu8Vyn0nSNzXyfcPp8ZTJ9Ao+LeGSJLs
	 G/g3uzn8zrDdKwHHNcr5L8NbJlxfCjSULqwLDzlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jamie Iles <quic_jiles@quicinc.com>
Subject: [PATCH 5.10 123/589] i3c: fix uninitialized variable use in i2c setup
Date: Sat, 30 May 2026 18:00:04 +0200
Message-ID: <20260530160228.000607208@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamie Iles <quic_jiles@quicinc.com>

commit 6cbf8b38dfe3aabe330f2c356949bc4d6a1f034f upstream.

Commit 31b9887c7258 ("i3c: remove i2c board info from i2c_dev_desc")
removed the boardinfo from i2c_dev_desc to decouple device enumeration from
setup but did not correctly lookup the i2c_dev_desc to store the new
device, instead dereferencing an uninitialized variable.

Lookup the device that has already been registered by address to store
the i2c client device.

Fixes: 31b9887c7258 ("i3c: remove i2c board info from i2c_dev_desc")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220308134226.1042367-1-quic_jiles@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2241,8 +2241,13 @@ static int i3c_master_i2c_adapter_init(s
 	 * We silently ignore failures here. The bus should keep working
 	 * correctly even if one or more i2c devices are not registered.
 	 */
-	list_for_each_entry(i2cboardinfo, &master->boardinfo.i2c, node)
+	list_for_each_entry(i2cboardinfo, &master->boardinfo.i2c, node) {
+		i2cdev = i3c_master_find_i2c_dev_by_addr(master,
+							 i2cboardinfo->base.addr);
+		if (WARN_ON(!i2cdev))
+			continue;
 		i2cdev->dev = i2c_new_client_device(adap, &i2cboardinfo->base);
+	}
 
 	return 0;
 }


