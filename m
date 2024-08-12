Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C18917C7C8;
	Mon, 12 Aug 2024 16:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479927; cv=none; b=nkJG5xi959eYQXdL9wXxemD0hwtIjQjALmi7j8wL6cJn0AAKh5h6q4aSFuKLquglxYP1R1A3g3OcDpnGp0MqRdpa1IQPxpp54gas1gTfA1P5PcVUKTRMNOsgISklyBWYsf6hlPv44p4dN3VNqL+oePh2U6YClT2Zo+MI+/phph8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479927; c=relaxed/simple;
	bh=eJCgwKdt1mkLBADtkGwgt4GeNiXNXFOH7hmLj1WeSq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUV4zw7HZgEu2eWes1pUHzwWRrFZQtHYPA3MvORDC0H5YU9eIYTp8gYngE9VPpEp1lbMJXLJotPCeTnOOCUd8eEsKUcJmUeC/x85yawYaZ+TMdDd+XsXPrLXxWclsY9epmOE45FakITs/CgGwvcTwaM1pbYiMDxqJlOC/QzowJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBW9MSye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBW9MSye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D89AC32782;
	Mon, 12 Aug 2024 16:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479927;
	bh=eJCgwKdt1mkLBADtkGwgt4GeNiXNXFOH7hmLj1WeSq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBW9MSye0IvgZV64i7ouu51ODLrD1mM9iju2ZfS4M+qm7Jw/Eq0KBV2okQlSmKasR
	 4z0hLCRbx+zJPju+t49f6eyF+q6raaxGSj4hZt/hmOT1VvXK8G8clFlh2pbVtkI00c
	 zo9vvPLUsOYZcz/ZRsx6TDfSTxjrLl6uD7cTm0eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 016/263] x86/mm: Fix pti_clone_entry_text() for i386
Date: Mon, 12 Aug 2024 18:00:17 +0200
Message-ID: <20240812160147.162755715@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 48c503208c794..bfdf5f45b1370 100644
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



