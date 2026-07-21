Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D225446C4AC;
	Tue, 21 Jul 2026 17:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655275; cv=none; b=sCVpRX1O8FyPkMH246rZH4LPnT5jqwX9/rHA37v5lbkOHM9NfqmnyuGEFlIsXqRZ0ko4st5kCJ3xd9F1AcQUCOohlpaliIZ3BBh1b1fgoSAqFdJNgswFx7ttBbSpf+3JLai694cYb2k7/LC2CIMtf1M8Gu9FR/xC5LjZKRqITzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655275; c=relaxed/simple;
	bh=N9u/7qDA3t2l/Jut0v4MNYw2F+4p3refr5kjHW5+XX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWmqF5z0BSG4xzFbSdLrTEVLbcHTeFIEdCOTjm8d3Ib5TSUMa6FyPzuhEjPis2lwyvESPwiepwzQntv6zSb1GV5wpAu2tn4iaRtJdfb6KJE4CrwY6t/iDvv/6bLW4RVuCwG2ZWZyUoyW2CxLXKhjl2SE15U6okOvKtH7cmxEaYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NE60ZaNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NE60ZaNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459E31F000E9;
	Tue, 21 Jul 2026 17:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655274;
	bh=PMbMlaQA8honaXrupcJsn3jxqdOos9dUuYBSmT2URt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NE60ZaNV+ITdqAyMjB73FNb/upYmxkadc+65JAtS0KM9dmyHCydlr1OiuiXNvjscF
	 bRXZvxyifRD9ZsjwtTT+NUPJsDenYWTYTl9D2s1qgkIPCgR4H8GP0yc6QE3OzuPTlp
	 r6ATdznrXaTPFBB6Gf1r0yD2Jd4m2eIk2aQugbj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.1 2021/2077] powerpc/uaccess: correct check for CONFIG_PPC_E500 in mask_user_address()
Date: Tue, 21 Jul 2026 17:28:14 +0200
Message-ID: <20260721152640.369007439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit d610d3ab18197d87618da11ec5fe8b3cebf32208 upstream.

mask_user_address() incorrectly checks for CONFIG_E500 instead of
CONFIG_PPC_E500, causing mask_user_address_isel() to not be used on
E500 hardware. Fix the check to use the correct name.

Fixes: 861574d51bbd ("powerpc/uaccess: Implement masked user access")
Cc: stable@vger.kernel.org # 7.0+
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Fixes: 861574d51bbd ("powerpc/uaccess: Implement masked user access")
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260615233729.29386-1-enelsonmoore@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -511,7 +511,7 @@ static inline void __user *mask_user_add
 
 	if (IS_ENABLED(CONFIG_PPC64))
 		return mask_user_address_simple(ptr);
-	if (IS_ENABLED(CONFIG_E500))
+	if (IS_ENABLED(CONFIG_PPC_E500))
 		return mask_user_address_isel(ptr);
 	if (TASK_SIZE <= UL(SZ_2G) && border >= UL(SZ_2G))
 		return mask_user_address_simple(ptr);


