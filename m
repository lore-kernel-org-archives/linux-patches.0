Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A3F326928;
	Sat, 12 Sep 2026 07:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198990; cv=none; b=TQLhHYtT8CJcY9THowSKqXshxx7NmQ/t4vzpKxNxsVdI0Z4hdpisAufmo+0HYt5Qc8hkk/Bd3uZzwYSK8g/KNiYWLaSN8PIM1Tg96x4bhlFx972wDcM4Rb3OoDfsmRatfLNQbOKDmqG+YfaSJ3q5k/eL3KEPJ4gzO+VLhHXR4Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198990; c=relaxed/simple;
	bh=RorKu2wGeMYwTDCEjIzbN/WFukHUBxwGv/lTszewshM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5GBCx5OIv+LpQ9Oe/gmn685TM+Pe552sojORVHVLCyTskp+P01QBga0QsGXOmEwvN+L75zHLzgNHdsPnMJMF3x+3dA/mCpP7FmVXByiR5JREfYSvn3W2fDu11TQcCs2nU5XvbtHdIiloMT9zaHzs3Ai6omrf4qHn4u5SZo2ctc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCcftOXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCcftOXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C101F000FF;
	Sat, 12 Sep 2026 07:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198988;
	bh=fd1bJr0Ho8tgqLnG6FUygMWZ4ccsQkzrTlHxLXB8ub8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCcftOXXR/l/IPfD+HTe88bACsd2+EEHCfrmYhVoTs1UMRWso7MHlxwIvnzLAYhM3
	 DxO2sQ6T7sn7WKuK7yyBbqmrxin+11FU6ab+ifg7e0Nc/hTggZssS1A4jI8nvmAr4H
	 4EQS/k+9UUshe9ZUTDoX7meIJoD8EnGtVetGIbqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0492/1815] gpib: use static inline instead of extern inline
Date: Sat, 12 Sep 2026 08:37:22 +0200
Message-ID: <20260912065700.440106505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6cc667892818fe44bef02193dfb9c3f843ade2b2 ]

With GNU inline semantics, an 'extern inline' function is only included
in the build if it can be inlined. When the compiler for some reason
decides against inlining it, this causes a link failure, as observed in
one function in the tnt4882_gpib driver:

ld.lld: error: undefined symbol: mite_irq
>>> referenced by tnt4882_gpib.c:974 (/home/arnd/arm-soc/drivers/gpib/tnt4882/tnt4882_gpib.c:974)
>>>               drivers/gpib/tnt4882/tnt4882_gpib.o:(ni_pci_attach) in archive vmlinux.a

Change all of the 'extern inline' definitions in gpib to the regular
'static inline' to avoid this.

Fixes: 0cd5b05551e0 ("staging: gpib: Add TNT4882 chip based GPIB driver")
Fixes: 6c52d5e3cde2 ("staging: gpib: Add common include files for GPIB drivers")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260611131018.3662609-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpib/include/amccs5933.h | 10 +++++-----
 drivers/gpib/tnt4882/mite.h      |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpib/include/amccs5933.h b/drivers/gpib/include/amccs5933.h
index d7f63c7950963..f8a80bdc70dcc 100644
--- a/drivers/gpib/include/amccs5933.h
+++ b/drivers/gpib/include/amccs5933.h
@@ -13,7 +13,7 @@ enum {
 };
 
 // incoming mailbox 0-3  register offsets
-extern inline int INCOMING_MAILBOX_REG(unsigned int mailbox)
+static inline int INCOMING_MAILBOX_REG(unsigned int mailbox)
 {
 	return (0x10 + 4 * mailbox);
 };
@@ -29,25 +29,25 @@ enum {
 };
 
 // select byte 0 to 3 of incoming mailbox
-extern inline int INBOX_BYTE_BITS(unsigned int byte)
+static inline int INBOX_BYTE_BITS(unsigned int byte)
 {
 	return (byte & 0x3) << 8;
 };
 
 // select incoming mailbox 0 to 3
-extern inline int INBOX_SELECT_BITS(unsigned int mailbox)
+static inline int INBOX_SELECT_BITS(unsigned int mailbox)
 {
 	return (mailbox & 0x3) << 10;
 };
 
 // select byte 0 to 3 of outgoing mailbox
-extern inline int OUTBOX_BYTE_BITS(unsigned int byte)
+static inline int OUTBOX_BYTE_BITS(unsigned int byte)
 {
 	return (byte & 0x3);
 };
 
 // select outgoing mailbox 0 to 3
-extern inline int OUTBOX_SELECT_BITS(unsigned int mailbox)
+static inline int OUTBOX_SELECT_BITS(unsigned int mailbox)
 {
 	return (mailbox & 0x3) << 2;
 };
diff --git a/drivers/gpib/tnt4882/mite.h b/drivers/gpib/tnt4882/mite.h
index a1fdba9672a03..dd251afa90e34 100644
--- a/drivers/gpib/tnt4882/mite.h
+++ b/drivers/gpib/tnt4882/mite.h
@@ -45,12 +45,12 @@ struct mite_struct {
 
 extern struct mite_struct *mite_devices;
 
-extern inline unsigned int mite_irq(struct mite_struct *mite)
+static inline unsigned int mite_irq(struct mite_struct *mite)
 {
 	return mite->pcidev->irq;
 };
 
-extern inline unsigned int mite_device_id(struct mite_struct *mite)
+static inline unsigned int mite_device_id(struct mite_struct *mite)
 {
 	return mite->pcidev->device;
 };
-- 
2.53.0



