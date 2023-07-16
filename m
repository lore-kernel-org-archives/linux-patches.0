Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E7C8F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B580C433C7;
	Sun, 16 Jul 2023 20:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539066;
	bh=Wafqe00h64+HGPls9WWn/D9A6ICnrRKnUHb5sJq9Pq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3+zK7JX3uWEIfjkqrl+fmhNUkJmNCwjrejEWXeQav5u120X7cNq5TpuWH4zad0X+
	 sU1yyGUdBD14Gny1Jm30n7kyqmwfwD6gC8zZuEps5L5nsTRCkr/ihUQleSabc46vzJ
	 rMv4sLEuxzFMU+U8ulcMJtKzJc9ej2GdrmRlLykM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 658/800] tools/virtio: fix build break for aarch64
Date: Sun, 16 Jul 2023 21:48:31 +0200
Message-ID: <20230716195004.394581339@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 77b894f220cbd04301b3d941df8247106e67f8e4 ]

"-mfunction-return=thunk -mindirect-branch-register" are only valid
for x86. So introduce compiler operation check to avoid such issues

Fixes: 0d0ed4006127 ("tools/virtio: enable to build with retpoline")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Message-Id: <20230323040024.3809108-1-peng.fan@oss.nxp.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/virtio/Makefile | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index 7b7139d97d742..d128925980e05 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -4,7 +4,18 @@ test: virtio_test vringh_test
 virtio_test: virtio_ring.o virtio_test.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
-CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h -mfunction-return=thunk -fcf-protection=none -mindirect-branch-register
+try-run = $(shell set -e;		\
+	if ($(1)) >/dev/null 2>&1;	\
+	then echo "$(2)";		\
+	else echo "$(3)";		\
+	fi)
+
+__cc-option = $(call try-run,\
+	$(1) -Werror $(2) -c -x c /dev/null -o /dev/null,$(2),)
+cc-option = $(call __cc-option, $(CC),$(1))
+
+CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h $(call cc-option,-mfunction-return=thunk) $(call cc-option,-fcf-protection=none) $(call cc-option,-mindirect-branch-register)
+
 CFLAGS += -pthread
 LDFLAGS += -pthread
 vpath %.c ../../drivers/virtio ../../drivers/vhost
-- 
2.39.2



