Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796678F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4C7C433C8;
	Sun, 16 Jul 2023 20:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538593;
	bh=0Wb3YN3LSSc+Q9OQiUzx0KyYdz06qQFnu6448qEC0cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmR0ScXelJpe7kP1JA+YyeW+jwRqpls9aYXh38X0SUCy8APUPKjOfFDaahICNExtA
	 iz5okkz1213xN3YY+vgTV5JjWmqslI0oO1ZWkOkTCkAnczxuS0/HeRsCJX/VXK2sRe
	 fWk/vcsuVX+viN5qNmYqjqSHItTnAM4A1KdFpo/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 507/800] scripts/mksysmap: Fix badly escaped $
Date: Sun, 16 Jul 2023 21:46:00 +0200
Message-ID: <20230716195000.869222265@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre-Clément Tosi <ptosi@google.com>

[ Upstream commit ec336aa83162fe0f3d554baed2d4e2589b69ec6e ]

The backslash characters escaping '$' in the command to sed (intended to
prevent it from interpreting '$' as "end-of-line") are currently being
consumed by the Shell (where they mean that sh should not evaluate what
follows '$' as a variable name). This means that

    sed -e "/ \$/d"

executes the script

    / $/d

instead of the intended

    / \$/d

So escape twice in mksysmap any '$' that actually needs to reach sed
escaped so that the backslash survives the Shell.

Fixes: c4802044a0a7 ("scripts/mksysmap: use sed with in-line comments")
Fixes: 320e7c9d4494 ("scripts/kallsyms: move compiler-generated symbol patterns to mksysmap")
Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mksysmap | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index cb3b1fff3eee8..ec33385261022 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -32,7 +32,7 @@ ${NM} -n ${1} | sed >${2} -e "
 #  (do not forget a space before each pattern)
 
 # local symbols for ARM, MIPS, etc.
-/ \$/d
+/ \\$/d
 
 # local labels, .LBB, .Ltmpxxx, .L__unnamed_xx, .LASANPC, etc.
 / \.L/d
@@ -41,7 +41,7 @@ ${NM} -n ${1} | sed >${2} -e "
 / __efistub_/d
 
 # arm64 local symbols in non-VHE KVM namespace
-/ __kvm_nvhe_\$/d
+/ __kvm_nvhe_\\$/d
 / __kvm_nvhe_\.L/d
 
 # arm64 lld
-- 
2.39.2



