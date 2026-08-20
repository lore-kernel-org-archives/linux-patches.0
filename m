Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46F125B0AA;
	Thu, 20 Aug 2026 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239426; cv=none; b=ucNNinNE0lXAyaq6cpBcSrMkCo3cnUcDPvzjlmf18/NZJUJg8oKm39igdpy8aOQlVKTMjsqtmpwvGX7+a3A0aCEKa4mQn0a7wF1TZp9+NeOa+tW0/yJ7f1vzw9O62Bmh8OJvGJy+FdV6N66Ggf8jxjXavs7tBHZLBdN/09pZM/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239426; c=relaxed/simple;
	bh=9PZUrklMK1V1lj4uhrh5SibLLeX0lmqlGR25CGBjHAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3+UVS3WzAAEGGr7fX0pVmop9KjtqGxmKKtUlyrA5X/srKSg66x7p+7XA02BeQGykdI/6iK69RcX4PP0M6QK10akoxiMlqyHi0v1Yc7tbMItlUW7bMJR65y+mUYc5HtZZLX54aZn2B6BH1TO8xFBMGrfbMkoRuU6VUECMZSMwP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otr1Sm41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otr1Sm41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FE51F00A3A;
	Thu, 20 Aug 2026 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239425;
	bh=vFZATzHJfoFSM2eTsU8dDV9cdqAModSILbwizr6uqvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otr1Sm415aAUTWW7QK/pz+/o3Oli664/nT7WjSV3un9fvAXn+UiGobJHzjExqyU4s
	 YfiI/5M7oaFi3WtMSma4ro/p25SXjGmSmMwcbLfqB8V9PnA5v4ri6QBk69EqOpj9zJ
	 7Sf96uwftjKDnmm/ttRbgwK89LlNtWjzH2Nu0LWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 044/220] powerpc/pseries: lparcfg - fix kbuf[] underflow
Date: Thu, 20 Aug 2026 16:53:54 +0200
Message-ID: <20260820145224.815923043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -687,7 +687,7 @@ static ssize_t lparcfg_write(struct file
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return -EINVAL;
 
-	if (count > sizeof(kbuf))
+	if (count == 0 || count > sizeof(kbuf))
 		return -EINVAL;
 
 	if (copy_from_user(kbuf, buf, count))


