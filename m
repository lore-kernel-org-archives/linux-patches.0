Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73F019B3FF;
	Tue, 15 Oct 2024 11:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993082; cv=none; b=EutS7pDL/SWoLixXusPHKwcPGiZr8mxu/22ExjBi0OBGlK29fzgI/5iEZyuZ8sEonfcM0DN4/gAVgXhEJRDfA1H9uOATqh2k7KNy89Oo0LoXZu5j5HwWg8jyh7Dx64ZRty721r6CQwV3IW2ukh1simBnWpEWH7iog33PdP7IwqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993082; c=relaxed/simple;
	bh=StikGcaFCVA78aZerwWBKbaRK2Ky+QjKhUqoCreUMUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJBjaZqyk3aKgIKoQZp5Ct66qZtHOBdxFv+eREjGR027SddQidpBux773EhDyWF3Yyh3Y4NuAOQ1Hg1fr3sb8l0OExwZOwENbdKY/l+EeBSTxyPXeUHnOgKAtu/tb+trXXtBLYAdbx950zM3hKfmEEEqccRzjOIQPhFBbQPwxXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCXhRpel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCXhRpel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A65C4CEC6;
	Tue, 15 Oct 2024 11:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993082;
	bh=StikGcaFCVA78aZerwWBKbaRK2Ky+QjKhUqoCreUMUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCXhRpeluyDhLe1aMvaR/fFyVoKzwFP2UldWUuD4JJJRB1Z1y6mp0KnF6H7vFZhwy
	 Y1UZGazxxDM39WhscmW6nD4UQo2TnsLQb0sK1UyzoY9ZGFnhlHXGeCYsZMJ7hgYKU0
	 3VV060ZI/eUmL+FeWfWtohWT3tfH022dB7T7XG2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 305/691] Remove *.orig pattern from .gitignore
Date: Tue, 15 Oct 2024 13:24:13 +0200
Message-ID: <20241015112452.447683140@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 76be4f5a784533c71afbbb1b8f2963ef9e2ee258 upstream.

Commit 3f1b0e1f2875 (".gitignore update") added *.orig and *.rej
patterns to .gitignore in v2.6.23. The commit message didn't give a
rationale. Later on, commit 1f5d3a6b6532 ("Remove *.rej pattern from
.gitignore") removed the *.rej pattern in v2.6.26, on the rationale that
*.rej files indicated something went really wrong and should not be
ignored.

The *.rej files are now shown by `git status`, which helps located
conflicts when applying patches and lowers the probability that they
will go unnoticed. It is however still easy to overlook the *.orig files
which slowly polute the source tree. That's not as big of a deal as not
noticing a conflict, but it's still not nice.

Drop the *.orig pattern from .gitignore to avoid this and help keep the
source tree clean.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
[masahiroy@kernel.org:
I do not have a strong opinion about this. Perhaps some people may have
a different opinion.

If you are someone who wants to ignore *.orig, it is likely you would
want to do so across all projects. Then, $XDG_CONFIG_HOME/git/ignore
would be more suitable for your needs. gitignore(5) suggests, "Patterns
which a user wants Git to ignore in all situations generally go into a
file specified by core.excludesFile in the user's ~/.gitconfig".

Please note that you cannot do the opposite; if *.orig is ignored by
the project's .gitignore, you cannot override the decision because
$XDG_CONFIG_HOME/git/ignore has a lower priority.

If *.orig is sitting on the fence, I'd leave it to the users. ]
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .gitignore |    1 -
 1 file changed, 1 deletion(-)

--- a/.gitignore
+++ b/.gitignore
@@ -129,7 +129,6 @@ GTAGS
 # id-utils files
 ID
 
-*.orig
 *~
 \#*#
 


