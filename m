Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1E62EC086;
	Thu, 25 Jun 2026 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393138; cv=none; b=FvZnbkNpEzjdSgJwycg5NQoHbYX07mobYID0RM+rZD5MU6IG6kgwo4mFu/2nYdxDj/wazNfQzKLix9rTKtyGvUoP0rf7jB7Y52I8U0jkLU+jD0oa8OTYlCwyNFaG+F1hfF9OGKoc+liOdJLnghXaf2sf/raLOJi6AY0DCDZKJV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393138; c=relaxed/simple;
	bh=D81KOzLhDndSB2nazroX4QfkNTHZkGQApGxxg6iue84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlIaFcK76d2moaSmh4ZWlIdMBL8l8ntb9BNgE7LU86hOyau33RRmH+gfwYD1/IIia/pMA+MvUu/q6247ZcoeEjlUpHYKaXQvlm4xAZx9wOcHDFrR/8tuAuAFnQ3GzknDRsGKsUTgXGXTY9ch0peldGEJQnknhhTcO/WEQTXRt/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8mvQG8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8mvQG8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EE61F000E9;
	Thu, 25 Jun 2026 13:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393136;
	bh=CU/c9OScvD64qdALd8C+qqOPUWucTC/B7tPCzs9ShVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8mvQG8FOKX3a5eo8bwwntLnjg20j5WGEjSke53NitaxRP3JtmhZlOQkJl/UJE8IP
	 04w4qI04Bt3+EVxNQQJTBXXUWjJH9texkYVHqU9Z9EVVnw4+Dq5uePBPx5BaxaPIpv
	 0jhKHbOLB0+EZzEmVs2U6ZxR3728FzvQjbHqdJuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 07/21] Input: rmi4 - fix register descriptor address calculation
Date: Thu, 25 Jun 2026 14:03:59 +0100
Message-ID: <20260625125614.261693623@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit a98518e72439fd42cbfe641c2896543cb088e3d1 upstream.

When reading the register descriptor, the base address is incremented by
1 to read the presence register block. However, after reading the
presence register block, the address is incorrectly incremented by only
1 byte (++addr) instead of the actual size of the presence block
(size_presence_reg). This causes the subsequent structure block read to
read from the wrong memory location if the presence block is larger than
1 byte.

Fix this by advancing the address by size_presence_reg.

Fixes: 2b6a321da9a2 ("Input: synaptics-rmi4 - add support for Synaptics RMI4 devices")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Link: https://patch.msgid.link/20260505045952.1570713-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -594,7 +594,7 @@ int rmi_read_register_desc(struct rmi_de
 	ret = rmi_read_block(d, addr, buf, size_presence_reg);
 	if (ret)
 		return ret;
-	++addr;
+	addr += size_presence_reg;
 
 	if (buf[0] == 0) {
 		presense_offset = 3;


