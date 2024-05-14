Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BB613C685;
	Tue, 14 May 2024 11:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686376; cv=none; b=D8T+llQt/R7wY+S/ZeDUjPbn271Dn0Ukc2gYitE9hIf8XYRJkIBwYeQefWiTKQaP5Fz60RPXaoLEAgvUuyDjcDimrnX9u/G1G1j7a4qRnv9YYVJYjxCaXmWwLNyLvqWLBXZ8Gs/BYoaCkAUR796PWf91KxZfqQGjlH0EIk6Cpa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686376; c=relaxed/simple;
	bh=998fG5qpjarRgCaluYiIYMig8dDryaDAQIdr3YanzM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVCCV/ak/gVEctPDfnAsBuCBF9qIIFG7vf6yAVAMwAVlVFpjo8qN91XsCJytB4baPyAveiHPAobFLL70qJq5fAtga6DiiJRh2A4Sc0MBALimVNZ6GV9xbD9atx+ruTubudb3KKO60DkSwl/yubym5fBbtVz0qTSB1MmHgVgRldw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgdtDdPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgdtDdPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D32EC32782;
	Tue, 14 May 2024 11:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686375;
	bh=998fG5qpjarRgCaluYiIYMig8dDryaDAQIdr3YanzM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgdtDdPSXx782SS5flcu2Jmv92LK4GxRmfoN6cGR37J7aF79BhlGJevElOrmcVk0N
	 lNyaUkLbYFWgW5F6shSD2MWMXR23T7y/plrMPt8wACofZGT1w80WzQeKx+H9soz9oc
	 mJ+9A0kyvreuU+6jTZ/hOC/7sszFwnC2gYIJe0ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/236] powerpc/pseries: replace kmalloc with kzalloc in PLPKS driver
Date: Tue, 14 May 2024 12:17:28 +0200
Message-ID: <20240514101023.635802757@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nayna Jain <nayna@linux.ibm.com>

[ Upstream commit 212dd5cfbee7815f3c665a51c501701edb881599 ]

Replace kmalloc with kzalloc in construct_auth() function to default
initialize structure with zeroes.

Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221106205839.600442-6-nayna@linux.ibm.com
Stable-dep-of: 784354349d2c ("powerpc/pseries: make max polling consistent for longer H_CALLs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 63a1e1fe01851..bb6f5437d83ab 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -162,19 +162,15 @@ static struct plpks_auth *construct_auth(u8 consumer)
 	if (consumer > PKS_OS_OWNER)
 		return ERR_PTR(-EINVAL);
 
-	auth = kmalloc(struct_size(auth, password, maxpwsize), GFP_KERNEL);
+	auth = kzalloc(struct_size(auth, password, maxpwsize), GFP_KERNEL);
 	if (!auth)
 		return ERR_PTR(-ENOMEM);
 
 	auth->version = 1;
 	auth->consumer = consumer;
-	auth->rsvd0 = 0;
-	auth->rsvd1 = 0;
 
-	if (consumer == PKS_FW_OWNER || consumer == PKS_BOOTLOADER_OWNER) {
-		auth->passwordlength = 0;
+	if (consumer == PKS_FW_OWNER || consumer == PKS_BOOTLOADER_OWNER)
 		return auth;
-	}
 
 	memcpy(auth->password, ospassword, ospasswordlength);
 
-- 
2.43.0



