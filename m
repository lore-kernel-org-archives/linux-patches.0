Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADFD3C3F4B;
	Sat, 17 Oct 2026 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259351; cv=none; b=UcbCMMgUD5XFuSWZoIldkS17Gq3qtd5OB8MpANn/IlDh4IEGW5wWhxYcsdaQDaR2HiKJ9SIBUs6e9maQojFH9YliCOg+PRNjmLNO1+jWF6XPH8Vv6Am6kMKhLXI+0akPX15a/Rtoqvh1M1nKpvvlUsBJzzUrodowVMsKKMSIHM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259351; c=relaxed/simple;
	bh=JcbZ8/yyxdVK+zZ7RUfaF3s/7n+BIh3x3Htb3w/RHT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOjndeT2BLuAuIdT6wiKHnCjSNRi9u3HL7r7NsKQb7Wh1PGeJC/LmiXh0nPsmAhJH17d1tPcICtb+fou7zGwg/bIeMXxXXa6CnBRYr5+ECzhrTM/xg43yt77fiiveI6VDU8P+4Uj3kComjH6rsGxRr9M/EiGhyqx7/BWTBY5ZBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EakAGlCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EakAGlCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4921F000C4;
	Sat, 17 Oct 2026 17:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259348;
	bh=AW2EQusUT9EAHlUJLImjf1iZNWJsiogPF2U9BUB43cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EakAGlCqAulTYa6BwY9lSsiXCI0dJM+M4rM4SG05p5S8PtxQYOzKe+8ju3D73F6U2
	 7wJIFhrXj3yTw0pVhaZw/7SnvVYBtk0sFmz4f5lfKqy1y7WBo106T7SooBIw0evAec
	 fodsHG8pfFMSIqb9jf3xsjPq97PiFIAilRgngcec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Finn Callies <fcallies@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1183/1674] s390/zcrypt: Close speculative mem read possibility
Date: Sat, 17 Oct 2026 17:57:35 +0200
Message-ID: <20261017160501.510341702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit e935cd525af4c6ed2e2c6404aa27ca19c7f39ddb ]

The domain value is extracted from a given CCA or EP11 ioctl struct
when a CPRB is about to be sent. Thus this is a user controlled value.
Under some special conditions (custom device node used, administrative
load) this value is used as an array index after bounds checking, but
without speculation barrier.

Add the missing array_index_nospec() call to prevent speculative
execution where this domain value is used.

Fixes: cfd68b33094e ("s390/zcrypt: Filter admin CPRBs on custom devices")
Cc: stable@vger.kernel.org
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Finn Callies <fcallies@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 2d3a766991a01..d9d0d3887a88c 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -26,6 +26,7 @@
 #include <linux/cdev.h>
 #include <linux/ctype.h>
 #include <linux/capability.h>
+#include <linux/nospec.h>
 #include <asm/debug.h>
 
 #define CREATE_TRACE_POINTS
@@ -871,6 +872,7 @@ static long _zcrypt_send_cprb(bool userspace, struct ap_perms *perms,
 	tdom = *domain;
 	if (perms != &ap_perms && tdom < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
+			tdom = array_index_nospec(tdom, AP_DOMAINS);
 			if (!test_bit_inv(tdom, perms->adm)) {
 				rc = -ENODEV;
 				goto out;
@@ -1050,6 +1052,7 @@ static long _zcrypt_send_ep11_cprb(bool userspace, struct ap_perms *perms,
 
 	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
+			domain = array_index_nospec(domain, AP_DOMAINS);
 			if (!test_bit_inv(domain, perms->adm)) {
 				rc = -ENODEV;
 				goto out_free;
-- 
2.53.0



