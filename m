Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209711D04A8;
	Wed,  2 Oct 2024 14:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879653; cv=none; b=mpquE9zk9y4zJJb9NUcENuorvHBPnr8YP5ImdbEqAoI1fpYTZtmP8saYRXEp7FTr41bRpzod8345rtunijUCQpM0oIwoHznPCwTpIvXvd7WmJnk0GJaqmPjFWABGeWdGNLy7KZ7wAh14fXuBmCer5jeviTa8sRh9PUededz9HsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879653; c=relaxed/simple;
	bh=P8BZEcYveDDt6l9T0R+GSkxXJyUdzqMJGXIWwOe33X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrLM40/A+oeNRd7eBWowCFbkvSnb5bGEGJ4nyQE1ehb4jbXrhxq+ABpqqITnM5+Hly023FO6A7Wd5UggdhtUOZ9mgmXjMsINZvQbltFshkc8hJrq6uQEl5ui56rH+z9+TkQhn1MLJacIYlP1vmyRt4dMmyYY6IGSOOpb4UMoj1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J848afxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J848afxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7630CC4CEC2;
	Wed,  2 Oct 2024 14:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879652;
	bh=P8BZEcYveDDt6l9T0R+GSkxXJyUdzqMJGXIWwOe33X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J848afxEcoHhsvRPq9lTVbBdPesgZoYU4c6flLpRp15ZAw1A11m5Caywg6vm0/t5+
	 mz/WbkQhXrX9W9ZYBFUw2sMNpoqngJUtAb0bHz7LYkv98JJFY4YdAI5EBFdG32oLs5
	 7APjI+eoJ4WpuVxNMqSWPoF6N5DPxBEnJ5DDq8dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tushar Vyavahare <tushar.vyavahare@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/538] selftests/bpf: Implement get_hw_ring_size function to retrieve current and max interface size
Date: Wed,  2 Oct 2024 14:57:10 +0200
Message-ID: <20241002125759.796305356@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Tushar Vyavahare <tushar.vyavahare@intel.com>

[ Upstream commit 90a695c3d31e1c9f0adb8c4c80028ed4ea7ed5ab ]

Introduce a new function called get_hw_size that retrieves both the
current and maximum size of the interface and stores this information
in the 'ethtool_ringparam' structure.

Remove ethtool_channels struct from xdp_hw_metadata.c due to redefinition
error. Remove unused linux/if.h include from flow_dissector BPF test to
address CI pipeline failure.

Signed-off-by: Tushar Vyavahare <tushar.vyavahare@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20240402114529.545475-4-tushar.vyavahare@intel.com
Stable-dep-of: 69f409469c9b ("selftests/bpf: Drop unneeded error.h includes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.c | 24 +++++++++++++++++++
 tools/testing/selftests/bpf/network_helpers.h |  4 ++++
 .../selftests/bpf/prog_tests/flow_dissector.c |  1 -
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 14 -----------
 4 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index 0877b60ec81f6..d2acc88752126 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -465,3 +465,27 @@ int get_socket_local_port(int sock_fd)
 
 	return -1;
 }
+
+int get_hw_ring_size(char *ifname, struct ethtool_ringparam *ring_param)
+{
+	struct ifreq ifr = {0};
+	int sockfd, err;
+
+	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (sockfd < 0)
+		return -errno;
+
+	memcpy(ifr.ifr_name, ifname, sizeof(ifr.ifr_name));
+
+	ring_param->cmd = ETHTOOL_GRINGPARAM;
+	ifr.ifr_data = (char *)ring_param;
+
+	if (ioctl(sockfd, SIOCETHTOOL, &ifr) < 0) {
+		err = errno;
+		close(sockfd);
+		return -err;
+	}
+
+	close(sockfd);
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index 5eccc67d1a998..11cbe194769b1 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -9,8 +9,11 @@ typedef __u16 __sum16;
 #include <linux/if_packet.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/ethtool.h>
+#include <linux/sockios.h>
 #include <netinet/tcp.h>
 #include <bpf/bpf_endian.h>
+#include <net/if.h>
 
 #define MAGIC_VAL 0x1234
 #define NUM_ITER 100000
@@ -60,6 +63,7 @@ int make_sockaddr(int family, const char *addr_str, __u16 port,
 		  struct sockaddr_storage *addr, socklen_t *len);
 char *ping_command(int family);
 int get_socket_local_port(int sock_fd);
+int get_hw_ring_size(char *ifname, struct ethtool_ringparam *ring_param);
 
 struct nstoken;
 /**
diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index c4773173a4e43..9e5f38739104b 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -2,7 +2,6 @@
 #include <test_progs.h>
 #include <network_helpers.h>
 #include <error.h>
-#include <linux/if.h>
 #include <linux/if_tun.h>
 #include <sys/uio.h>
 
diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index adb77c1a6a740..79f2da8f6ead6 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -288,20 +288,6 @@ static int verify_metadata(struct xsk *rx_xsk, int rxq, int server_fd, clockid_t
 	return 0;
 }
 
-struct ethtool_channels {
-	__u32	cmd;
-	__u32	max_rx;
-	__u32	max_tx;
-	__u32	max_other;
-	__u32	max_combined;
-	__u32	rx_count;
-	__u32	tx_count;
-	__u32	other_count;
-	__u32	combined_count;
-};
-
-#define ETHTOOL_GCHANNELS	0x0000003c /* Get no of channels */
-
 static int rxq_num(const char *ifname)
 {
 	struct ethtool_channels ch = {
-- 
2.43.0



