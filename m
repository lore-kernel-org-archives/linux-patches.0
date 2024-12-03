Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2951F75BB;
	Tue,  3 Dec 2024 15:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238891; cv=none; b=GRoEtPAyG9OIMfPME0WRDe0pa/RsYTbo1QP4Cv5EPeS/NANE5tmH/6mYZCIRNXuBn1vdbJRlqVbfdFXHXvDt8SQRGroi9lQHoTSnQDvx5Gp0WwxxwGZ9s6+8QOl8Ve0cWPwVfGo1W9AzRuFzn2NscHdFa+klygcEHE2Ua71VIyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238891; c=relaxed/simple;
	bh=1h9wZxQ7pKHRn8iCOtTGHQeI29XP3eQLpz9hzIuZNQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EVWj3TVguspSSinaeh9/sIw9TOUSvNytHElrvJJJkNB4rdudDm9mYBUyQgfq/L+jaeXsptFeKIgrr244k1kdmuqIy+HtDSmPRd+4nkZOzAcOn7c6rsBJaSohB/klPP5nQE+0Z6VtDjLLc/9MCNLCiZyNKElraWDFrg+FQ9zUurA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBpyNPeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBpyNPeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EDBC4CECF;
	Tue,  3 Dec 2024 15:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238891;
	bh=1h9wZxQ7pKHRn8iCOtTGHQeI29XP3eQLpz9hzIuZNQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBpyNPeq+NdDfKbWWgwaz1NhwUfEQo7qJenwwzwRVnRzK4Df8WdFAwyXcnbVoWm4R
	 TyXprZqxb3vU/k5vAIoarV8N/NJT+xBbOhS+87nJyJwyVjq0RILwhexHHpTWb/BVLm
	 +40d10iYMkG85uFG6Npg0lsxuDcbQXjlPWmruyuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@gmail.com>,
	Andy Whitcroft <apw@canonical.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Joe Perches <joe@perches.com>,
	Louis Peens <louis.peens@corigine.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Philippe Schenker <philippe.schenker@toradex.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 432/817] checkpatch: always parse orig_commit in fixes tag
Date: Tue,  3 Dec 2024 15:40:04 +0100
Message-ID: <20241203144012.745370511@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@gmail.com>

[ Upstream commit 2f07b652384969f5d0b317e1daa5f2eb967bc73d ]

Do not require the presence of `$balanced_parens` to get the commit SHA;
this allows a `Fixes: deadbeef` tag to get a correct suggestion rather
than a suggestion containing a reference to HEAD.

Given this patch:

: From: Tamir Duberstein <tamird@gmail.com>
: Subject: Test patch
: Date: Fri, 25 Oct 2024 19:30:51 -0400
:
: This is a test patch.
:
: Fixes: bd17e036b495
: Signed-off-by: Tamir Duberstein <tamird@gmail.com>
: --- /dev/null
: +++ b/new-file
: @@ -0,0 +1 @@
: +Test.

Before:

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: c10a7d25e68f ("Test patch")'

After:

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: bd17e036b495 ("checkpatch: warn for non-standard fixes tag style")'

The prior behavior incorrectly suggested the patch's own SHA and title
line rather than the referenced commit's.  This fixes that.

Ironically this:

Fixes: bd17e036b495 ("checkpatch: warn for non-standard fixes tag style")
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Louis Peens <louis.peens@corigine.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkpatch.pl | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4427572b24771..b03d526e4c454 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3209,36 +3209,31 @@ sub process {
 
 # Check Fixes: styles is correct
 		if (!$in_header_lines &&
-		    $line =~ /^\s*fixes:?\s*(?:commit\s*)?[0-9a-f]{5,}\b/i) {
-			my $orig_commit = "";
-			my $id = "0123456789ab";
-			my $title = "commit title";
-			my $tag_case = 1;
-			my $tag_space = 1;
-			my $id_length = 1;
-			my $id_case = 1;
+		    $line =~ /^\s*(fixes:?)\s*(?:commit\s*)?([0-9a-f]{5,40})(?:\s*($balanced_parens))?/i) {
+			my $tag = $1;
+			my $orig_commit = $2;
+			my $title;
 			my $title_has_quotes = 0;
 			$fixes_tag = 1;
-
-			if ($line =~ /(\s*fixes:?)\s+([0-9a-f]{5,})\s+($balanced_parens)/i) {
-				my $tag = $1;
-				$orig_commit = $2;
-				$title = $3;
-
-				$tag_case = 0 if $tag eq "Fixes:";
-				$tag_space = 0 if ($line =~ /^fixes:? [0-9a-f]{5,} ($balanced_parens)/i);
-
-				$id_length = 0 if ($orig_commit =~ /^[0-9a-f]{12}$/i);
-				$id_case = 0 if ($orig_commit !~ /[A-F]/);
-
+			if (defined $3) {
 				# Always strip leading/trailing parens then double quotes if existing
-				$title = substr($title, 1, -1);
+				$title = substr($3, 1, -1);
 				if ($title =~ /^".*"$/) {
 					$title = substr($title, 1, -1);
 					$title_has_quotes = 1;
 				}
+			} else {
+				$title = "commit title"
 			}
 
+
+			my $tag_case = not ($tag eq "Fixes:");
+			my $tag_space = not ($line =~ /^fixes:? [0-9a-f]{5,40} ($balanced_parens)/i);
+
+			my $id_length = not ($orig_commit =~ /^[0-9a-f]{12}$/i);
+			my $id_case = not ($orig_commit !~ /[A-F]/);
+
+			my $id = "0123456789ab";
 			my ($cid, $ctitle) = git_commit_info($orig_commit, $id,
 							     $title);
 
-- 
2.43.0



