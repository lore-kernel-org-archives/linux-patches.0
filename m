Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E434612D7;
	Tue, 20 Feb 2024 21:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463865; cv=none; b=MzG6crjO01EVpVQd0VkXQKw2YJWOw4Jjz+HQw7/2lgncoLrWC1ytYJGlbCI2yI8E4NKnR2087BhXa+ZcLzjRpxxNlEbGfG2d06cmZ6dEvBgmPnTrlYuJbgt7I8UXvqrGxr8S+Ql+YrUxN4XFHwdqJ2gB5GN1BjcMDhY3kXyjPKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463865; c=relaxed/simple;
	bh=sNCv/W/mR0K20h1YhMGve28ki9LmfFJ5ZyJa7x/t6Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nr9ua6+TzwYQJ+YYyj4YOQK6yasuVNesoTAtlq5vg+AqLmDHuV7hKXMXOiLfLTIkKG8cl2cA7WbEoT1x6RXX9Ef7c2oydgFl3Lzyyv7py9d37htHYSUiYF3ZD2O1MW/zvViugP7zR9TJkRGzR7icnUBrUgIUsEOJKu8rD5SxTFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLd/sXMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLd/sXMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C18CC433C7;
	Tue, 20 Feb 2024 21:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463865;
	bh=sNCv/W/mR0K20h1YhMGve28ki9LmfFJ5ZyJa7x/t6Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLd/sXMwlm/pftse9mnp/dqSXZsquYF8ptfqRJBg256AAQ2lcGvxhm98k3sx7Dv04
	 Pk8ZJ/NIqyjf9wgoHeWtXFJ42L6u8deiYsynDI3mBGS4gpMVI/OTwlcVa36qf+sGIu
	 acXgfbdFMAkZqUNk4HwoSL2mVwSfhrBcwBm6XAQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Menninger <tmenninger@purestorage.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 176/331] net: dsa: mv88e6xxx: Fix failed probe due to unsupported C45 reads
Date: Tue, 20 Feb 2024 21:54:52 +0100
Message-ID: <20240220205643.042300352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 585b40e25dc9ff3d2b03d1495150540849009e5b upstream.

Not all mv88e6xxx device support C45 read/write operations. Those
which do not return -EOPNOTSUPP. However, when phylib scans the bus,
it considers this fatal, and the probe of the MDIO bus fails, which in
term causes the mv88e6xxx probe as a whole to fail.

When there is no device on the bus for a given address, the pull up
resistor on the data line results in the read returning 0xffff. The
phylib core code understands this when scanning for devices on the
bus. C45 allows multiple devices to be supported at one address, so
phylib will perform a few reads at each address, so although thought
not the most efficient solution, it is a way to avoid fatal
errors. Make use of this as a minimal fix for stable to fix the
probing problems.

Follow up patches will rework how C45 operates to make it similar to
C22 which considers -ENODEV as a none-fatal, and swap mv88e6xxx to
using this.

Cc: stable@vger.kernel.org
Fixes: 743a19e38d02 ("net: dsa: mv88e6xxx: Separate C22 and C45 transactions")
Reported-by: Tim Menninger <tmenninger@purestorage.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240129224948.1531452-1-andrew@lunn.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3545,7 +3545,7 @@ static int mv88e6xxx_mdio_read_c45(struc
 	int err;
 
 	if (!chip->info->ops->phy_read_c45)
-		return -EOPNOTSUPP;
+		return 0xffff;
 
 	mv88e6xxx_reg_lock(chip);
 	err = chip->info->ops->phy_read_c45(chip, bus, phy, devad, reg, &val);


