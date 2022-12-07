Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4F18BF1;
	Wed,  7 Dec 2022 19:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F079C433C1;
	Wed,  7 Dec 2022 19:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670440653;
	bh=PaMaICE853us6Q/RxDX/uVOJ8q6cqoiuds5087+REG4=;
	h=From:To:Cc:Subject:Date:From;
	b=nG+V7WAvUenA6q1s3Z+J11V2G7OvfEnYjsyvCpxR/y/rex62QW4+NAVwlsSy+7Cwc
	 tN3OMIdt7Z/d1dglELXbn1YYNspb8qizAWpDepS6HSEpnCzLH+JrVFFT1a4649yUKR
	 hXsHzOyeNLLzBRzSVAndTERInXpNaSpM5zz4XIijEelI2XkgNZzDGCYGGFJ8q0jLhA
	 iSwUcjqMMFu4XvrVWk8684zISyfwKBo4v5CiAH7PMFV/ZerY7r1pppZd3anLzHbmlK
	 LzbyAsJPis/BwWoCFFiQ3+aaaoD8X1omTIXZGOqrgL/ZsWAeW3huTvRRXlC+DJ5FIf
	 XpTScd+FDPVwg==
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
Subject: [PATCH v2 0/2] Fix lack of section mismatch warnings with LTO
Date: Wed,  7 Dec 2022 12:16:55 -0700
Message-Id: <20221207191657.2852229-1-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Vincent recently reported an issue with lack of section mismatch
warnings with LTO. This is due to commit 6c730bfc894f ("modpost: handle
-ffunction-sections"), which ignores all function sections for modpost.

I believe this is incorrect, as these function sections may still refer
to symbols in other sections and they will ultimately be coalesced into
.text by vmlinux.lds anyways.

The first patch fixes a warning that I see with allmodconfig + ThinLTO
builds after applying the second patch. The second patch moves ".text.*"
into TEXT_SECTIONS so that modpost audits them for mismatches.

I expect this to go via the kbuild tree with an ack from the padata
maintainers.

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: linux-crypto@vger.kernel.org

v2:
  - Rework first patch to use __ref for padata_work_init() so that
    padata_mt_helper() can remain __init (Daniel). Sami, I did not
    include your tag on this one because it was different enough
    from what you initially reviewed.
  - Pick up Alexander's, Sami's, and Vincent's tags on patch 2.
v1: https://lore.kernel.org/20221129190123.872394-1-nathan@kernel.org/

Nathan Chancellor (2):
  padata: Mark padata_work_init() as __ref
  modpost: Include '.text.*' in TEXT_SECTIONS

 kernel/padata.c       | 4 ++--
 scripts/mod/modpost.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)


base-commit: 76dcd734eca23168cb008912c0f69ff408905235
-- 
2.38.1

