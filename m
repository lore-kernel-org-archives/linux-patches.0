Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079CD2FA659;
	Tue, 17 Jun 2025 16:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178745; cv=none; b=VuNXOaq917Yft3J+YjZCgamiEKGQv5y6tiEWSdmoLPb8K9UmxofLKt4SQuKryqkxXS9AbxYQdfwMjT/JMlATPWlUNIaXrw0jyA4+PL45uBN51CeabBd59RQpD1JBLp06twj//Ao6CPic9FcMIWh2ex1YRmXTGVrYfwHv/aUBk4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178745; c=relaxed/simple;
	bh=tf14YffK/sAgw9222nejg53re0sYLJiwsTXld75Nttk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEoLwryfkuyAPXa3oaTpkUf3+cgHHrKA1IqaZ675yq4I1Xmmcph6/WEgjxrTxQG0lKrFVeachv9gfzVbtlaNJYwYqWQ9WXSnm/5gvS3iFMYqnugmllfGZll8gDJyoP6UVJzApQiHB+MdMYud77ntLXjvIcFe3ecdLbigsz+5OlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBCdnq34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBCdnq34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3498C4CEE7;
	Tue, 17 Jun 2025 16:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178744;
	bh=tf14YffK/sAgw9222nejg53re0sYLJiwsTXld75Nttk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBCdnq34SJ0xvbSddKQdffRwV0ShjcFsKi1zvFhhQYTtUd2LtXsfjVngHii78uu4D
	 PA7j6hYHov7+jP2Il6NWFuucsASU2wUJje0Ml+sNk3//JnjnHJP1S5FOXscWdbzky/
	 bRIGTTzJLvaZeflU+6gbGzVS3+2Anj14QB0c4Rks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 539/780] staging: gpib: Fix secondary address restriction
Date: Tue, 17 Jun 2025 17:24:07 +0200
Message-ID: <20250617152513.467941186@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 5aac95320d0f17f1098960e903ce5e087f42bc70 ]

GPIB secondary addresses have valid values between 0 and 31
inclusive. The Make Secondary Address function MSA, used to form
the protocol byte, was using the gpib_address_restrict function
erroneously restricting the address range to 0 through 30.

Remove the call to gpib_address_restrict and simply trim the
address to 5 bits.

Fixes: 2da03e7e31aa ("staging: gpib: Add user api include files")
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250520155100.5808-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/uapi/gpib_user.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gpib/uapi/gpib_user.h b/drivers/staging/gpib/uapi/gpib_user.h
index 5ff4588686fde..0fd32fb9e7a64 100644
--- a/drivers/staging/gpib/uapi/gpib_user.h
+++ b/drivers/staging/gpib/uapi/gpib_user.h
@@ -178,7 +178,7 @@ static inline uint8_t MTA(unsigned int addr)
 
 static inline uint8_t MSA(unsigned int addr)
 {
-	return gpib_address_restrict(addr) | SAD;
+	return (addr & 0x1f) | SAD;
 }
 
 static inline uint8_t PPE_byte(unsigned int dio_line, int sense)
-- 
2.39.5



