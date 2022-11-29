Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB09AD5B;
	Tue, 29 Nov 2022 19:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EFCC433D7;
	Tue, 29 Nov 2022 19:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669748528;
	bh=zcH9Mx4yhhHCBaRFX7gIslk77gGtyEOFhzA1cK2yiwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8E7E715gwiGVSu4+jlPan7GuwyRNtd5NEcmg4zeSs7Ek4RScBsaqVOnMKNCi261t
	 bLOXQt10knqyrBcbgNES9dGvdleL8kciII2JgDy9fG/VQUtNhnLK4ZDPv7NAW1yEIj
	 wc3BqzPAXJDTahjjTxa4rv7aKgvKK/Dpfw09W7z1OUHcoUjBVdhDx+kQxjl29JWj78
	 GCr6YgQ53UI9JUN4EIJZQisd9HE/6zgF2qxSG/iMMODXH0VOBTHWXyA3eWtipSoxjn
	 4ZZwlFtEVW450TYkaQ6X1K/Q2JBDPK7OEhk/0Q8QVHNEvCd8Zcio1F0LBG3vaIvX/5
	 CdyTq6Rp4XdAQ==
From: Nathan Chancellor <nathan@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sami Tolvanen <samitolvanen@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] padata: Do not mark padata_mt_helper() as __init
Date: Tue, 29 Nov 2022 12:01:22 -0700
Message-Id: <20221129190123.872394-2-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129190123.872394-1-nathan@kernel.org>
References: <20221129190123.872394-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building arm64 allmodconfig + ThinLTO with clang and a proposed
modpost update to account for -ffuncton-sections, the following warning
appears:

  WARNING: modpost: vmlinux.o: section mismatch in reference: padata_work_init (section: .text.padata_work_init) -> padata_mt_helper (section: .init.text)
  WARNING: modpost: vmlinux.o: section mismatch in reference: padata_work_init (section: .text.padata_work_init) -> padata_mt_helper (section: .init.text)

In both cases, an __init function calls padata_work_init(), which is not
marked __init, with padata_mt_helper(), another __init function, as a
work function argument.

padata_work_init() is called from non-init paths, otherwise it could be
marked __init to resolve the warning. Instead, remove __init from
padata_mt_helper() to resolve the warning.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: linux-crypto@vger.kernel.org
---
 kernel/padata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index e5819bb8bd1d..c2271d7e446d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -45,7 +45,7 @@ struct padata_mt_job_state {
 };
 
 static void padata_free_pd(struct parallel_data *pd);
-static void __init padata_mt_helper(struct work_struct *work);
+static void padata_mt_helper(struct work_struct *work);
 
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
@@ -425,7 +425,7 @@ static int padata_setup_cpumasks(struct padata_instance *pinst)
 	return err;
 }
 
-static void __init padata_mt_helper(struct work_struct *w)
+static void padata_mt_helper(struct work_struct *w)
 {
 	struct padata_work *pw = container_of(w, struct padata_work, pw_work);
 	struct padata_mt_job_state *ps = pw->pw_data;
-- 
2.38.1

