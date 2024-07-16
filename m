Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A867B641;
	Tue, 16 Jul 2024 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144462; cv=none; b=dBEF/9Pbn65/+ZjRlgaAs27svLGSUsSa/vkvr2s32Tn6JecKCdTwXnaWUB+nQyJu4hJFhThfZFMhB47teEmDbpROxLBnW5tmeIcrNYvoFD3KxS88ouVlaBcKhtNbSOcq33jGLs+zHs99ZwlvE2JA9wXbFa5onGmfwH5pp1q+LQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144462; c=relaxed/simple;
	bh=qQrfzvZBB43qGL/KT6ZWTfuPIjmY4ksiocp63WSMgGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjdq1zlpPmFgF5XsqnmTj4S4Z2Pn6WtHJq2XxBdkujecIDU7S6efo+J8EptHb9X2ngiicq7u7/xRHF/Jxd6gDH83lcMDV/Mz1L9LkxFKRmuV3S9DZCAyRRfvWZc8Ke+yPsjnQgRj6oy7+cA3t/uzRjJO4BY/v9+B4m3FKlmwYvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AREUMtcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AREUMtcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA189C116B1;
	Tue, 16 Jul 2024 15:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144462;
	bh=qQrfzvZBB43qGL/KT6ZWTfuPIjmY4ksiocp63WSMgGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AREUMtcggqAJussCcaxmb2xJqTAUeQ2K3zOivkTHU0b1Z6DNgxwcLjHo7ftqcrl9Z
	 i3S7Q9tlHB5cicmcNUmnnewiJkzD/ax9dkk1amap8gbK+thA4CBcY7p+c4YuEWiLaU
	 thGhovAfg6ph4qPBvIVRHLGW0k6T49QAxBQ7oR5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ec0723ba9605678b14bf@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 54/78] ppp: reject claimed-as-LCP but actually malformed packets
Date: Tue, 16 Jul 2024 17:31:26 +0200
Message-ID: <20240716152742.732360887@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit f2aeb7306a898e1cbd03963d376f4b6656ca2b55 ]

Since 'ppp_async_encode()' assumes valid LCP packets (with code
from 1 to 7 inclusive), add 'ppp_check_packet()' to ensure that
LCP packet has an actual body beyond PPP_LCP header bytes, and
reject claimed-as-LCP but actually malformed data otherwise.

Reported-by: syzbot+ec0723ba9605678b14bf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ec0723ba9605678b14bf
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 078c0f474f966..3cd4196b36b21 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -70,6 +70,7 @@
 #define MPHDRLEN_SSN	4	/* ditto with short sequence numbers */
 
 #define PPP_PROTO_LEN	2
+#define PPP_LCP_HDRLEN	4
 
 /*
  * An instance of /dev/ppp can be associated with either a ppp
@@ -491,6 +492,15 @@ static ssize_t ppp_read(struct file *file, char __user *buf,
 	return ret;
 }
 
+static bool ppp_check_packet(struct sk_buff *skb, size_t count)
+{
+	/* LCP packets must include LCP header which 4 bytes long:
+	 * 1-byte code, 1-byte identifier, and 2-byte length.
+	 */
+	return get_unaligned_be16(skb->data) != PPP_LCP ||
+		count >= PPP_PROTO_LEN + PPP_LCP_HDRLEN;
+}
+
 static ssize_t ppp_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -513,6 +523,11 @@ static ssize_t ppp_write(struct file *file, const char __user *buf,
 		kfree_skb(skb);
 		goto out;
 	}
+	ret = -EINVAL;
+	if (unlikely(!ppp_check_packet(skb, count))) {
+		kfree_skb(skb);
+		goto out;
+	}
 
 	switch (pf->kind) {
 	case INTERFACE:
-- 
2.43.0



