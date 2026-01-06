Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86B2355031;
	Tue,  6 Jan 2026 17:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721785; cv=none; b=Xq5jKVFOZV2cKfRQmoa7MIouU04o9zb8cB2Lrglx7gQ8STon0GHgjwmO6Gtjy7ijPw7971Q2PYfqTfoOE0UTOZijcBLUKWm5o7xCFfTN1QcPBKjPDS9Ci3o8O0MiEYq4OvZPlamOKUmx6/oiwxCwzAJAmbSYofBFczNTVq30x9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721785; c=relaxed/simple;
	bh=0uO3C6lU6IIyxRbUcj29L3/vmcWqWoeSCopVN1cegio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf2RHiufyZl78UoRCv86Z36/UDXmeEhWDuq4qH8XTBXqlGXE6rLgwfTLQ84dqR2mSSMtFsdgdRx0N9NiFFV82JJ3PFxD3BfJYNoXWs+b6dyYkPYGVi/6lYq2vYAbmRlipTqwyzaNTxFLQPHMH/UC1PxNmzCt58tEUolvNv8xnvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsN1Toaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsN1Toaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372B2C116C6;
	Tue,  6 Jan 2026 17:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721785;
	bh=0uO3C6lU6IIyxRbUcj29L3/vmcWqWoeSCopVN1cegio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsN1ToajgvoE3MQivLRfjZ1i+TTpSqGvJ7aAuc3kDGjD1s31HIqurCqOODeRL1eg+
	 ZhuweRPIlSGjQdVCdqunhtFrT+/jd9ZS6O0jkIPiqFvc6YruuD8CwWBq4SA5PAaH3l
	 dS5vltsIjPAJ9yDcNzoCH0gMDKfw/HJAfKsGpWFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/312] tools/sched_ext: fix scx_show_state.py for scx_root change
Date: Tue,  6 Jan 2026 18:02:08 +0100
Message-ID: <20260106170549.807342244@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit f92ff79ba2640fc482bf2bfb5b42e33957f90caf ]

Commit 48e126777386 ("sched_ext: Introduce scx_sched") introduced
scx_root and removed scx_ops, causing scx_show_state.py to fail when
searching for the 'scx_ops' object. [1]

Fix by using 'scx_root' instead, with NULL pointer handling.

[1]
 # drgn -s vmlinux ./tools/sched_ext/scx_show_state.py
 Traceback (most recent call last):
   File "/root/.venv/bin/drgn", line 8, in <module>
     sys.exit(_main())
              ~~~~~^^
   File "/root/.venv/lib64/python3.14/site-packages/drgn/cli.py", line 625, in _main
     runpy.run_path(
     ~~~~~~~~~~~~~~^
         script_path, init_globals={"prog": prog}, run_name="__main__"
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
     )
     ^
   File "<frozen runpy>", line 287, in run_path
   File "<frozen runpy>", line 98, in _run_module_code
   File "<frozen runpy>", line 88, in _run_code
   File "./tools/sched_ext/scx_show_state.py", line 30, in <module>
     ops = prog['scx_ops']
           ~~~~^^^^^^^^^^^
 _drgn.ObjectNotFoundError: could not find 'scx_ops'

Fixes: 48e126777386 ("sched_ext: Introduce scx_sched")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_show_state.py | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/sched_ext/scx_show_state.py b/tools/sched_ext/scx_show_state.py
index 7cdcc6729ea4..aec4a4498140 100644
--- a/tools/sched_ext/scx_show_state.py
+++ b/tools/sched_ext/scx_show_state.py
@@ -27,10 +27,13 @@ def read_static_key(name):
 def state_str(state):
     return prog['scx_enable_state_str'][state].string_().decode()
 
-ops = prog['scx_ops']
+root = prog['scx_root']
 enable_state = read_atomic("scx_enable_state_var")
 
-print(f'ops           : {ops.name.string_().decode()}')
+if root:
+    print(f'ops           : {root.ops.name.string_().decode()}')
+else:
+    print('ops           : ')
 print(f'enabled       : {read_static_key("__scx_enabled")}')
 print(f'switching_all : {read_int("scx_switching_all")}')
 print(f'switched_all  : {read_static_key("__scx_switched_all")}')
-- 
2.51.0



