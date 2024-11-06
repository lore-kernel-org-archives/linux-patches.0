Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC51B1DE8A2;
	Wed,  6 Nov 2024 12:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895103; cv=none; b=uGcNEOl//pegaTly0H6w1M3qDMSWkx4Fy1ZZWh0E961iQ0PBAX6zmvwPKJ++7XNJNaDzEwoYA1qSXd9dPgmqc6euPQaAz5rIrxl6G80QkI54+9LQmqU2LdIZSMWiISSbTRN0A+qaeKL6BxasZrTIGhmc6T8fdmfqwpo+MT3KRjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895103; c=relaxed/simple;
	bh=LTP79omZWN9pixJ2bEWBhf+jqEhiHM8xB4CkSR4+nZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFVazwWgwEDQ+n+S2g0OEjiu+Vuulc1u8Tejg2FjmkWoDBt4OB0WoC1uOcE6+cwqd/jznDaOC9xM2k3kPkxl+LwKq8s3ZK9uIcCd/766vsMBn45DwkqjlzuXw5mgjv/goG+cai06FpsgZb944zZCaSZpg0pjYFZWuyB2Y7jOLZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SW/9/QJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SW/9/QJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A62C4CECD;
	Wed,  6 Nov 2024 12:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895103;
	bh=LTP79omZWN9pixJ2bEWBhf+jqEhiHM8xB4CkSR4+nZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SW/9/QJf/mMYNpoS1Kgc3TKypedpWRieJ27AAfQ2mxXaZAXkNYDWZQzY2fPv+uNJ
	 vAozFQbhDv2Ji5sKUMuu9RPrUjg7sZAOQSTYc2l4kxDOh1En7aH9/Mq3oBqQyWK7ZI
	 MQg1sHs669xVrbpZpEj9WOG+T0Q+ww2oo88R18O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 107/350] Remove *.orig pattern from .gitignore
Date: Wed,  6 Nov 2024 13:00:35 +0100
Message-ID: <20241106120323.546491534@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -114,7 +114,6 @@ GTAGS
 # id-utils files
 ID
 
-*.orig
 *~
 \#*#
 


