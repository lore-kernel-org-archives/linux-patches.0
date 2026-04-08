Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202383D891A;
	Wed,  8 Apr 2026 18:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673421; cv=none; b=d66oG6vPpPZwVkRjOH1zddRmOIIi3hrCuG5c/zRPnK+g++n7K4Yghdft8vYnBlkmFMH6vsZVQSMlhuxZZxPPLNPruVxRUpeu5VvTaS1kmAp2DkwNFFXc29X/irwKEXC/FWpUcSJCWfBqtV6qwKv/wJwtmaj+zIL6i7RIhlW2sJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673421; c=relaxed/simple;
	bh=iydF4n1OftLYpxjD7OuB9LfeTITkcoXfFU/wVFS+F5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZ6KNGx4WdmZV8dtC5jyIgzA+VARs5RmIu7rxJ+GC/6N7YeLrFIsHnKiTboU0ZMiyW9HgktQNBNq9TTVnGZ92LbbJrG7Pb0UiqbvD6RICxkqnUcNrGIsrkun/fI6BV9FnxTIYJuV0NskeMFqd+uERTCwumpqXcGRpwF67XWkvIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mG3ZqZOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mG3ZqZOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5E6C19421;
	Wed,  8 Apr 2026 18:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673421;
	bh=iydF4n1OftLYpxjD7OuB9LfeTITkcoXfFU/wVFS+F5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mG3ZqZOYDLi3jXHDCA9gdE4TT6MXgWHnQFF6we234IefOXBdpqWZSBMJlCfD/wPch
	 7JvYAAg1Izk722IJAy7k2qV085ClTJqs5o4b7ExSKwD9PpD16+1CYh2ADio+ibMcVj
	 bN/EgHpANqnK2uImrgmAF97jAXbsDw1otBDQab3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	kernel test robot <lkp@intel.com>,
	stable <stable@kernel.org>,
	Dave Penkler <dpenkler@gmail.com>
Subject: [PATCH 6.18 226/277] gpib: Fix fluke driver s390 compile issue
Date: Wed,  8 Apr 2026 20:03:31 +0200
Message-ID: <20260408175942.295372343@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

commit 579af7204d762587f9cce0d6236a710a771f1f6f upstream.

The following errors were reported for a s390 randconfig build
of the fluke gpib driver:

>> drivers/gpib/eastwood/fluke_gpib.c:1002:23: error: call to undeclared function 'ioremap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1002 |         nec_priv->mmiobase = ioremap(e_priv->gpib_iomem_res->start,
         |                              ^
>> drivers/gpib/eastwood/fluke_gpib.c:1002:21: error: incompatible integer to pointer conversion assigning to 'void *' from 'int' [-Wint-conversion]
    1002 |         nec_priv->mmiobase = ioremap(e_priv->gpib_iomem_res->start,
         |                            ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1003 |                                      resource_size(e_priv->gpib_iomem_res));
         |                                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/gpib/eastwood/fluke_gpib.c:1036:33: error: incompatible integer to pointer conversion assigning to 'void *' from 'int' [-Wint-conversion]
    1036 |         e_priv->write_transfer_counter = ioremap(e_priv->write_transfer_counter_res->start,
         |                                        ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1037 |                                                  resource_size(e_priv->write_transfer_counter_res));
         |                                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Add HAS_IOMEM dependency to Kconfig for fluke driver option

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601221748.AFAqHieJ-lkp@intel.com/
Fixes: baf8855c9160 ("staging: gpib: fix address space mixup")
Cc: stable <stable@kernel.org>
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://patch.msgid.link/20260202094755.4259-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gpib/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/gpib/Kconfig
+++ b/drivers/staging/gpib/Kconfig
@@ -122,6 +122,7 @@ config GPIB_FLUKE
 	depends on OF
        select GPIB_COMMON
        select GPIB_NEC7210
+       depends on HAS_IOMEM
        help
          GPIB driver for Fluke based cda devices.
 


