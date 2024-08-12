Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A59186295;
	Mon, 12 Aug 2024 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478745; cv=none; b=jpu32KDzECoSVoxmfe99tVEezq9bqKdxMTBaEwIV4SxKxwRMLOikgmceMdXxPgs7Zv41hX06LHquotTBiYGXOtG8GNr25d5sTcnbqtiBu4vE8ypLAbqCTORJQ6xba1nDuU7Ojux7oqWLN5SXjo8DfSc1/dtTdB5xj3VQpeMSMKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478745; c=relaxed/simple;
	bh=5VqxpUjNMQpqdX20A3/7bV2ZlFqw091uBVBk2MfSZME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsoM5yk5nXT84EfjIBxrp1OmIY6vb8QPT3GLNDdUDV5wM+vpTm2ArKGaJNJjCL7mIJeiZfHmnt/rOsFgHvWso9VKvl5Qg3MQBb+Zjln7IJvSoS2K7+WmplHA+H1DhUiCskswjEiAoWQYUnw32xdkjYPNc2KepMJYXJrQp1qJbm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vR/Rvbfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vR/Rvbfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53352C32782;
	Mon, 12 Aug 2024 16:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478745;
	bh=5VqxpUjNMQpqdX20A3/7bV2ZlFqw091uBVBk2MfSZME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vR/RvbfwX2DDkEL/qhr3u9nYDlucmWwqRtLAOZQ+g+GNQb4/OvtmM83tflmKZrz47
	 SFg4ed7RQhki+S2IB1emKXpOS4IYzEK1z+sbJKqXVLdSnLoMlwIj1AOL7uUcxwLh85
	 1cOx5Zvbj/B6GsWbHZubAEW9zbhoIEwxKHIBtQ7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/150] x86/mm: Fix pti_clone_entry_text() for i386
Date: Mon, 12 Aug 2024 18:01:27 +0200
Message-ID: <20240812160125.396462533@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 3db03fb4995ef85fc41e86262ead7b4852f4bcf0 ]

While x86_64 has PMD aligned text sections, i386 does not have this
luxery. Notably ALIGN_ENTRY_TEXT_END is empty and _etext has PAGE
alignment.

This means that text on i386 can be page granular at the tail end,
which in turn means that the PTI text clones should consistently
account for this.

Make pti_clone_entry_text() consistent with pti_clone_kernel_text().

Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for 32 bit")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index 2c4037174ed22..7b804c34c0201 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -496,7 +496,7 @@ static void pti_clone_entry_text(void)
 {
 	pti_clone_pgtable((unsigned long) __entry_text_start,
 			  (unsigned long) __entry_text_end,
-			  PTI_CLONE_PMD);
+			  PTI_LEVEL_KERNEL_IMAGE);
 }
 
 /*
-- 
2.43.0



