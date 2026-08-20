Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A81352019;
	Thu, 20 Aug 2026 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238158; cv=none; b=nzfCvNv5tRCUwyyGgQRWbv7amyDOSkEKLahNLVanU2nqPWgQNWHh5cbcAmAz5Sjl+CTAE/sk2QVs4CmWTlP7DQFlUxt73heeR9A2g4zj3uZFS8CzbXyL3t6G8QQlPerokFh4oB4fe2vZ+3XaDZaFalU3WuorEnID9O0N+AGL5kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238158; c=relaxed/simple;
	bh=Us6CXxAMnPKnO+e+LiOoRx5AbhllN6YVON/jwrv0lQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JY8alXrQcLtYsHnsNFEP6bhG7NPyyy6V0vpPA3wxI+CpKu9FU18DQnhnQyRwfZFXDH15A2cJfutSJmqswEE6E/XY8mixJfrbQWj+kiLA1XojFLpRmmr///yajaH/sFkhM0qfXmijy6hx0ddj/+ngU/OFxRQNjjh62EMCJ+d/J8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qD7kPO5H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qD7kPO5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE13D1F000E9;
	Thu, 20 Aug 2026 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238157;
	bh=OapKndssb0qd3RI2v7o0vvopxef/MgcBHaomZhojda0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qD7kPO5HnojkObiiArFsLzQkh6OcKFSHbjmPOj6VV97R/CuZUjiwB7OB432Q86Z7C
	 OdsHS2kgylzBYR7c2zq7ggnMnbEDurC32QLpZURWRVAqF1h7QyaDEKnBbYU2+YByGG
	 kIPo7r3T5gvl/qS3YLvapfjnopAB1Ph2l0naoDMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.1 050/228] powerpc/pseries: lparcfg - fix kbuf[] underflow
Date: Thu, 20 Aug 2026 16:53:12 +0200
Message-ID: <20260820145245.990018875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: George Wilson <gcwilson@linux.ibm.com>

commit fb442a6673ff1046bf67754957d95880fdb394b5 upstream.

In lparcfg_write(), a count of 0 results in kbuf[] being indexed at -1.
Check for count == 0 in the existing check for count > sizeof(kbuf) and
return -EINVAL if true.

Fixes: 74422e2b1939 ("powerpc/pseries: Remove VLA from lparcfg_write()")
Acked-by: Nayna Jain <nayna@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Cc: stable@vger.kernel.org # 4.20
Signed-off-by: George Wilson <gcwilson@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -697,7 +697,7 @@ static ssize_t lparcfg_write(struct file
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return -EINVAL;
 
-	if (count > sizeof(kbuf))
+	if (count == 0 || count > sizeof(kbuf))
 		return -EINVAL;
 
 	if (copy_from_user(kbuf, buf, count))


