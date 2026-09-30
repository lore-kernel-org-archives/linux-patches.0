Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD79250B8B1;
	Wed, 30 Sep 2026 16:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784638; cv=none; b=gowLOvEOE8wuAoRPDvc6dasQ3Y0UsdGwEzzpx34K8Rc23qm67gqij/u3//7B9vckTcRagIMsCGky4krnDYqMpwxe+NN5/jlbrO/a6jLW6/DWAk3SJhDuoq6JinqZd7v4Z7aiOq5o6TAZZPZLZ9BGwAIglIWWVV33jKZxmzllfbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784638; c=relaxed/simple;
	bh=Z4TlapksZSlBluWm0kibR+vHIgNyH058XUCKF/JgO6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OaAeeMLFGuRgaX9ZDVL5ObyAyj8MJj+2O9Ux8T4DXgbrPc9Hk1cpXy4CqbEhWW+av4B/D4j8MjIHJY1Y50EhkhizZPt3sKM6IoxAsLCdra+qjsRwhZCiTSldp+O0P5OtsS0+l5CppVLGH21YlZnB1WRgvWoc6TeOBiuXEN2yYhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6JGpHdj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6JGpHdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912931F00899;
	Wed, 30 Sep 2026 16:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784632;
	bh=Q5baW9KBHjNI/QM/ApG+/dE2u6N+N0fOa/h6InF2TCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6JGpHdjG6kcepXy6v4mYQ/lUhGi2uJwMwp7wKYeWwrxZxWOvZACweCyrOI1utWAR
	 gHTluWZw/h5KhvYIfpqn0nOO1DVLDvhA2j7BnqNMt9toSXHZ8P6gYwQF2KDEtMFpqL
	 kfiHjsPDWR8g77ui0y6ImOv7j4qXM8W6J4qC0C+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 224/982] PCI/sysfs: Use kstrtobool() to parse the ROM attribute input
Date: Wed, 30 Sep 2026 17:16:00 +0200
Message-ID: <20260930152421.610780568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2b7d20dcc37f7..d0ec908908303 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1305,18 +1305,19 @@ void __weak pci_remove_resource_files(struct pci_dev *dev) { return; }
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



