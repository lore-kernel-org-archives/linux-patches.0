Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4F63CDBC3;
	Mon, 17 Aug 2026 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977630; cv=none; b=oysFH2ukRDKzunOk0qeQ/ak7/l5sGkcz2Pg1acfqkHyLliaPmuq1hssx05mYztrxg/1cNmbTqNSfHdM2oTVKBWuKMbKEvKPivWrzexr4cefZ8iy2UpmFwogR7ynZHCbayXVp3PeGGvdDJSL29sR0O64+W678FEB0jp+jPxJESiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977630; c=relaxed/simple;
	bh=d01kpPE4DmiSavMFcecCqz6CWvZDC3IPKtc7WDH2vWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fANVWGKMEUNVtX0xFLiIa9rkl8WoIiARJlssZF4fYz/2bcJNatZWOH+mY9WM3Og/vQLMxhr9kq6hB1Zycb7zcNacjSI5C/FmBSq+3H71avD6JNFeeLN3r/Q3KXUZInBzGglXBH8cufdat8rgwlmHLRuumV3h2j/i+zuUgEErfqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQQo+8/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQQo+8/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCBB1F000E9;
	Mon, 17 Aug 2026 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977628;
	bh=/t/h8eIRC1sMs1l1pjD331yAdM+pkcX+H565caziNO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQQo+8/7TryuL1EfiI1R3A0mgAUSLkBIamL6pvIfeO3YjtcpSl0v5imoqQRN7ROOs
	 385s22vZY8Kpt3OqO2V/U6oN5JMSRryAD8D08ZvL0zXyglMJR24QZDG8YtBVhlETsU
	 8p15LVry6dR8oyvKH8qQbvITnN7UCRw0ZxCbYPPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Patron?= <priv.luk@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 393/456] net: qrtr: ns: Raise lookup limit to 128
Date: Mon, 17 Aug 2026 15:33:03 +0200
Message-ID: <20260817132554.768346638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Łukasz Patron <priv.luk@gmail.com>

[ Upstream commit 7fc1c937b6b37c77df4ba374c37435ab06a2e945 ]

Current limit of 64 is not enough for Sony Xperia 10 VII (SM6475).

After merging v6.6.142 into a downstream AOSP device, it's stuck on
boot animation and following log spam can be observed in dmesg:

E qrtr    : ctrl_cmd_new_lookup(): QRTR client node exceeds max lookup limit!
E qrtr    : qrtr_ns_worker(): failed while handling packet from 1:16600

No idea why it needs more than 64 client lookups, but it appears to
work fine with 128 as it did when there were no limits.

I don't really have a good way to investigate what it needs all
these lookups for as most of the userspace is closed source.

Fixes: 5640227d9a21 ("net: qrtr: ns: Limit the maximum number of lookups")
Signed-off-by: Łukasz Patron <priv.luk@gmail.com>
Link: https://patch.msgid.link/20260804201919.1148015-1-priv.luk@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 5220529a4c62d..4df5f0a9b7419 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -77,7 +77,7 @@ struct qrtr_node {
  */
 #define QRTR_NS_MAX_NODES   512
 #define QRTR_NS_MAX_SERVERS 256
-#define QRTR_NS_MAX_LOOKUPS 64
+#define QRTR_NS_MAX_LOOKUPS 128
 
 static u16 node_count;
 
-- 
2.53.0



