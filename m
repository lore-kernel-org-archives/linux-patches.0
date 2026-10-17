Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA513876CC;
	Sat, 17 Oct 2026 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256305; cv=none; b=FvHLYzYtt8blU1GYDQsTg16kIdC8NhU4vrN6Wu0Jm2gsW+a7CNf0gBuzPCrm72DqXmghJOj/ghMRAKmrdwgf+wfmUCIjm6ahQzK8B2zEXNupsNY3oA9ZDKaUIjs75J5G9aS0at13qD5CK8Ax2RwN9W6+4jVbJPCnWyj82KkY8kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256305; c=relaxed/simple;
	bh=orfbv/vsSS64nkTnbB8SdhYflSJAbQmgm8OtSi8kdus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiSqw4wVc4InzfeQwmeP+Qy3wkUhiu9o28kmdnCsdfR69XrQqZrlUApGrS/6GObSoSssyiSA+2ykJCCRv2F4ZrqZropZZqr9ZpyGnQ4JJUrxVryXlipPqhrhBRZjwtdRKvQwGBl3rtyAOaZx6/e/6edG/bCQyzFc+RQ10a82S4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbJp103v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbJp103v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384AE1F000C4;
	Sat, 17 Oct 2026 16:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256303;
	bh=sMtfHaT7Nxj0D58Mb4+FHhXPapE0pOHcoo0k571mfq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbJp103vtJ8uHbosIb8yjRmXe3/m9OVa1T7V+oUbWIukpA9ITB1atjue5hxBrMwGM
	 Ynf0wm0QwYTQbGX/SAIXD9nE04lyYo1hdm89ORrroLK+j2ZDnQOJgdRR/IAFiRYwkd
	 z1YNsjlRFhq89pCPawSG932rv1aVy/iKaYVAJ8Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0191/1674] of/overlay: dont create "//" paths for fragments targeting the root
Date: Sat, 17 Oct 2026 17:41:03 +0200
Message-ID: <20261017160436.057147902@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 21c89ff1fc86ffa517f3a9ca1ba5c48e9e37c1ba ]

dup_and_fixup_symbol_prop() rewrites a symbol value by replacing its
"/fragment/__overlay__" prefix with the fragment's target path. When
the fragment targets the root node the target path is "/" and the
result starts with "//", which __of_find_node_by_full_path() cannot
resolve: symbols pointing into such fragments silently stop
resolving.

Drop the target path when it is the root and the tail is non-empty. A
value naming the fragment root itself (empty tail) keeps the "/".

Fixes: d1651b03c2df ("of: overlay: add overlay symbols to live device tree")
Assisted-by: Claude:claude-fable-5 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-7-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index d3ac45080a7b5..bee2cc714761e 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -250,6 +250,9 @@ static struct property *dup_and_fixup_symbol_prop(
 	if (!target_path)
 		return NULL;
 	target_path_len = strlen(target_path);
+	/* a root target renders as "/"; drop it to avoid "//" results */
+	if (target_path_len == 1 && target_path[0] == '/' && path_tail_len)
+		target_path_len = 0;
 
 	new_prop = kzalloc(sizeof(*new_prop), GFP_KERNEL);
 	if (!new_prop)
-- 
2.53.0



