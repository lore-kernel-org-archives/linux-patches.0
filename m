Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147AE3D6D;
	Mon, 23 Dec 2024 16:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970160; cv=none; b=QZEX0/SWDhIFsF4kR/oSvWPEKlnn6G3HStjkqjgQxQqJABElY7iiRvMSdlNrIWpGHGfeHoTb5jPRkBgEEAMq9mM1iN57DSTxXCggN9E1y7LBGEbGufagr9BKyFtYxLlBHhgCXVri4eMP1HI3qBBx+PlmsBdh5D0kvueYloFEPJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970160; c=relaxed/simple;
	bh=SOCf3oSvgc3/8RByBORzh15JWXKi9Ycg2AwVa2CsMTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdH19qRN5x5/uIZhocSB967BVO/zwYuoCvwiwhkig62tt5bAioI7Z6ichokl4bhlrBPWIzKaYAI23sjXkB8henyi9BDoBGhZzraeYe4QIUtnOBi+C7LSL+bNpdPbDZ8+Mvt2Klk+KwOVwNsOUmazfJYWzH6CnDNILkP9QiOGwcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIRK+z/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIRK+z/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1826CC4CED3;
	Mon, 23 Dec 2024 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970159;
	bh=SOCf3oSvgc3/8RByBORzh15JWXKi9Ycg2AwVa2CsMTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIRK+z/8Ua1p2GP93mJguSfc4YVDfEIco4d39ufjOjA12yr5hCCoq8L9htfeHbVRt
	 clIR04SbszUQeJb2ZfiMcwIrupJEQMfj/Qv2dgnIWirXoEwiylkopiLCUXra26KA0O
	 kqdoS1LntZEH9J+l5J7jrGEZCFi7WIvd5w0i5HyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea della Porta <andrea.porta@suse.com>,
	Herve Codina <herve.codina@bootlin.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 148/160] of: address: Preserve the flags portion on 1:1 dma-ranges mapping
Date: Mon, 23 Dec 2024 16:59:19 +0100
Message-ID: <20241223155414.530196639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea della Porta <andrea.porta@suse.com>

commit 7f05e20b989ac33c9c0f8c2028ec0a566493548f upstream.

A missing or empty dma-ranges in a DT node implies a 1:1 mapping for dma
translations. In this specific case, the current behaviour is to zero out
the entire specifier so that the translation could be carried on as an
offset from zero. This includes address specifier that has flags (e.g.
PCI ranges).

Once the flags portion has been zeroed, the translation chain is broken
since the mapping functions will check the upcoming address specifier
against mismatching flags, always failing the 1:1 mapping and its entire
purpose of always succeeding.

Set to zero only the address portion while passing the flags through.

Fixes: dbbdee94734b ("of/address: Merge all of the bus translation code")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea della Porta <andrea.porta@suse.com>
Tested-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/e51ae57874e58a9b349c35e2e877425ebc075d7a.1732441813.git.andrea.porta@suse.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -455,7 +455,8 @@ static int of_translate_one(struct devic
 	}
 	if (ranges == NULL || rlen == 0) {
 		offset = of_read_number(addr, na);
-		memset(addr, 0, pna * 4);
+		/* set address to zero, pass flags through */
+		memset(addr + pbus->flag_cells, 0, (pna - pbus->flag_cells) * 4);
 		pr_debug("empty ranges; 1:1 translation\n");
 		goto finish;
 	}


