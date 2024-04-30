Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E2C211C;
	Tue, 30 Apr 2024 11:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475626; cv=none; b=K5WQ94gjDnvlt/xQgf3VeH2iEF92vrJJt9RsYCQWlvXhG7SaFhcPsruW9wLGKPfMJRk+eNB9CVI41aHGVP8i3aD2XIpuawfwxdHMbXn3K0ajohKQvD1F7HWRXJZrYmA2H5YsUhZxvw1zAeqVZKZOm1hdayn2yW9P6n6XDac2zJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475626; c=relaxed/simple;
	bh=xaZlMGuoBQQpWEACIAYRigKSuIuTGvu41kmcIM2kXRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leJKqErfwKrboDj/OlAdQG3ethMO3/adWfh9TJ/ZT2zJGvBmVX8v92a7lmZu7yRxgMZTmlbtuv9VUxcVye6F4hDgiljbTL5DGFmizS8NualfK7r573VVWK+2bAyzz2TDGThm0xYZfnWxX3Gl1Sw8/f6jPLr3ViO0t5Wi0+Bbxug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSSpx+Ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSSpx+Ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CBAC2BBFC;
	Tue, 30 Apr 2024 11:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475626;
	bh=xaZlMGuoBQQpWEACIAYRigKSuIuTGvu41kmcIM2kXRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSSpx+NyIcY9L6XeYnPBOU8Xy5SLW/cbDW/fMbHFNQwN9RnXhxczijWeoJCb8k0x3
	 O26wcowNwysWt1ckXJR7tKeOIvAn4DPXYB9x2EDS+4/O8xDG+dEMHvRLR/EdaT21Wr
	 u+PDXbnIwrqh5hcIkjM4SdH1DOQlX3W3l6+Fm6ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 153/186] mtd: diskonchip: work around ubsan link failure
Date: Tue, 30 Apr 2024 12:40:05 +0200
Message-ID: <20240430103102.475647456@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 21c9fb611c25d5cd038f6fe485232e7884bb0b3d upstream.

I ran into a randconfig build failure with UBSAN using gcc-13.2:

arm-linux-gnueabi-ld: error: unplaced orphan section `.bss..Lubsan_data31' from `drivers/mtd/nand/raw/diskonchip.o'

I'm not entirely sure what is going on here, but I suspect this has something
to do with the check for the end of the doc_locations[] array that contains
an (unsigned long)0xffffffff element, which is compared against the signed
(int)0xffffffff. If this is the case, we should get a runtime check for
undefined behavior, but we instead get an unexpected build-time error.

I would have expected this to work fine on 32-bit architectures despite the
signed integer overflow, though on 64-bit architectures this likely won't
ever work.

Changing the contition to instead check for the size of the array makes the
code safe everywhere and avoids the ubsan check that leads to the link
error. The loop code goes back to before 2.6.12.

Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240405143015.717429-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/diskonchip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/diskonchip.c
+++ b/drivers/mtd/nand/raw/diskonchip.c
@@ -53,7 +53,7 @@ static unsigned long doc_locations[] __i
 	0xe8000, 0xea000, 0xec000, 0xee000,
 #endif
 #endif
-	0xffffffff };
+};
 
 static struct mtd_info *doclist = NULL;
 
@@ -1552,7 +1552,7 @@ static int __init init_nanddoc(void)
 		if (ret < 0)
 			return ret;
 	} else {
-		for (i = 0; (doc_locations[i] != 0xffffffff); i++) {
+		for (i = 0; i < ARRAY_SIZE(doc_locations); i++) {
 			doc_probe(doc_locations[i]);
 		}
 	}


