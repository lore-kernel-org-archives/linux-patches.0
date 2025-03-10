Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B42A17CA12;
	Mon, 10 Mar 2025 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629210; cv=none; b=NEk22EQTdkzDIIISblM51ihx0US0ODQMg1EWCVzHTMcXBExarXnKSek8osGvolmHNBs1oKm88RaMJEG+3kK4CMauFi7pgnO4WgOdGzz2kmXvTnzOz71SRns8CiCND//EJXSFC6NpYt02JBalAHOsX+McW9TJn0jW+lLFp56nqCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629210; c=relaxed/simple;
	bh=IEO5vAXGfhv+YMDXYQaDJmk2v6NQgkaa4pC9Xm5ndzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIf7/BnrS4GkkqFEUvWSMdqInoZfmPq7Rz7+go0ciQdlItRg5pvd18qL5ddUZ/gMhDPWWgOggD7Xcy2fYU/2P83gonBTuDtvE6g/3MHdKML4m9RiY15H8Qp5pe1b/HuPznlEwAMaB6YTm0W/o7z1RobBHERcdmicMM0lOwZUbBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eK1UPh+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eK1UPh+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8B5C4CEE5;
	Mon, 10 Mar 2025 17:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629210;
	bh=IEO5vAXGfhv+YMDXYQaDJmk2v6NQgkaa4pC9Xm5ndzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eK1UPh+GHtRPg/fG0iBgjcMeyJp0kOpuN/YPGzN/S25PciWZjd2cc1hh71SJLfVSL
	 1Ex0RSyJojyxuazyZKup3TfBkA8hz56nPepdM573e37omrBJ522H+H7BaKrwJdKDxQ
	 TsdqYAbRu3OZgXA3/CVpNeOf56zvun1KPkmcRglM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Petr Vorel <pvorel@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/620] kconfig: fix memory leak in sym_warn_unmet_dep()
Date: Mon, 10 Mar 2025 18:00:29 +0100
Message-ID: <20250310170552.856288236@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit a409fc1463d664002ea9bf700ae4674df03de111 ]

The string allocated in sym_warn_unmet_dep() is never freed, leading
to a memory leak when an unmet dependency is detected.

Fixes: f8f69dc0b4e0 ("kconfig: make unmet dependency warnings readable")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/symbol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 15d958ba99880..d1e9c06456ae6 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -321,6 +321,7 @@ static void sym_warn_unmet_dep(struct symbol *sym)
 			       "  Selected by [m]:\n");
 
 	fputs(str_get(&gs), stderr);
+	str_free(&gs);
 	sym_warnings++;
 }
 
-- 
2.39.5



