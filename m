Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2636E1A681E;
	Fri,  7 Aug 2026 15:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115446; cv=none; b=KVHIancTz9Fg5rzPA39Jex4Ri+UlMKkNADnOG7wZp6D+7w/6gi+huhcboY9Baxyax0SV1YMZLaQ2j9NZHGx4rhRT2xIt/KCCrQFWOapQMnYR8/j18Z5D9WF8jnSscd6BiVzhgJZRgoSpfvvuKl9MUCjJ51+PmT5Ho4Zar+ad2KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115446; c=relaxed/simple;
	bh=PD3IwKx9vvZOyuvcxxuKewn6NKLJjSW2ZbRbE9Bo89c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsLXbQkRpMX1I+sYVe9noXNDxBzHW+yBDNwjRDSUVOzXJkc385DxLnHT7z4JjhgJls5iZAfifzcq+ScOVr3adsV12X+VpU7UuINT7FNv0199KXK8THb6G6qDyJjr1FeF3IYqjjKD8pD+rOoHM++edPyZ9G5xsjQW/ORk0H1kOuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9sK++1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9sK++1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832CB1F000E9;
	Fri,  7 Aug 2026 15:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115445;
	bh=OVDTUSrsPBbm674rk+H2YrXnihUAn+3UxjU2RwM6CfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9sK++1v+FieArSasmznvu0zijidtnd4M4pBw3jeYa9zqFlhyxZulXZ7H37iiQ3g8
	 lrbwygHqXOeSg/eDFcncVNH7gbSoxeG7d0jDcpFJtbTIb39ZDzitJQT/ba0H75uNjq
	 JRKjhND0Ttda/uxeISjU+KDdCRxJYWKZ+csf8XRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 277/396] s390/zcrypt: Validate length for CCA AES cipher key requests
Date: Fri,  7 Aug 2026 16:37:17 +0200
Message-ID: <20260807143430.230881939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Holger Dengler <dengler@linux.ibm.com>

commit 06afe425d5283b9764303de47f554da5a808ce8a upstream.

cca_cipher2protkey() derives the copy length for the CPRB parameter
block directly from the length field in the key token. Reject the
request early if the token length exceeds the available space in the
parameter block.

Fixes: 4bc123b18ce6 ("s390/zcrypt: Add low level functions for CCA AES cipher keys")
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 5.4+
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_ccamisc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -1313,6 +1313,9 @@ int cca_cipher2protkey(u16 cardnr, u16 d
 	} __packed * prepparm;
 	int keytoklen = ((struct cipherkeytoken *)ckey)->len;
 
+	if (keytoklen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem,
 				    &preqcblk, &prepcblk, xflags);


