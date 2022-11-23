Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105861C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585CAC433C1;
	Wed, 23 Nov 2022 09:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195552;
	bh=D9AwE9MwlcOjNKcKoWPuChCdg7H0zaQ+5h8M/hg2WqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sh5hX6fYNyktEgIrCdqOGYqx2ud2Via+OQGjBDobmV4F3+u+Y4QVRC+puIb29eX/K
	 AcIo8rIdprJXD6agjLWhBymQuQoQmMrjWfIkQKktOfkyHxJEJgBQ+QuYza7i/9Czwj
	 7IXcrgNXQBBDb2iJoF56odGZEOS7ptog//WK+dYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Crequy <albancrequy@linux.microsoft.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Francis Laniel <flaniel@linux.microsoft.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 116/149] maccess: Fix writing offset in case of fault in strncpy_from_kernel_nofault()
Date: Wed, 23 Nov 2022 09:51:39 +0100
Message-Id: <20221123084602.113456650@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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
@@ -83,7 +83,7 @@ long strncpy_from_kernel_nofault(char *d
 	return src - unsafe_addr;
 Efault:
 	pagefault_enable();
-	dst[-1] = '\0';
+	dst[0] = '\0';
 	return -EFAULT;
 }
 #else /* HAVE_GET_KERNEL_NOFAULT */


