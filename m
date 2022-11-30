Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEBF79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F8FC433D6;
	Wed, 30 Nov 2022 18:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833212;
	bh=SZsgRfaC9zLo3t82Oxv9SwbwRO9UQeL7U0vMYqQwdNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ORJ4RnksCWtydc+5gSqTCgsI2fLoDTIzJnPay7rC/TvXOXKHBfhaNyGAr1qgubYH
	 oBPNTd4xx7nAl028Ji5ziAhOnbcJHXkPwOXVbJWqrGf3cKLcKCHD/aM6hgNhwtQ7ks
	 bifNT0JmTXVbAbZPMwWeQAbXNVfe0yR0gJMz/4PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Borys=20Pop=C5=82awski?= <borysp@invisiblethingslab.com>,
	Borislav Petkov <bp@suse.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/206] x86/sgx: Add overflow check in sgx_validate_offset_length()
Date: Wed, 30 Nov 2022 19:21:19 +0100
Message-Id: <20221130180533.685757627@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borys Popławski <borysp@invisiblethingslab.com>

[ Upstream commit f0861f49bd946ff94fce4f82509c45e167f63690 ]

sgx_validate_offset_length() function verifies "offset" and "length"
arguments provided by userspace, but was missing an overflow check on
their addition. Add it.

Fixes: c6d26d370767 ("x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES")
Signed-off-by: Borys Popławski <borysp@invisiblethingslab.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: stable@vger.kernel.org # v5.11+
Link: https://lore.kernel.org/r/0d91ac79-6d84-abed-5821-4dbe59fa1a38@invisiblethingslab.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index a66795e0b685..217777c029ee 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -386,6 +386,9 @@ static int sgx_validate_offset_length(struct sgx_encl *encl,
 	if (!length || !IS_ALIGNED(length, PAGE_SIZE))
 		return -EINVAL;
 
+	if (offset + length < offset)
+		return -EINVAL;
+
 	if (offset + length - PAGE_SIZE >= encl->size)
 		return -EINVAL;
 
-- 
2.35.1



