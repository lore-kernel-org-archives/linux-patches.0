Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C992D0C79;
	Thu, 25 Jun 2026 13:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393107; cv=none; b=mdDpfuHvl4f3z6RXYykaXJoNQ8YJvnBu3BpzWTLi3DDDFFJ8UOZNqWJ6ekWvLzyn8g6s9/Z41hR6fI6ZTOHLR6Oi3OqiFD83SJfHyDEVrbc2zjGMDuziNBIKZ7zVlZs8HyrowXKX5gQ44tC+u5XifLKvMLHDsCfEN1/eq+dURig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393107; c=relaxed/simple;
	bh=idwGSNy0iR1d8U/bkKyXtviLGKpL00JieL3Vtqc6SVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bs/fOcW3AgqYm9QWVLt8qi1ZPye6LIba8WvGiv8D4AuDS6gEsQkTef3F7Z32Uej5gu3Dk7Ele98bjD5vGuakL9wP6j172rhg1fxKfRDg9SuHIRRsCrbwRrUArWoP+iG5ozorPE0HMynZZ1WzNJHHpkGTzRxGucE3HvdXMtXf3Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1GdjCxp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1GdjCxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F5B1F00A3A;
	Thu, 25 Jun 2026 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393103;
	bh=6Sfp5JF/kFR7IMGIBDFcbUSjftj2A7NttVcigqvYya0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1GdjCxpY4rGK4Ipe3y7v2+8wP0viE1Z0uUVTn4hUh11HUz/7tH//4Op7yfWUUlCQ
	 v/Kx6AEgcHklUWqUMnROaxazV9X1WIfwxUVi3aUvAwJPE8DKl572w1RgtiSBioLWXl
	 DKzphsKaljT4H+EYbvpaCdTOmQvXp8Uht6D8kPyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.0 35/49] Input: rmi4 - fix register descriptor address calculation
Date: Thu, 25 Jun 2026 14:03:47 +0100
Message-ID: <20260625125642.463620750@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


