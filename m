Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0621C33
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE4AC433D6;
	Wed, 23 Nov 2022 09:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197485;
	bh=524KJ0GvA9MOIvlIeW3/G8LyQQ3ZrlW2tM5Z43f4KK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrdyYntrYsMEtHyeAkxLZNe/Vabj6S6qFKITxS8NgHHpPaYTs2aU8s5l1uKIOLjBt
	 6lXh5DDoE5hgdP6I2PkjHVlnQLMPMO4CxE7DP1xA5CJ8j4hCos6eDroRFjZFJpzaZn
	 x8GN9w1OTACxOEvb89Rx9bh1558HXGM1Ltoo0xc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Borys=20Pop=C5=82awski?= <borysp@invisiblethingslab.com>,
	Borislav Petkov <bp@suse.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.0 277/314] x86/sgx: Add overflow check in sgx_validate_offset_length()
Date: Wed, 23 Nov 2022 09:52:02 +0100
Message-Id: <20221123084638.078879506@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

commit f0861f49bd946ff94fce4f82509c45e167f63690 upstream.

sgx_validate_offset_length() function verifies "offset" and "length"
arguments provided by userspace, but was missing an overflow check on
their addition. Add it.

Fixes: c6d26d370767 ("x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES")
Signed-off-by: Borys Popławski <borysp@invisiblethingslab.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: stable@vger.kernel.org # v5.11+
Link: https://lore.kernel.org/r/0d91ac79-6d84-abed-5821-4dbe59fa1a38@invisiblethingslab.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -356,6 +356,9 @@ static int sgx_validate_offset_length(st
 	if (!length || !IS_ALIGNED(length, PAGE_SIZE))
 		return -EINVAL;
 
+	if (offset + length < offset)
+		return -EINVAL;
+
 	if (offset + length - PAGE_SIZE >= encl->size)
 		return -EINVAL;
 


