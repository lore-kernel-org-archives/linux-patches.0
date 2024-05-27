Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF906168C4;
	Mon, 27 May 2024 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837991; cv=none; b=YgAQf8Gp6vFLVPvaDzLojavON100PuhnUwi9Tw8EVTm3CA3YpdgPACtAhIKhWU/Y17CJDgC5PyJF4dBHQ9m7tIhGbZDSEzyvpuZSdK6r9kxkRDq9NdelWdDUR0qGtNPcwPhwmEMKGXLtNhg2An96mWsiGz3/5hazQCg+oU2HfIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837991; c=relaxed/simple;
	bh=xLTUiq87pqAnmkOmPlHQAK5ECdcr3TjipwfCTCjsixk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoNBoEOE0Emiz42bKTvFhVfyX+dZD75XCItoqOZMUZU25ff5kZoQsalS2WqA8eLEcgT5D1DJagX0MfUw8cD4KMihy9qSlnT36XomqcueDshSnJtGFOhL/blw2stPF1ZVzWDZfkooDBMtQJtUtqzzu/y0SxOJR92Ax8/+v7O9GGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEM+vrL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEM+vrL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CAEC2BBFC;
	Mon, 27 May 2024 19:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837990;
	bh=xLTUiq87pqAnmkOmPlHQAK5ECdcr3TjipwfCTCjsixk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEM+vrL6vCa0UbPAy1JFG6moHYLIwxrqekM3/xQIGDgLlEGqP51H798ZlSe4hwZgt
	 srxVbXpt5eDIcfpt2IIki5IyP/dxtC1AVfC5CrkJdTFTW/b9TDzl9FONMEOH293Ude
	 oV7mfobnpefi8eexYWU3S7Pvilp01rhYAWEDzI+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 217/493] x86/pat: Restructure _lookup_address_cpa()
Date: Mon, 27 May 2024 20:53:39 +0200
Message-ID: <20240527185637.409334057@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 02eac06b820c3eae73e5736ae62f986d37fed991 ]

Modify _lookup_address_cpa() to no longer use lookup_address(), but
only lookup_address_in_pgd().

This is done in preparation of using lookup_address_in_pgd_attr().

No functional change intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20240412151258.9171-4-jgross@suse.com
Stable-dep-of: 5bc8b0f5dac0 ("x86/pat: Fix W^X violation false-positives when running as Xen PV guest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index cd09ddd34eff8..9c1dccfd1f67f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -744,11 +744,14 @@ EXPORT_SYMBOL_GPL(lookup_address);
 static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
 				  unsigned int *level)
 {
-	if (cpa->pgd)
-		return lookup_address_in_pgd(cpa->pgd + pgd_index(address),
-					       address, level);
+	pgd_t *pgd;
+
+	if (!cpa->pgd)
+		pgd = pgd_offset_k(address);
+	else
+		pgd = cpa->pgd + pgd_index(address);
 
-	return lookup_address(address, level);
+	return lookup_address_in_pgd(pgd, address, level);
 }
 
 /*
-- 
2.43.0



