Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040A71C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54568C433D6;
	Wed, 23 Nov 2022 09:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196190;
	bh=jLIkfQQK4i5fEELjYg2YNlkRlfwFdCvTg7WGfHqRHtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sI4UoFwihAre9c7liu7EYZa5FbdAEKc+8Ru+/Kulwg/QiR0WPs6B99A5t0CiaxXn9
	 ZCtWcjVcFXUjITcavDNnIZm+jZ2gQ4lpC3tqoDZrR0lzPOi7tiNGOzBArE5I6I0JHm
	 eZnlcfj1JEKZK41k3hGzhiucO5FTTEOrMtRijdq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Crequy <albancrequy@linux.microsoft.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Francis Laniel <flaniel@linux.microsoft.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 145/181] maccess: Fix writing offset in case of fault in strncpy_from_kernel_nofault()
Date: Wed, 23 Nov 2022 09:51:48 +0100
Message-Id: <20221123084608.624504876@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alban Crequy <albancrequy@linux.microsoft.com>

commit 8678ea06852cd1f819b870c773d43df888d15d46 upstream.

If a page fault occurs while copying the first byte, this function resets one
byte before dst.
As a consequence, an address could be modified and leaded to kernel crashes if
case the modified address was accessed later.

Fixes: b58294ead14c ("maccess: allow architectures to provide kernel probing directly")
Signed-off-by: Alban Crequy <albancrequy@linux.microsoft.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Francis Laniel <flaniel@linux.microsoft.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> [5.8]
Link: https://lore.kernel.org/bpf/20221110085614.111213-2-albancrequy@linux.microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/maccess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -99,7 +99,7 @@ long strncpy_from_kernel_nofault(char *d
 	return src - unsafe_addr;
 Efault:
 	pagefault_enable();
-	dst[-1] = '\0';
+	dst[0] = '\0';
 	return -EFAULT;
 }
 #else /* HAVE_GET_KERNEL_NOFAULT */


