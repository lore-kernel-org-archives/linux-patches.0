Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2AF8BE0
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E35C433CA;
	Mon, 28 Aug 2023 10:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218005;
	bh=FfBfLAxzjvG9s4PdRYLxrQVqGjDoIrWoS0QMkZPVOKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZoNJkjlROpbJ4ziBj8IYOhDfKUN23dwSiI0oZokbdJE3y4mr9GDdrGfFkpEdCajr
	 CmR0RxovSfN9hAIxA4XWgmmv4XezNQ3uQ1s2tAu76EdUWD9Iwqvd4lDNuQnFujhqnb
	 kVYehr805qH8eJdGV9Cpt4r/CcgQRTiF6b/5GLhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Rik van Riel <riel@surriel.com>,
	Mike Rappoport <rppt@kernel.org>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.4 060/129] mm,ima,kexec,of: use memblock_free_late from ima_free_kexec_buffer
Date: Mon, 28 Aug 2023 12:12:19 +0200
Message-ID: <20230828101159.367199743@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit f0362a253606e2031f8d61c74195d4d6556e12a4 upstream.

The code calling ima_free_kexec_buffer runs long after the memblock
allocator has already been torn down, potentially resulting in a use
after free in memblock_isolate_range.

With KASAN or KFENCE, this use after free will result in a BUG
from the idle task, and a subsequent kernel panic.

Switch ima_free_kexec_buffer over to memblock_free_late to avoid
that issue.

Fixes: fee3ff99bc67 ("powerpc: Move arch independent ima kexec functions to drivers/of/kexec.c")
Cc: stable@kernel.org
Signed-off-by: Rik van Riel <riel@surriel.com>
Suggested-by: Mike Rappoport <rppt@kernel.org>
Link: https://lore.kernel.org/r/20230817135759.0888e5ef@imladris.surriel.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/kexec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -184,7 +184,8 @@ int __init ima_free_kexec_buffer(void)
 	if (ret)
 		return ret;
 
-	return memblock_phys_free(addr, size);
+	memblock_free_late(addr, size);
+	return 0;
 }
 #endif
 


