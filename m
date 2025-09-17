Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DA62FBDE4;
	Wed, 17 Sep 2025 12:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112703; cv=none; b=S/nhFIWKKSHMVFpw0VRqaGUG+r3dYtC/amkvqvNA2mj4MYs3bpgeMf+5ooWqPdZzwJu70qtVMBtgSdyzrqeE17gYVsnRCr/kCqXQLrjNqTNVNaKpy4sIv76+dQVP6C+zRj/vUNJWFHmCN75x6amSDD5uXxm3TPOAYPJtv6V6YB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112703; c=relaxed/simple;
	bh=wNKrVQ+wOlR/DM2PsW6d0KIbrHhDW5pcxatVChxr/lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyYADK/2F/q8VXcHP8BAcOkNUE++hLjU0EtD88y/UpyI1jOuWItdwpIPUs93v9GBMhOe+vgx3vGjayFdUcdey3EN9fq66QxigegxGbJlvZFso1GP89SYg8gKgGumUokd67llr038iPN/16JM3h2dRoaqYy/DSfN+VtR4bYM1QR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOF+B8lO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOF+B8lO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2B6C4CEF0;
	Wed, 17 Sep 2025 12:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112703;
	bh=wNKrVQ+wOlR/DM2PsW6d0KIbrHhDW5pcxatVChxr/lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOF+B8lO4EvqL8em9QsNh9zYduxTJKdlmshfV8X9c+xPq2xXePRdC/7lXJV98E+ig
	 u79KCwv7E9WfZMFgb2S8dZnr2lwWUAAeO5I12ksWl45ELhdSTSZLyOO3k9mWd2+uxj
	 x2guq2uc/eZx4kPP/tqn17W+ZEaF54nU/d76mWdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Jelonek <jelonek.jonas@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.16 049/189] i2c: rtl9300: fix channel number bound check
Date: Wed, 17 Sep 2025 14:32:39 +0200
Message-ID: <20250917123353.061335856@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Jelonek <jelonek.jonas@gmail.com>

commit cd6c956fbc13156bcbcca084b46a8380caebc2a8 upstream.

Fix the current check for number of channels (child nodes in the device
tree). Before, this was:

if (device_get_child_node_count(dev) >= RTL9300_I2C_MUX_NCHAN)

RTL9300_I2C_MUX_NCHAN gives the maximum number of channels so checking
with '>=' isn't correct because it doesn't allow the last channel
number. Thus, fix it to:

if (device_get_child_node_count(dev) > RTL9300_I2C_MUX_NCHAN)

Issue occured on a TP-Link TL-ST1008F v2.0 device (8 SFP+ ports) and fix
is tested there.

Fixes: c366be720235 ("i2c: Add driver for the RTL9300 I2C controller")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Tested-by: Sven Eckelmann <sven@narfation.org>
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Tested-by: Chris Packham <chris.packham@alliedtelesis.co.nz> # On RTL9302C based board
Tested-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250831100457.3114-2-jelonek.jonas@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-rtl9300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-rtl9300.c
+++ b/drivers/i2c/busses/i2c-rtl9300.c
@@ -353,7 +353,7 @@ static int rtl9300_i2c_probe(struct plat
 
 	platform_set_drvdata(pdev, i2c);
 
-	if (device_get_child_node_count(dev) >= RTL9300_I2C_MUX_NCHAN)
+	if (device_get_child_node_count(dev) > RTL9300_I2C_MUX_NCHAN)
 		return dev_err_probe(dev, -EINVAL, "Too many channels\n");
 
 	device_for_each_child_node(dev, child) {


