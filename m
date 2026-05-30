Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19C8349CCF;
	Sat, 30 May 2026 17:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162728; cv=none; b=jFmtU6sfx8rFjLIguVU3NaqUN/jVBkVRxj9YwXh4ECXNHgfZDqesp+w+TBJJjn5o1ihi/dyZ5eKrxZNBOPF/IzJQ+GJ6Md3BZ7leFiqIT2ctMUwBG5vR8o53AszPp2iZsGiz/aIEoD8BI1elxI8BhAfwJKTmUxh1yp0O5IuUCdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162728; c=relaxed/simple;
	bh=2mUclnkMKgMMcmmE6wa+fIVyyyo6RjL0HHSykrRb10g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtPYmj1vDfz4xzO/ggJSth8gI/DIQhsO55XRG849t4lDKGSkSb+QapCCqwItjf4oiN8YlbtyxviNoMRAKCS/ITAM7bqeHhXLwjF3mgbdDxV/unQ1egVa37457Ei3rGuK3IlIgiVK/HiI1L2cCzSSttD0g3oEl94M5ubFSUpgTng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvgTcKw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvgTcKw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44F31F00893;
	Sat, 30 May 2026 17:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162727;
	bh=MG2iaVgRQTktagaBKex1ziKo+JHebej1pRLAhzvrbbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvgTcKw9L3ZqHZuYAFb9h3j76FB9uenr58u3n8cMEXVBXh9niilUk7uSgXckiMalg
	 zPhW5XE5aWALax51XXKJpmP236cAo2yk7ghVbQRe+b2ZWyJ+7OabsfdEbAupI4BvbD
	 OlqhbkSSWimt6J5XNofT6oiS9SJNymANHG+oI40E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/776] MIPS: mm: Suppress TLB uniquification on EHINV hardware
Date: Sat, 30 May 2026 17:56:00 +0200
Message-ID: <20260530160241.496131940@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 74283cfe216392c7b776ebf6045b5b15ed9dffcd upstream.

Hardware that supports the EHINV feature, mandatory for R6 ISA and FTLB
implementation, lets software mark TLB entries invalid, which eliminates
the need to ensure no duplicate matching entries are ever created.  This
feature is already used by local_flush_tlb_all(), via the UNIQUE_ENTRYHI
macro, making the preceding call to r4k_tlb_uniquify() superfluous.

The next change will also modify uniquification code such that it'll
become incompatible with the FTLB and MMID features, as well as MIPSr6
CPUs that do not implement 4KiB pages.

Therefore prevent r4k_tlb_uniquify() from being used on EHINV hardware,
as denoted by `cpu_has_tlbinv'.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/tlb-r4k.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index f782214d23d3b..ae7436b860b58 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -630,7 +630,8 @@ static void r4k_tlb_configure(void)
 	temp_tlb_entry = current_cpu_data.tlbsize - 1;
 
 	/* From this point on the ARC firmware is dead.	 */
-	r4k_tlb_uniquify();
+	if (!cpu_has_tlbinv)
+		r4k_tlb_uniquify();
 	local_flush_tlb_all();
 
 	/* Did I tell you that ARC SUCKS?  */
-- 
2.53.0



