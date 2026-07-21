Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF43046EC7D;
	Tue, 21 Jul 2026 18:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660273; cv=none; b=hqX7xQNF/zGkGYuETOSrov2FG6A9y/atIYNF7EpzKUc4hpRAJZISe0IyFozheQww+4ctltvmoysYS0rVIwfqZRx+0m/7ILUSlue7Ccm1ugjQBx3ZgkVQxEXl3M2Aouo2GCvDhwlm2ZpK2l0E8sj90q0ODn/PbdL3SgWjx7Ai7yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660273; c=relaxed/simple;
	bh=FIaVw8RChASLQFMyPRFok0xlEhjCTpnztBYLNNHXtW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4Gf4BrpvSmxhM87KVZ3g73z6oPTkeX5iRCbzCFXGjiYSlyIIwbLtRFXDbNgsdkypRBAv1QQ2da/At42kwBwD5Pw6Hw8nQg3Iklo5FZZnS2yKwvORm7WDd+14fttlcZRUrIRWHIBDFUofwsvf5Jx5LLmloH2bkWz7UgrlgzneDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9/wRNPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9/wRNPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831891F000E9;
	Tue, 21 Jul 2026 18:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660269;
	bh=P/41lo57B0s28LDsSfREpZU9fP0xWUa/LZcUmu4LgS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9/wRNPLnvG2pb0+C6NTG3vPQwAtuL0RSR6o+LB8lglaq5NmOz/NPX3dTMiLpRrvk
	 9GSaBUqb0NBNk8JWqZeAO8m6AnSCt/bCP+A2RQmNtqgloN0iFKXZjLSH5ehQ4cg4If
	 01HVHDRwvowNhmo4H7aRWydgIw9KAS6XgyJ4u2n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0914/2077] docs: changes.rst: restore pahole 1.26 minimum (regressed by sort)
Date: Tue, 21 Jul 2026 17:09:47 +0200
Message-ID: <20260721152614.371952290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 2c1ccd9a1d786503086e83fe83e5c3b3c953b70e ]

Commit 9edd04c4189e ("docs: Raise minimum pahole version to 1.26 for
KF_IMPLICIT_ARGS kfuncs") raised the minimum required pahole version
from 1.22 to 1.26 in the requirements table and added a paragraph
explaining the failure mode for distributions still shipping pahole
v1.25 (e.g. Ubuntu 24.04 LTS).

The next day, commit ece7e57afd51 ("docs: changes.rst and ver_linux:
sort the lists") came through a different tree (docs vs sched_ext) and
re-flowed the table alphabetically, but its base did not include
9edd04c4189e.  When the two commits met in mainline, the textual rewrite
of the table won and the version bump was lost.  The added "Since Linux
7.0..." paragraph also disappeared.

The result is that changes.rst on master (v7.1-rc5) lists pahole 1.22
again, even though sched_ext kfuncs annotated with KF_IMPLICIT_ARGS
genuinely require v1.26 to produce a correct vmlinux BTF.  Users on
distributions with pahole v1.25 hit "func_proto incompatible with
vmlinux" when loading any sched_ext BPF program (scx_simple,
scx_qmap, ...) and have no documentation pointing them at the version
gap.

Restore both changes from 9edd04c4189e.

Fixes: ece7e57afd51 ("docs: changes.rst and ver_linux: sort the lists")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260526022033.1301884-1-zhanxusheng@xiaomi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/process/changes.rst | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
index 9a99037270ff27..a4db8f7b3afb7d 100644
--- a/Documentation/process/changes.rst
+++ b/Documentation/process/changes.rst
@@ -53,7 +53,7 @@ mcelog                 0.6              mcelog --version
 mkimage (optional)     2017.01          mkimage --version
 nfs-utils              1.0.5            showmount --version
 openssl & libcrypto    1.0.0            openssl version
-pahole                 1.22             pahole --version
+pahole                 1.26             pahole --version
 pcmciautils            004              pccardctl -V
 PPP                    2.4.0            pppd --version
 procps                 3.2.0            ps --version
@@ -147,6 +147,11 @@ Since Linux 5.2, if CONFIG_DEBUG_INFO_BTF is selected, the build system
 generates BTF (BPF Type Format) from DWARF in vmlinux, a bit later from kernel
 modules as well.  This requires pahole v1.22 or later.
 
+Since Linux 7.0, kfuncs annotated with KF_IMPLICIT_ARGS require pahole v1.26
+or later.  Without it, such kfuncs will have incorrect BTF prototypes in
+vmlinux, causing BPF programs to fail to load with a "func_proto incompatible
+with vmlinux" error.  Many sched_ext kfuncs are affected.
+
 It is found in the 'dwarves' or 'pahole' distro packages or from
 https://fedorapeople.org/~acme/dwarves/.
 
-- 
2.53.0



