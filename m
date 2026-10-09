Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3E946AA8C;
	Fri,  9 Oct 2026 14:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555824; cv=none; b=FI/+Su7NmVxy09d7P2Q26IrsAYEnnDAwIV5wQOsuP3++Hf/2ox72PSmYcMbp0FNWX+BxVfclYcPGlLdcX1PCTXK+g3273HX03Z9JCkW+4Kz140rboi83bYKY7v4xL28ZksfQTErVJWjibAcpyW+ilh07EqvCT/TdfjN6hqHffWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555824; c=relaxed/simple;
	bh=y1CqhrsMkWe97hm68e51dx+p9G/Xc3vo1u9I74j0kH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5iLpybF8+KaKA6Q/K4a3wCVngfAxdd3uWdsRuaBFbZmJwYZQp6BJe00j0BGi04EABRzGOuTa7LnDbU4F8kfZXulC5Q0kje58IJmQnqBS3juijsfVIexQAXWGg3zifjcwTf5hWLDzu/fvNa+fisCJYOOmRRZd03pPXdDKHHjNF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hX63Vpsg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hX63Vpsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB5A1F00893;
	Fri,  9 Oct 2026 14:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555822;
	bh=xuH71yFr3kDqvBEolGfo3wO63sEcz3NqzqL1oYGHUl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hX63Vpsg+M+kSMvNAf9SGvXfXlIkQ8pvNiL7h0hcFPDW8I/Pyn7JEM0cazdsvz+Ug
	 FI9z7uNg6CP3/ihAGLF4Jw1EuNgVuVaI7rTHKHhSFvFQgZ7XUCepXjXO62y1HMJj+g
	 x+La79v++zz8ZTB7+Jy4ZoFfVj9dt9vjcZo7G3YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 075/428] of/overlay: dont create "//" paths for fragments targeting the root
Date: Fri,  9 Oct 2026 16:06:52 +0200
Message-ID: <20261009140947.810247537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 276870291656b..83c56dd9b5d83 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -256,6 +256,9 @@ static struct property *dup_and_fixup_symbol_prop(
 	if (!target_path)
 		return NULL;
 	target_path_len = strlen(target_path);
+	/* a root target renders as "/"; drop it to avoid "//" results */
+	if (target_path_len == 1 && target_path[0] == '/' && path_tail_len)
+		target_path_len = 0;
 
 	new_prop = kzalloc_obj(*new_prop);
 	if (!new_prop)
-- 
2.53.0



