Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB484492E57;
	Sat, 12 Sep 2026 19:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239619; cv=none; b=akbrHAkus7bYWALWvVKfTqlXUjp9iCefp7DNTsg5fxY4oqeJElyucu+H9swiJEnk12lZudC2StCMpwH1l4NOPwUZfvV205pE2VGfs6dE1rKR50UvZFWtSF/LF7G6v6f02dtvHEJFegICPqhIteaTtpN5jE1IFqQaegk8gtS7DlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239619; c=relaxed/simple;
	bh=HLMreAU/EOe0V9cMPtcq4pjZgt6OX+KempeZDaXb1lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRg5y4piBabNRPOVCn0KKNxVBFvK3vzpVDzHFH7qr5DWDx0Z65CSqtR4yk+NsOyooRkXnlqGzZ0GA+6LHK0KR9Yt/LhB6ETnSojY9qOyPKo8pMkJ4lVogZ/3QEItdV30zvReY+xo9n7I7inIaSePep0kWoGgLH3qHLz8PFnsSUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGCLbuNJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGCLbuNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E7F1F000FF;
	Sat, 12 Sep 2026 19:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239618;
	bh=wFTUErPjklidToG9XrnpZLV0Qet4V6pfLyiBpE4m2ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGCLbuNJurNvXb2KBKJshuNMB4Oz1XvXPnhvcGZVPLIy7nukwRaqw5G7SHN8+ua6a
	 ZaSh8IeBCgzGJhdwd/0XoyeAaMBp/UTF+tBPr7BJ5oWZETpX4ar1dWnfIMJ+J0l3MO
	 B5LTLw7zRDPC6HicQC9iTMbkrxy5McVgK1iPRAZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jialu Xu <xujialu@vimux.org>,
	Carlos Llamas <cmllamas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 701/935] scripts/tags.sh: improve compiled sources generation
Date: Sat, 12 Sep 2026 09:02:11 +0200
Message-ID: <20260912065542.915796642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jialu Xu <xujialu@vimux.org>

[ Upstream commit 82089b00ae026f638277c51bf3f36c68ed4021c7 ]

Use grep instead of sed for all compiled sources generation, it is three
times more efficient.

Signed-off-by: Jialu Xu <xujialu@vimux.org>
Tested-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20230601010402.71040-1-xujialu@vimux.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a9b93c34625a ("scripts/tags.sh: Prevent binary files appearing in cscope.files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/tags.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index d40cae4e7ea28..b030fc5fb76ca 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -105,7 +105,7 @@ all_compiled_sources()
 	{
 		echo include/generated/autoconf.h
 		find $ignore -name "*.cmd" -exec \
-			sed -n -E 's/^source_.* (.*)/\1/p; s/^  (\S.*) \\/\1/p' {} \+ |
+			grep -Poh '(?<=^  )\S+|(?<== )\S+[^\\](?=$)' {} \+ |
 		awk '!a[$0]++'
 	} | xargs realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) |
 	sort -u
-- 
2.53.0



