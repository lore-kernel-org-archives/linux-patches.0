Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09FDC2D0;
	Mon, 11 Dec 2023 18:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftLqT/wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68011C433C8;
	Mon, 11 Dec 2023 18:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319549;
	bh=C9/owswsWOMHNsw+TcRE57AiiCN8sgqasPFB7Vu95Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftLqT/wfIF9qBnSjCd87nYlYqxeG6uE34M3hpkppr3jBqnlmdYhuyDjtvUdkHrh9T
	 B8kmK/JeJQOy3SPHl7n/5aKfVSfkKnrMxtyOJ1G4CbQv5VEZOrejUgsL1NrIbTVWj0
	 VI4fxciUeg25qWt3Qryic7WJiliZHuMC80ZoITGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ira Weiny <ira.weiny@intel.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Peter Collingbourne <pcc@google.com>,
	Tom Rix <trix@redhat.com>,
	Tony Luck <tony.luck@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 147/244] highmem: fix a memory copy problem in memcpy_from_folio
Date: Mon, 11 Dec 2023 19:20:40 +0100
Message-ID: <20231211182052.401694968@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

commit 73424d00dc63ba681856e06cfb0a5abbdb62e2b5 upstream.

Clang static checker complains that value stored to 'from' is never read.
And memcpy_from_folio() only copy the last chunk memory from folio to
destination.  Use 'to += chunk' to replace 'from += chunk' to fix this
typo problem.

Link: https://lkml.kernel.org/r/20231130034017.1210429-1-suhui@nfschina.com
Fixes: b23d03ef7af5 ("highmem: add memcpy_to_folio() and memcpy_from_folio()")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/highmem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 4cacc0e43b51..be20cff4ba73 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -454,7 +454,7 @@ static inline void memcpy_from_folio(char *to, struct folio *folio,
 		memcpy(to, from, chunk);
 		kunmap_local(from);
 
-		from += chunk;
+		to += chunk;
 		offset += chunk;
 		len -= chunk;
 	} while (len > 0);
-- 
2.43.0



