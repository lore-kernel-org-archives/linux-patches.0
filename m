Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9511171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3ADC433EF;
	Mon,  8 May 2023 11:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546199;
	bh=22/0GyGstKxSi5WyUg/SfzoRo+KeW+wvMb1rDRutY3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0Dn9V6l4CawTDpPpjHLz5VossLf3buFkzREg0QuEROR6wx5xs5tlNX0lvYH3/ARv
	 7v1ma9zxxxRGbtjfP7aIz6n/jcNOZJPiQYNIyTXmjQxo7KswjxmbcG+doX6QXVe2Zc
	 jurE/YaSUHRlA70aBztg1S2o0hxu1sXM9T1XIeL8=
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
Subject: [PATCH 5.15 260/371] scripts/gdb: bail early if there are no clocks
Date: Mon,  8 May 2023 11:47:41 +0200
Message-Id: <20230508094822.391097711@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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

[ Upstream commit 1d7adbc74c009057ed9dc3112f388e91a9c79acc ]

Avoid generating an exception if there are no clocks registered:

(gdb) lx-clk-summary
                                 enable  prepare  protect
   clock                          count    count    count        rate
------------------------------------------------------------------------
Python Exception <class 'gdb.error'>: No symbol "clk_root_list" in
current context.
Error occurred in Python: No symbol "clk_root_list" in current context.

Link: https://lkml.kernel.org/r/20230323225246.3302977-1-f.fainelli@gmail.com
Fixes: d1e9710b63d8 ("scripts/gdb: initial clk support: lx-clk-summary")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/clk.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/gdb/linux/clk.py b/scripts/gdb/linux/clk.py
index 061aecfa294e6..7a01fdc3e8446 100644
--- a/scripts/gdb/linux/clk.py
+++ b/scripts/gdb/linux/clk.py
@@ -41,6 +41,8 @@ are cached and potentially out of date"""
             self.show_subtree(child, level + 1)
 
     def invoke(self, arg, from_tty):
+        if utils.gdb_eval_or_none("clk_root_list") is None:
+            raise gdb.GdbError("No clocks registered")
         gdb.write("                                 enable  prepare  protect               \n")
         gdb.write("   clock                          count    count    count        rate   \n")
         gdb.write("------------------------------------------------------------------------\n")
-- 
2.39.2



