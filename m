Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90826176ADB;
	Tue,  8 Jul 2025 16:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992148; cv=none; b=q0e1oJgKLGBtMKrfhLeAiQIZVv89k4JjpcS16uQU2lR7Y/4C/su/ISzfd13d40+2pgfQaMRuS+YZ3fH0TK62LaNx8H9OIz1uyg5gZ/PC+iJe3Il+ekkYwaR6D3RcBjkOxG2/hoUtoDLufAtSQH9nHTG9noTRrZYaxOCwveybe3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992148; c=relaxed/simple;
	bh=IrSQ4ent8xYdRZnzI5n0cvwfkv7n/UlV6qndZ2GyaYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9sBZl1Ea4TEWcrQ2gXcAACeyMXUzmMYz1QmkQwnzTwRp8Pr7lvXmoxXkXayMcdAttvLneUvHp6A49jweHc4cMmDqV4OJ2MlSDaCnX6r36EvxvzSRL1i1zfeEcpq+zLF3J7IyE/FN2UcbskPXvY4piOCF+E7piua2Vu3dAT58R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+EOrk1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+EOrk1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2D5C4CEED;
	Tue,  8 Jul 2025 16:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992148;
	bh=IrSQ4ent8xYdRZnzI5n0cvwfkv7n/UlV6qndZ2GyaYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+EOrk1fJcArb8CRrKSsw3qj+H7BLAPM5MLDRndN8ZxRhs5lG/f553Z80//RxXgX6
	 6KGoGUW98MjzqjEAZctUH6m+G7FdKqE+YYxvGUBEjNLIja30J+ayIrFCvQvBjap9Yp
	 BU9gT2shU8EPAitWsOfvi4Exsl8q9X1cb3crSFXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 73/81] i2c/designware: Fix an initialization issue
Date: Tue,  8 Jul 2025 18:24:05 +0200
Message-ID: <20250708162227.264470208@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

commit 3d30048958e0d43425f6d4e76565e6249fa71050 upstream.

The i2c_dw_xfer_init() function requires msgs and msg_write_idx from the
dev context to be initialized.

amd_i2c_dw_xfer_quirk() inits msgs and msgs_num, but not msg_write_idx.

This could allow an out of bounds access (of msgs).

Initialize msg_write_idx before calling i2c_dw_xfer_init().

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 17631e8ca2d3 ("i2c: designware: Add driver support for AMD NAVI GPU")
Cc: <stable@vger.kernel.org> # v5.13+
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250627143511.489570-1-michael.j.ruhl@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-master.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -298,6 +298,7 @@ static int amd_i2c_dw_xfer_quirk(struct
 
 	dev->msgs = msgs;
 	dev->msgs_num = num_msgs;
+	dev->msg_write_idx = 0;
 	i2c_dw_xfer_init(dev);
 	i2c_dw_disable_int(dev);
 


