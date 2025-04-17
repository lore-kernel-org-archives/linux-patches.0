Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AC22571A1;
	Thu, 17 Apr 2025 18:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915891; cv=none; b=IoXy1ExKrdFCcrUylXwBTKA7sF+Ov4vUXHvz+GOnqYLiGSSIZAA2v3d0PnOwdSjbJDtB1YuBNEvvCQStvcZE5YJ8i+30GOtbNL6pAuOv0iXxDzN+UqgnXrodDqC74pcUglqtnjSC95QDSD/CtHygXVM5fB2KsWkON9BPWAbRfto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915891; c=relaxed/simple;
	bh=ehGaxC+bnpsd6/yk2UKBlzRo/9xrDcsV7tdQalR6JUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWC9K0UtLQSzeqtKQgr27niTa67dMFY1Qim6NeSsypAbcTX9TSoqc+1yyO+J9cvBczerg2zEvA+kT2XEK9rGQWf3otvSQUoxblWjoTnakCMRljYCFGzUTSRnxjSVkFcnYhwtpuYdjXBxjzbeOgtRK1bqxOjIBhNilHm/gPcAINY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oo640RQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oo640RQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5866FC4CEE4;
	Thu, 17 Apr 2025 18:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915890;
	bh=ehGaxC+bnpsd6/yk2UKBlzRo/9xrDcsV7tdQalR6JUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oo640RQd04U0v+NRfk9pD75KC653+GBnSKNf0Neq+gJL1sYAMQicKhwu9KkjvfqVC
	 nHtS6YI4q3fvLW7wQOyCW4Lhp+qi507+cIx0KkH2onqHFItsGcJCY4B19z2/xi0yu1
	 2nBJFORyY+f3pIDm+N/D00qCmzdIxegoPxmPkFGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kris Van Hees <kris.van.hees@oracle.com>,
	Jack Vogel <jack.vogel@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.12 273/393] kbuild: exclude .rodata.(cst|str)* when building ranges
Date: Thu, 17 Apr 2025 19:51:22 +0200
Message-ID: <20250417175118.585418466@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kris Van Hees <kris.van.hees@oracle.com>

commit 87bb368d0637c466a8a77433837056f981d01991 upstream.

The .rodata.(cst|str)* sections are often resized during the final
linking and since these sections do not cover actual symbols there is
no need to include them in the modules.builtin.ranges data.

When these sections were included in processing and resizing occurred,
modules were reported with ranges that extended beyond their true end,
causing subsequent symbols (in address order) to be associated with
the wrong module.

Fixes: 5f5e7344322f ("kbuild: generate offset range data for builtin modules")
Cc: stable@vger.kernel.org
Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Jack Vogel <jack.vogel@oracle.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_builtin_ranges.awk | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/generate_builtin_ranges.awk b/scripts/generate_builtin_ranges.awk
index b9ec761b3bef..d4bd5c2b998c 100755
--- a/scripts/generate_builtin_ranges.awk
+++ b/scripts/generate_builtin_ranges.awk
@@ -282,6 +282,11 @@ ARGIND == 2 && !anchor && NF == 2 && $1 ~ /^0x/ && $2 !~ /^0x/ {
 # section.
 #
 ARGIND == 2 && sect && NF == 4 && /^ [^ \*]/ && !($1 in sect_addend) {
+	# There are a few sections with constant data (without symbols) that
+	# can get resized during linking, so it is best to ignore them.
+	if ($1 ~ /^\.rodata\.(cst|str)[0-9]/)
+		next;
+
 	if (!($1 in sect_base)) {
 		sect_base[$1] = base;
 
-- 
2.49.0



