Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6411B424F;
	Sun,  7 Sep 2025 20:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275984; cv=none; b=p7JRdn49fg9Gfw1G3sj86yN9uWfrut1eVd/MexXVhNnuXb7KU3wPxt9AhaM/G1+VbXJYcTlewP+a0NpNmdyKJu0Oa+0Wm+cNhK8BBU0Lf8/t6YQDjcEhay2a3Gw646fxMDWilM+AQf/ic2L1y5KrE7VE/vsI24AjhlBXfQzoc/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275984; c=relaxed/simple;
	bh=6pJ2lAu3Zx8vCwZwLrZTihQpJdM7T33DcNEGj700Bww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2+CnLcRscH99F8KW1kgZ3XdQhzrC3vras4ueQfmHANd+/HVPWEMwhV9nPSYjk1jg/JDjL6UVeykFwzO0pgNbruyPjWCMKIWXRqB0o0Qexjw0pX2mhDs43sVXfVzgjBuGSyvIVtT/097BPFv3ovLTghwRU1No0le02ySVFieMdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRf6HWeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRf6HWeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1719DC4CEF0;
	Sun,  7 Sep 2025 20:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275984;
	bh=6pJ2lAu3Zx8vCwZwLrZTihQpJdM7T33DcNEGj700Bww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRf6HWeJmW8HIu/mBy4XGGMVOJQIGi98NL7KCwDvF7EtxiFlnxLAjfjHtSTny/v1p
	 dEl7KeOH9CaaSoApaKHlyEhQISRxpDCCKE+6QmLa7AmFK4v7KqTY4RdGJw58URm8QC
	 JCWFUfjrPvc+f3eUc+OwUrqNXsIB8Umg3cKBDopM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Kanzenbach <kurt@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 26/64] ptp: Add generic PTP is_sync() function
Date: Sun,  7 Sep 2025 21:58:08 +0200
Message-ID: <20250907195604.112132822@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit f72de02ebece2e962462bc0c1e9efd29eaa029b2 ]

PHY drivers such as micrel or dp83640 need to analyze whether a given
skb is a PTP sync message for one step functionality.

In order to avoid code duplication introduce a generic function and
move it to ptp classify.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9b2bfdbf43ad ("phy: mscc: Stop taking ts_lock for tx_queue and use its own lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ptp_classify.h | 15 +++++++++++++++
 net/core/ptp_classifier.c    | 12 ++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 7a526b52bd748..c91ede9654f92 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -128,6 +128,17 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
 	return msgtype;
 }
 
+/**
+ * ptp_msg_is_sync - Evaluates whether the given skb is a PTP Sync message
+ * @skb: packet buffer
+ * @type: type of the packet (see ptp_classify_raw())
+ *
+ * This function evaluates whether the given skb is a PTP Sync message.
+ *
+ * Return: true if sync message, false otherwise
+ */
+bool ptp_msg_is_sync(struct sk_buff *skb, unsigned int type);
+
 void __init ptp_classifier_init(void);
 #else
 static inline void ptp_classifier_init(void)
@@ -150,5 +161,9 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
 	 */
 	return PTP_MSGTYPE_SYNC;
 }
+static inline bool ptp_msg_is_sync(struct sk_buff *skb, unsigned int type)
+{
+	return false;
+}
 #endif
 #endif /* _PTP_CLASSIFY_H_ */
diff --git a/net/core/ptp_classifier.c b/net/core/ptp_classifier.c
index dd4cf01d1e0a2..598041b0499e3 100644
--- a/net/core/ptp_classifier.c
+++ b/net/core/ptp_classifier.c
@@ -137,6 +137,18 @@ struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
 }
 EXPORT_SYMBOL_GPL(ptp_parse_header);
 
+bool ptp_msg_is_sync(struct sk_buff *skb, unsigned int type)
+{
+	struct ptp_header *hdr;
+
+	hdr = ptp_parse_header(skb, type);
+	if (!hdr)
+		return false;
+
+	return ptp_get_msgtype(hdr, type) == PTP_MSGTYPE_SYNC;
+}
+EXPORT_SYMBOL_GPL(ptp_msg_is_sync);
+
 void __init ptp_classifier_init(void)
 {
 	static struct sock_filter ptp_filter[] __initdata = {
-- 
2.50.1



