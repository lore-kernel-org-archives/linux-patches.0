Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6E5197A68;
	Thu,  6 Jun 2024 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683217; cv=none; b=M1RzuM1zivm//MPDsOWaqZdEmwq4/u9JEYJ0HOBnzmwcombhuq5i34HGVDVkEJ0tpwdNB9KCVCikRdBk/zTOA7TIQFomj1URfzoQf2osnlSsH7iUbaLzYRuiJCsx1q0c0N87M7w6OYjb3DNgDKU43G2K/WgKbeVyeXdqF8ecpWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683217; c=relaxed/simple;
	bh=IZlpXCdWUg6UpjqO/WKMPOYPmxPo1Jqvkz2NYgl/fsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2j6rZ9kSI/a23kUAi1PSXUA4Qwz+e2JqY/7MIMfQVhmYOTDy6Crqr7YeoUlULb9BNwhdxIp+ZsvChJzV2wliyfH+l99b+8OEHVTD7siCUrRBAxtByMShstNT3zH2mVqyvixhwgmq9+74r+7bfDHvqHs++kp9xdDdCXAUFCJFrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yrl1G3m9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yrl1G3m9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C35C2BD10;
	Thu,  6 Jun 2024 14:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683217;
	bh=IZlpXCdWUg6UpjqO/WKMPOYPmxPo1Jqvkz2NYgl/fsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yrl1G3m9ZQLSdMKQWnqLncwetfv2p9w9sKSnvSCVv3uQTKgTI4JLZ9ZcbL10qFB1i
	 feg+00dHSZHe4od9M1G1ugEF+5iBaKUncAb2qE2e5UC3ey4cIrrC2A7K51AhTTMGAm
	 KEQea3QuqhSUFsgslwYJSyccTN1w3zCea9DlUY6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/473] x86/boot: Ignore relocations in .notes sections in walk_relocs() too
Date: Thu,  6 Jun 2024 16:00:23 +0200
Message-ID: <20240606131703.014422765@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Guixiong Wei <weiguixiong@bytedance.com>

[ Upstream commit 76e9762d66373354b45c33b60e9a53ef2a3c5ff2 ]

Commit:

  aaa8736370db ("x86, relocs: Ignore relocations in .notes section")

... only started ignoring the .notes sections in print_absolute_relocs(),
but the same logic should also by applied in walk_relocs() to avoid
such relocations.

[ mingo: Fixed various typos in the changelog, removed extra curly braces from the code. ]

Fixes: aaa8736370db ("x86, relocs: Ignore relocations in .notes section")
Fixes: 5ead97c84fa7 ("xen: Core Xen implementation")
Fixes: da1a679cde9b ("Add /sys/kernel/notes")
Signed-off-by: Guixiong Wei <weiguixiong@bytedance.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20240317150547.24910-1-weiguixiong@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/tools/relocs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 9a5b101c45023..4fd824a448245 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -746,6 +746,15 @@ static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
 		if (!(sec_applies->shdr.sh_flags & SHF_ALLOC)) {
 			continue;
 		}
+
+		/*
+		 * Do not perform relocations in .notes sections; any
+		 * values there are meant for pre-boot consumption (e.g.
+		 * startup_xen).
+		 */
+		if (sec_applies->shdr.sh_type == SHT_NOTE)
+			continue;
+
 		sh_symtab = sec_symtab->symtab;
 		sym_strtab = sec_symtab->link->strtab;
 		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Rel); j++) {
-- 
2.43.0



