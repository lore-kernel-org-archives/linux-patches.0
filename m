Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550D74F405E;
	Wed, 30 Sep 2026 17:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791123; cv=none; b=c3xthbc2gwsmyi9sLlBqt5+mRaHwBsmzJjAbBDaFZIEzQPLqVs/zoHw3qCtg7YwMOLv8AqjS4Z/Am8QoL8dc2VXVNBnUQVBelUyU/COUsofP+iZtH2W8Q053Wi9FlQ/rnd9uS5X9Z6me01sCJd3NGhZH6Va2/SdZiYxa8LlPT7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791123; c=relaxed/simple;
	bh=2mI2RhKYPIqQNh8HyIG/l8AK/1sJehcr8UGr8Y4kLSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SGOy9nAiICkT6xqMLHk8iydjKiNTbw91Kgjy5eWOzY+5X2VSCcjHL3Ox1n7WSf4M8jDsLxTlB6ABaPHkzlI3RtBXXcI/8yzxiXteJm1Qxc2Cdaahp3G/5/+3rVHoNkRh5KiMBBEdN5ejSmln93I1pAAu7VsmpLTXq/OB2w7mkhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrGk9Rg+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrGk9Rg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90881F000FF;
	Wed, 30 Sep 2026 17:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791122;
	bh=tEShROgHJEIR54DLvwOSSh5NSSexbIkqUqgkTEB9cPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrGk9Rg+jGwHz7/2eow0kHiOtxEg7EmPuUOruU+16e6MHh6F0ZTCwswJkbXYUDfbt
	 x/TKvrJikOFOwQhcg7mx48AsS6fAigc7/dfeoRWpdZNdFR75we3ro5GZ3M9NhNeSIp
	 Z9g0OCfEiOccMOAVfmFMjAeadUNiVxNzIMlMOdfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/752] PCI/sysfs: Use kstrtobool() to parse the ROM attribute input
Date: Wed, 30 Sep 2026 17:20:45 +0200
Message-ID: <20260930152401.989646754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 92742802ecbf215a2b60dcfd326d2213595010f1 ]

pci_write_rom() controls access to the ROM content through the
corresponding sysfs attribute, and treats the input as a request to
disable only when it matches the string "0\n" exactly:

  if ((off ==  0) && (*buf == '0') && (count == 2))

The count == 2 condition encodes the trailing newline that echo(1) appends.
This was found when userspace wrote "0" without a trailing newline aiming
to disable access, which failed to match the condition above and enabled
access instead.  For example:

  $ echo 0 > rom       # "0\n", count 2, access disabled
  $ echo -n 0 > rom    # "0", count 1, access enabled
  $ echo > rom         # "", count 1, access enabled (likely not desirable)

Parse the input with kstrtobool(), which handles common boolean inputs such
as "0", "1", "n", "y" or "off", "on", with or without a trailing newline,
so both of the above disable access, and update the now stale comment.

As a side effect, input that does not parse as a boolean is rejected with
-EINVAL rather than enabling access.  The documented "0" and "1" continue
to work as before, and rejecting malformed input brings the attribute in
line with how sysfs attributes typically handle it.

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260612182448.552406-1-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 33847e32fb429..69f44a4e14064 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1343,18 +1343,19 @@ void __weak pci_remove_resource_files(struct pci_dev *dev) { return; }
  * @off: file offset
  * @count: number of byte in input
  *
- * writing anything except 0 enables it
+ * Writing a boolean value enables or disables the ROM display.
  */
 static ssize_t pci_write_rom(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr, char *buf,
 			     loff_t off, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
+	bool enable;
 
-	if ((off ==  0) && (*buf == '0') && (count == 2))
-		pdev->rom_attr_enabled = 0;
-	else
-		pdev->rom_attr_enabled = 1;
+	if (kstrtobool(buf, &enable))
+		return -EINVAL;
+
+	pdev->rom_attr_enabled = enable;
 
 	return count;
 }
-- 
2.53.0



