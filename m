Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155241C84D0;
	Fri,  7 Aug 2026 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116233; cv=none; b=hsA0n1uXp38jZO1PRssV72BOZHAFo2xvv+H6aW7Op/0R9/+zhbetKCLxrP4E/6drMGuS6gmC4vIogxwzC1LkwyN7v/yeGScxIoBXVoFnCkKJbx3B/Ak+my53hs6iS1gAVlNGOhsXTh22hBU2omN4CqwMEJe/A0oksNL5jEEP91w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116233; c=relaxed/simple;
	bh=1URDutuyBDJ84EgXqilSQZ61+lI14mb5yyWDlm8DVqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opvusPA5G0dkbLPkpe7NiPYTkH/ScqKvnv3LpHP5mSRG0V6wLKfp6gYfjmR5ZWDfZKjt/7/uF5k4LECACv2LcquDXpj9M4/d71QvVFHHA+tx9OtBWUhKbiZGUqHneD1+YZTvhnh8bgnd1jbBd8rFQgRpLDun1hStoA/peUCojP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+u3jS8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+u3jS8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7110C1F00A3A;
	Fri,  7 Aug 2026 15:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116232;
	bh=ck2EC4ns/Yn9rXpnm2FXl1a80lKq3N9nlSQ3QLH/i5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+u3jS8JueUw1FjlloKcZ/4vjZDp1B4W04lwFu9nOJpIlTv5ksgiBCME8KRvl4mbP
	 MiYoJ9JAarlp+P/0Sfitcop/jT22f6f1JsjjoJIC/qQfAyUe8KP2AfAJKCK3lh86M5
	 FDnm3qR90stH8JBOdj+xN4dL94UMI8m3LUZY0afk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 157/261] s390/zcrypt: Validate length for CCA AES cipher key requests
Date: Fri,  7 Aug 2026 16:38:34 +0200
Message-ID: <20260807143418.754671706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
@@ -1232,6 +1232,9 @@ int cca_cipher2protkey(u16 cardnr, u16 d
 	} __packed * prepparm;
 	int keytoklen = ((struct cipherkeytoken *)ckey)->len;
 
+	if (keytoklen > PARMBSIZE - sizeof(struct aureqparm))
+		return -EINVAL;
+
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem, &preqcblk, &prepcblk);
 	if (rc)


