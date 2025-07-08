Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA35B2E54AD;
	Tue,  8 Jul 2025 16:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992518; cv=none; b=jazuc2P6H9Dsmpqci6SL82uQVSd8lXdAoW7u5xBIH6rXlW9BtDskM5JDfhdNhkbFcDalnOZVyHj/q2kq5+Tjnm2/8sBLVlUZMYwi9HYRTEDZCCZrhcTbNBkX89V5GwzZmpP3fASX5VfqYOu4GEE14kfTPZ2bKqjL0sMEYtLLdDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992518; c=relaxed/simple;
	bh=FsvNyFMyTFaP+2q5pJzcE8l4L2NTcRe/4E0wXry/fwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPN9kqTbAUefJU9cCGPxi/gS6dyiW8REEOUJ4sbQqABqfisDOe6pxgHLzIhfxBRZ15KGiapUbq/XZYhRQW9XmgABZGfT4owQL/m6Wd44xdz9DN1t48fp5ZLNMzHPQLWHywPcXrLXId20F3yDnZb7typQwOLXaGeJsEgox/KJODU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtSHYWDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtSHYWDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7353CC4CEED;
	Tue,  8 Jul 2025 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992517;
	bh=FsvNyFMyTFaP+2q5pJzcE8l4L2NTcRe/4E0wXry/fwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtSHYWDj0VdHDzPw8amiaBSOtjVJwu5vfL5Y6a57ZS7k9ynzRz5K9/vsr3EoI4iH2
	 yfmwzqiZCqCRH34MfPf963bEASVVadq5eIH1EV2faGoEX5KxoMHSnsMnP85jHPZfVi
	 oUvBq5sH5gMYjwvAMge59iBEdTDicnnvb7vg9GeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 119/132] i2c/designware: Fix an initialization issue
Date: Tue,  8 Jul 2025 18:23:50 +0200
Message-ID: <20250708162234.029989768@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -327,6 +327,7 @@ static int amd_i2c_dw_xfer_quirk(struct
 
 	dev->msgs = msgs;
 	dev->msgs_num = num_msgs;
+	dev->msg_write_idx = 0;
 	i2c_dw_xfer_init(dev);
 	regmap_write(dev->map, DW_IC_INTR_MASK, 0);
 


