Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB19143C76;
	Thu, 11 Apr 2024 10:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831375; cv=none; b=HhwJxbRFxjIP074ycGEMClwt8x3mjirMM2Mf3JVu8it1iAqpcYl74AZcgPbYf1ap7veMZPUHYyNJFpfKExlFXGoXfchoBvhK5Muw9w4TsugEeFdVEyCIJyIYJr5BPE7UdR5V5Mxb7ElnOnBc7u5SmDmFH+xNVLCVNGM15ANYm5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831375; c=relaxed/simple;
	bh=dwpXfqkFuECqcmVfX0yRN0VZ5IgN/WW+7E0bpv7CmL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AV23ZAMqjFxdBZiTSuUPSKRyzqMvCZ5DnUravXZHPCWukOqlIl+djzngq8ltPZIPlLhIKbSqWbI72FLzoxlUUF1+iVBoXUOMSruLnVB6vaD3xLfdnMybnHEoIiCLMAgwCxqIoWWqQMb7xqe6O4VIAkxs39BGP3iuRXuXZWyPdfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flHFKk5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flHFKk5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6506AC433F1;
	Thu, 11 Apr 2024 10:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831374;
	bh=dwpXfqkFuECqcmVfX0yRN0VZ5IgN/WW+7E0bpv7CmL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flHFKk5ZGXAN+eZu0qn2j3B1yKX0PnW6+7XQJDria41ihlTBBdnb2+g763xtptU7w
	 pEDHM7yWrQIdrcAKTWATRy1rQ/DfhtCf7hRf1/3Q4w2VrtzgVNJXdq9uvq7CtrN9X7
	 o/ykq9/t/Q9kVItAvux4JiT0QoAj/Et0zF8Wyc8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/114] modpost: fix null pointer dereference
Date: Thu, 11 Apr 2024 11:57:07 +0200
Message-ID: <20240411095419.909311343@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 23dfd914d2bfc4c9938b0084dffd7105de231d98 ]

If the find_fromsym() call fails and returns NULL, the warn() call
will dereference this NULL pointer and cause the program to crash.

This happened when I tried to build with "test_user_copy" module.
With this fix, it prints lots of warnings like this:

 WARNING: modpost: lib/test_user_copy: section mismatch in reference: (unknown)+0x4 (section: .text.fixup) -> (unknown) (section: .init.text)

masahiroy@kernel.org:
 The issue is reproduced with ARCH=arm allnoconfig + CONFIG_MODULES=y +
 CONFIG_RUNTIME_TESTING_MENU=y + CONFIG_TEST_USER_COPY=m

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 7d53942445d75..269bd79bcd9ad 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1098,7 +1098,9 @@ static void default_mismatch_handler(const char *modname, struct elf_info *elf,
 	sec_mismatch_count++;
 
 	warn("%s: section mismatch in reference: %s+0x%x (section: %s) -> %s (section: %s)\n",
-	     modname, fromsym, (unsigned int)(faddr - from->st_value), fromsec, tosym, tosec);
+	     modname, fromsym,
+	     (unsigned int)(faddr - (from ? from->st_value : 0)),
+	     fromsec, tosym, tosec);
 
 	if (mismatch->mismatch == EXTABLE_TO_NON_TEXT) {
 		if (match(tosec, mismatch->bad_tosec))
-- 
2.43.0



