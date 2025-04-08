Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BD3269833;
	Tue,  8 Apr 2025 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111770; cv=none; b=idnihAIZyXK7DRjAz/RPCXPSyH5Lt+H0+XPaD81lhj7t7ZeSH1Ud5NciZbhr+K1UbefHKTOfIBlqqFE2Pgq1dT3qFM3bDAd59UNizd2+Zf+e/7oZJpx2wNwC691NNJ6kH/f3zCfV9FObjGFdDeG/Pu6zWA8ZmPJjTWElwChkwF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111770; c=relaxed/simple;
	bh=kn5FxPpMGKwAojjf1+QX3ErnGKkHnmhnZl+HyOS8zTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZNq0V3NLa5VE4r/mbmGOA5RBWVvY5/4yovap7nzV6WOqjG69gDVEdB1M6irfFhSGblpyxPcWA+YrO/Ig8bhHqGqYS1DaMpPXttKq1JIVtXRGOCHqFh7ly06m4Q/uYQ75eC3fZK8YxElS1HesYzNsCWsyuHVh67hKlil0v+CGjh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7cYpF9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7cYpF9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D7FC4CEE5;
	Tue,  8 Apr 2025 11:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111769;
	bh=kn5FxPpMGKwAojjf1+QX3ErnGKkHnmhnZl+HyOS8zTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7cYpF9breipF1+qRCbCPyuV2gzTP8VRh4nON35JKYTTgxMVGtFaTjiHBa1ZBizkd
	 gTKSS4cYBZv9GXyc37brv9YRaCUrlc+SuL8ZhnU/5r+R4dgW/yV2mmRcmUeseSkpNe
	 fFfN3qiMmxeC55jjrjfGGEAR9lxIp4acjVk1wC1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 514/731] scripts/gdb/linux/symbols.py: address changes to module_sect_attrs
Date: Tue,  8 Apr 2025 12:46:51 +0200
Message-ID: <20250408104926.230629412@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@mandelbit.com>

[ Upstream commit e0349c46cb4fbbb507fa34476bd70f9c82bad359 ]

When loading symbols from kernel modules we used to iterate
from 0 to module_sect_attrs::nsections, in order to
retrieve their name and address.

However module_sect_attrs::nsections has been removed from
the struct by a previous commit.

Re-arrange the iteration by accessing all items in
module_sect_attrs::grp::bin_attrs[] until NULL is found
(it's a NULL terminated array).

At the same time the symbol address cannot be extracted
from module_sect_attrs::attrs[]::address anymore because
it has also been deleted. Fetch it from
module_sect_attrs::grp::bin_attrs[]::private as described
in 4b2c11e4aaf7.

Link: https://lkml.kernel.org/r/20250221204034.4430-1-antonio@mandelbit.com
Fixes: d8959b947a8d ("module: sysfs: Drop member 'module_sect_attrs::nsections'")
Fixes: 4b2c11e4aaf7 ("module: sysfs: Drop member 'module_sect_attr::address'")
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/symbols.py | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
index f6c1b063775a7..15d76f7d8ebce 100644
--- a/scripts/gdb/linux/symbols.py
+++ b/scripts/gdb/linux/symbols.py
@@ -15,6 +15,7 @@ import gdb
 import os
 import re
 
+from itertools import count
 from linux import modules, utils, constants
 
 
@@ -95,10 +96,14 @@ lx-symbols command."""
         except gdb.error:
             return str(module_addr)
 
-        attrs = sect_attrs['attrs']
-        section_name_to_address = {
-            attrs[n]['battr']['attr']['name'].string(): attrs[n]['address']
-            for n in range(int(sect_attrs['nsections']))}
+        section_name_to_address = {}
+        for i in count():
+            # this is a NULL terminated array
+            if sect_attrs['grp']['bin_attrs'][i] == 0x0:
+                break
+
+            attr = sect_attrs['grp']['bin_attrs'][i].dereference()
+            section_name_to_address[attr['attr']['name'].string()] = attr['private']
 
         textaddr = section_name_to_address.get(".text", module_addr)
         args = []
-- 
2.39.5



