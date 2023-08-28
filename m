Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6640411C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93F2C433C8;
	Mon, 28 Aug 2023 10:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219584;
	bh=UZUxV8fOSr95ODFe6ytZUaWahFRESP2o/jwqPIxnAc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcAv9iGSyKlYpq59Im2NlLVTlVtVJHHhNh1sDI1PvW5YGContRycy8Zz7Buk/92mk
	 yagItQ54Z+CsXNCC8z5lexuAxEkhn/DNZreRtM9e7K4sDaY5fA9uqaig2ZaINcvOli
	 2fbNLEIMc8rIyEHfb68+VlQcQgrbakbO+jl7ZPS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Rik van Riel <riel@surriel.com>,
	Mike Rappoport <rppt@kernel.org>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 5.15 89/89] mm,ima,kexec,of: use memblock_free_late from ima_free_kexec_buffer
Date: Mon, 28 Aug 2023 12:14:30 +0200
Message-ID: <20230828101153.258035606@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
References: <20230828101150.163430842@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Mike Rappoport (IBM) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/kexec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -187,8 +187,8 @@ int ima_free_kexec_buffer(void)
 	if (ret)
 		return ret;
 
-	return memblock_free(addr, size);
-
+	memblock_free_late(addr, size);
+	return 0;
 }
 
 /**


