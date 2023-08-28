Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D06211C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B40C433C8;
	Mon, 28 Aug 2023 10:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218629;
	bh=BwsgbxZvH+ZxmPDroh9x3ELfInhKWxplo1fzT1Q8DGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8LdLHyeBCDEUrGlJFTuZAKZisTRR/FIlL9sUTJWExFWs7JZvXybdOfPagG5z3kaD
	 CiVKtyc8S999PbaOE2D/ViOHyZfI416ww5ihhe7VoVozz4vDPa0s9UZB5MdhWGB9s5
	 YmgaVt9IdSZPMO/A9nQ4xky+DrEfO9i5B+LaO2Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/122] devlink: move code to a dedicated directory
Date: Mon, 28 Aug 2023 12:12:22 +0200
Message-ID: <20230828101157.332802472@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f05bd8ebeb69c803efd6d8a76d96b7fcd7011094 ]

The devlink code is hard to navigate with 13kLoC in one file.
I really like the way Michal split the ethtool into per-command
files and core. It'd probably be too much to split it all up,
but we can at least separate the core parts out of the per-cmd
implementations and put it in a directory so that new commands
can be separate files.

Move the code, subsequent commit will do a partial split.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2ebbc9752d06 ("devlink: add missing unregister linecard notification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                                | 2 +-
 net/Makefile                               | 1 +
 net/core/Makefile                          | 1 -
 net/devlink/Makefile                       | 3 +++
 net/{core/devlink.c => devlink/leftover.c} | 0
 5 files changed, 5 insertions(+), 2 deletions(-)
 create mode 100644 net/devlink/Makefile
 rename net/{core/devlink.c => devlink/leftover.c} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 379387e20a96d..07a9c274c0e29 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6027,7 +6027,7 @@ S:	Supported
 F:	Documentation/networking/devlink
 F:	include/net/devlink.h
 F:	include/uapi/linux/devlink.h
-F:	net/core/devlink.c
+F:	net/devlink/
 
 DH ELECTRONICS IMX6 DHCOM BOARD SUPPORT
 M:	Christoph Niedermaier <cniedermaier@dh-electronics.com>
diff --git a/net/Makefile b/net/Makefile
index 6a62e5b273781..0914bea9c335f 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_BPFILTER)		+= bpfilter/
 obj-$(CONFIG_PACKET)		+= packet/
 obj-$(CONFIG_NET_KEY)		+= key/
 obj-$(CONFIG_BRIDGE)		+= bridge/
+obj-$(CONFIG_NET_DEVLINK)	+= devlink/
 obj-$(CONFIG_NET_DSA)		+= dsa/
 obj-$(CONFIG_ATALK)		+= appletalk/
 obj-$(CONFIG_X25)		+= x25/
diff --git a/net/core/Makefile b/net/core/Makefile
index 5857cec87b839..10edd66a8a372 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -33,7 +33,6 @@ obj-$(CONFIG_LWTUNNEL) += lwtunnel.o
 obj-$(CONFIG_LWTUNNEL_BPF) += lwt_bpf.o
 obj-$(CONFIG_DST_CACHE) += dst_cache.o
 obj-$(CONFIG_HWBM) += hwbm.o
-obj-$(CONFIG_NET_DEVLINK) += devlink.o
 obj-$(CONFIG_GRO_CELLS) += gro_cells.o
 obj-$(CONFIG_FAILOVER) += failover.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
diff --git a/net/devlink/Makefile b/net/devlink/Makefile
new file mode 100644
index 0000000000000..3a60959f71eea
--- /dev/null
+++ b/net/devlink/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y := leftover.o
diff --git a/net/core/devlink.c b/net/devlink/leftover.c
similarity index 100%
rename from net/core/devlink.c
rename to net/devlink/leftover.c
-- 
2.40.1



