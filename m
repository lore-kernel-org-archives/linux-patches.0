Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BE8144D34;
	Thu, 13 Jun 2024 12:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280880; cv=none; b=fhbrXvcgbbqyCVfFhG7XSRuHsSzKEVQDi4K5OX2yK/xY+aX3esiql/r7kSLG5bi1A24kuRaOiBI//hfMlPlE5INNvJ2RPhX0JKk06F94D8mDRRkC+HrLkE+uR3E8uw/RE24SFbzYWlLAX+NHNsFbUC5H8hvjk4DgjvevweeWCZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280880; c=relaxed/simple;
	bh=VJCpxQd7kfBtjpy90nuU3ecMEpsL6o+YDxjw3fgw98E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cne4Gep4U1dUMICUibYdyixFH/MgbHAlZNLy6ne1xH8Shdlxa5AvWAbyGIoQK2nyprI1jkVpE67XQHNyGstKsJ1EIb/RqWGekgZPKuGcnMwQK0OjrpnC1DEzHZjMXP/qqSw9ghtQkvi4fcRplD75wg9/BuUB9rPVCdwioP79uIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huerAjB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huerAjB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02EEC2BBFC;
	Thu, 13 Jun 2024 12:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280880;
	bh=VJCpxQd7kfBtjpy90nuU3ecMEpsL6o+YDxjw3fgw98E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huerAjB2gt/Jk1d/rtXDnNsHFCtwVsuL5CX4D/dCNSoU351CI8BjLHANMSdCKlYuW
	 tu22rdwMIUK50J+E26mIOMhL5HR4UfAl7UdbRuaKcmgZzVJgVx7HhsiZh2Bt9aWUM6
	 OJtC67qDpF+Oes/BsAXAEJIkWyQL2Upd2ekzX/Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/317] x86/boot: Ignore relocations in .notes sections in walk_relocs() too
Date: Thu, 13 Jun 2024 13:30:53 +0200
Message-ID: <20240613113248.901214976@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0043fd374a62f..f9ec998b7e946 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -689,6 +689,15 @@ static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
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



