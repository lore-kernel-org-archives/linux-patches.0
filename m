Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D1A1549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DA9C433EF;
	Mon,  8 May 2023 10:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540594;
	bh=hmdACvyceHtfwG6iZa0TlefPkqSpVkF36kkn55rWHqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBU1ehTkqbN3L8h4eODB5pOA3HEeLbi1vof6yOkz1gpG6hxWCeJxLK2i+UWwniH55
	 p2ZLnlzWapawvT35wS6nxHAdNx4rEWeX6FyVE2Z/2oHjf7Mi4aHvejyhhjaAGz7lBq
	 h5NHk/dBaplKHb9Sdm2UvoGe2PBryxKoupmUND6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Leonard Crestez <leonard.crestez@nxp.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 425/611] scripts/gdb: bail early if there are no generic PD
Date: Mon,  8 May 2023 11:44:27 +0200
Message-Id: <20230508094436.016234952@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit f19c3c2959e465209ade1a7a699e6cbf4359ce78 ]

Avoid generating an exception if there are no generic power domain(s)
registered:

(gdb) lx-genpd-summary
domain                          status          children
    /device                                             runtime status
----------------------------------------------------------------------
Python Exception <class 'gdb.error'>: No symbol "gpd_list" in current context.
Error occurred in Python: No symbol "gpd_list" in current context.
(gdb) quit

[f.fainelli@gmail.com: correctly invoke gdb_eval_or_none]
  Link: https://lkml.kernel.org/r/20230327185746.3856407-1-f.fainelli@gmail.com
Link: https://lkml.kernel.org/r/20230323231659.3319941-1-f.fainelli@gmail.com
Fixes: 8207d4a88e1e ("scripts/gdb: add lx-genpd-summary command")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/genpd.py | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/genpd.py b/scripts/gdb/linux/genpd.py
index 39cd1abd85590..b53649c0a77a6 100644
--- a/scripts/gdb/linux/genpd.py
+++ b/scripts/gdb/linux/genpd.py
@@ -5,7 +5,7 @@
 import gdb
 import sys
 
-from linux.utils import CachedType
+from linux.utils import CachedType, gdb_eval_or_none
 from linux.lists import list_for_each_entry
 
 generic_pm_domain_type = CachedType('struct generic_pm_domain')
@@ -70,6 +70,8 @@ Output is similar to /sys/kernel/debug/pm_genpd/pm_genpd_summary'''
             gdb.write('    %-50s  %s\n' % (kobj_path, rtpm_status_str(dev)))
 
     def invoke(self, arg, from_tty):
+        if gdb_eval_or_none("&gpd_list") is None:
+            raise gdb.GdbError("No power domain(s) registered")
         gdb.write('domain                          status          children\n');
         gdb.write('    /device                                             runtime status\n');
         gdb.write('----------------------------------------------------------------------\n');
-- 
2.39.2



