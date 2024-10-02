Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087D21D220E;
	Wed,  2 Oct 2024 14:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878581; cv=none; b=HQpH1fuFx4LuQTDThwKch5j1wXwAC+nN+bts28BxdJyUOvoxvBaF5FvUrfMhjT8k2+NNeSnsSY9bE6zOGfbxD74lCnFpBZjJKr4VyNkQT5KWKNKoRzq03HBgU3yUrWKaV2YKBiKTl4ya/PmUio71c57DVSwxtyMgJPnpO6RPAR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878581; c=relaxed/simple;
	bh=Fsvkp5k5CYGp65shdYoXahaAnfT0nm+cAPwkJ7oDcoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsWOBFykMSEql1vxCT17Lp+VXqxMwZcivQqla3oabwHZN4Dw4aOb25/a8Oj+5ZLIIpPn0Y6oJ+9RqdFB+t5GoiRmYh9VdvDOrKiY4N32OgFLb6ZDCGnbnffOoS6B1TnPiph/dsSWcF2xUI9cApyVUPL/UAZdYrJsTjTCGK7tnsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIuD4Zct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIuD4Zct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F073C4CECD;
	Wed,  2 Oct 2024 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878580;
	bh=Fsvkp5k5CYGp65shdYoXahaAnfT0nm+cAPwkJ7oDcoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIuD4ZctOW9oNNFlqbFM49coCqlBk66cVVCJy0VmZkS5AzyvQax3VDD/CEi+OYz07
	 U6zG075hZTzqLbvzl487Eu44PFEzybGRaOF28I7+wgTFuCpns+Z6+MqlqTgx0QxUhH
	 dJRpFqOpclH8zAW7YQSlKuKbLj+143BaFr9+ojRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.10 462/634] Remove *.orig pattern from .gitignore
Date: Wed,  2 Oct 2024 14:59:22 +0200
Message-ID: <20241002125829.338063481@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -136,7 +136,6 @@ GTAGS
 # id-utils files
 ID
 
-*.orig
 *~
 \#*#
 


