Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA2E4756AE;
	Fri,  7 Aug 2026 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117508; cv=none; b=srXGIaov6EyGocPjaYEdIRXAt99Dx0lE3xixtkx22wZ1R7+7h2EEAfAa8FiaHWsvMsw0AbZBPrC8KGGG/JVhackfHmGeKBJiwrp6oUMXx7gjL2oXn7D/I1wmrGyb9tz/oYdbDA9huN+QuzEZobTVm+Tj+snD5cO/9S9Jxn4I/7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117508; c=relaxed/simple;
	bh=Os005PrTiwxYyMOBDTqHEHQPpfx3+F8GU8ReMBUMZYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5aZjReCi85L+m92WGQzxMWpxuOrCbveyDuACrh7NQbugr1ld5VOW+KEdEzbJPei4EkN4BEkpevtoTtek6PBXQooDG1Oonf6HSF27IdW/5ReCGGHsdSnvh9CXzKxXuQfWZwEnzsJ3Jp/THgOlV7hLIawaCd5TflpEFWVFWSngog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyGkyTnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyGkyTnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF441F000E9;
	Fri,  7 Aug 2026 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117506;
	bh=IOwJxRwCvYUG55NfsvN3Pkp6ayOkb+AYBZZktXmp6NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyGkyTnJqcjdtkIPHVcHwxpf7ldPn2ddD40Bmk47jmU4Wj0S68PsCui0OqeLDKaj6
	 UKmZzSAs8vnuFnBoQTYCKNUAXpcW9PH+4Lva/m/F+ZymhQZerLyV8YGNEI11vK6oIT
	 TGhxjpqOYodNZ6E/AVoOPWgw/rcpELL1txJwLKc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Finn Callies <fcallies@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.1 342/438] s390/zcrypt: Close speculative mem read possibility
Date: Fri,  7 Aug 2026 16:38:58 +0200
Message-ID: <20260807143435.265838746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

commit e935cd525af4c6ed2e2c6404aa27ca19c7f39ddb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_api.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -879,6 +879,7 @@ static long _zcrypt_send_cprb(u32 xflags
 
 	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
+			domain = array_index_nospec(domain, AP_DOMAINS);
 			if (!test_bit_inv(domain, perms->adm)) {
 				rc = -ENODEV;
 				goto out;
@@ -1079,6 +1080,7 @@ static long _zcrypt_send_ep11_cprb(u32 x
 
 	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
+			domain = array_index_nospec(domain, AP_DOMAINS);
 			if (!test_bit_inv(domain, perms->adm)) {
 				rc = -ENODEV;
 				goto out;


