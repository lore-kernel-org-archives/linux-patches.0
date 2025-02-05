Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D349E158870;
	Wed,  5 Feb 2025 14:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766456; cv=none; b=ZgScleN5sOoMSt/3Q0yKvAssDYJouZAftekanqWfil04Jo4qf4fUJAU0+88JHcqsv63w6omzxCq6PBa35leR7g1/TpaZpKpC7Y3fNK1Zb9DIpWCnBx+HeGg0vKaBCx5joUODz5ElavlVs4DpY7RMvsbZsQUIuCyF8F3r/yjIq1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766456; c=relaxed/simple;
	bh=2XOxAxSudAee3WccBV0Ik8h+UYmk6ZpHp29RoJvhfOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJDCqCKSBbjgw9/ESUOPQ1QDFqdwIS+j05MEPGWKWO8BoTc1J+7Icsxg+mZLRWdzNdokMb8ISnMEStptdjIXsuzJgH/FqMI+2w6lECfS0GGCBQJW0HMfkIbjeqsWJvv8fUY+Oi1RYVWPoVhzc/JVCKMNAYAmP5zDeFsLUX5bBn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gRplVvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gRplVvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0839BC4CEE2;
	Wed,  5 Feb 2025 14:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766456;
	bh=2XOxAxSudAee3WccBV0Ik8h+UYmk6ZpHp29RoJvhfOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gRplVvF8fTnXPRy0dA4CLNhGRNbcsJFHSyLyqpG+3RUjWiPL/THEe5PqoRokP7eQ
	 tUPsMxmouAQz4f7HpQ1hoFwb8FzegsauAmYIOsSZp+XLpwXZvtnAltjM1rNPdKK5FZ
	 6Nhkoh/SALlqCueib7HeV4nEqLkdBDuzgKkXzplY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Petr Vorel <pvorel@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 364/393] kconfig: fix memory leak in sym_warn_unmet_dep()
Date: Wed,  5 Feb 2025 14:44:43 +0100
Message-ID: <20250205134434.227995844@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 758c42621f7a1..1c0306c9d74e2 100644
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



