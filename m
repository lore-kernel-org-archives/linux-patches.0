Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3173F446C9;
	Tue, 20 Feb 2024 21:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465041; cv=none; b=qetU23FNe16TOJK6W3Bf9gk9cmcaLic/fsTSDxxdFLGx8WCmhaVaCLXWMUj0lq2LgexX6WZRVq7jWtz9Yr4Jk6meyXE+BFayXaFHsmCiI8SPec+lZgRv4PfY9sHKLAVUaIrRowjiWX6sMBzYJVPg9uKjwfR+rUhYp5+OkmiSCyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465041; c=relaxed/simple;
	bh=UheyVkCCLsDTQXs2hM12vBxuaKDuupvTLa64lXQYkOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyRWreuoZ+r8OOqLqXJZ2LryHW0m+Eu/WIVzOPT/u6f8i8l7TOnzR0U3fs8fJkstpX3Nsh1DAYzZv9j4uekdgce3kV9Nyze807XzIVq5okJCnRB+uS43+FqP39fRYDFVc52de32n9Zwll2eyrvn1y7asxZYqVlav8iUts8EwJfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpemyf4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpemyf4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7715C433C7;
	Tue, 20 Feb 2024 21:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465041;
	bh=UheyVkCCLsDTQXs2hM12vBxuaKDuupvTLa64lXQYkOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpemyf4OElofS3bgOdfq0p0RUZarZl5+VYQKJNRAhrsOiA0pS0lEzqCD3CyvCTmuI
	 ZQTdU71lwbV35gOOeswRLdZU0yc8pRY2RLgX2QK0EzNO0RK1RRjjcvlan33KVVa1kL
	 bvkVFOAUVWYI3jt4HEDid8NCC2nnbjSPjItj9Sqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Menninger <tmenninger@purestorage.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 217/309] net: dsa: mv88e6xxx: Fix failed probe due to unsupported C45 reads
Date: Tue, 20 Feb 2024 21:56:16 +0100
Message-ID: <20240220205639.955622178@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


