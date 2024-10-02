Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C171D04A9;
	Wed,  2 Oct 2024 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876636; cv=none; b=px1vWPrgxuyAhvP5Ovr8x+OoKVKNoG3Jg3rdiVIlple/ga6iJiLyuF51sJRfSiqUnkBbZ6lMuQQIH9+GucQWaXHjNqrjqonksQ7YvxB+NRPGfNVHB5JdpJowehnaN7LTO4AQcF9c7Vx4UI23Mtay1duwUIn/YZi5mKCUk28PUoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876636; c=relaxed/simple;
	bh=HtHZMeIiJ6SDlrB8Xlmk1nFfG4wuNjq0UXKFiPemEiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOlb5Jv4NxsjU/ms8gV5m113qo4kNEVC0JBojGRzdzmBl1Ytq/OOY6NT6QTXiC4PpzBPZDYiji5MZyX0l9qutlg4nmuRN7cWpM2nJPH8rnt12Db3I2RI3cQcqsbkr/7OTdGsqh/bSgR3Oy/RJe06BhCWsZQFyI/BqLRhPwjyCBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDq14M79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDq14M79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714CCC4CEC5;
	Wed,  2 Oct 2024 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876635;
	bh=HtHZMeIiJ6SDlrB8Xlmk1nFfG4wuNjq0UXKFiPemEiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDq14M79sYPj9joEnTGBK4HPv5k4ILhVmreI0LsWG5A4WWfe40oGo1JN8IdsfrfzP
	 5OGQBkd/rJg5p3S4JigWjuqGcTa5uvG2/JIgPH1WXPZ/Y4TIyxW6669nB0qzpp1JiA
	 Fs1ewZWcnROlA3l2NTAdhOtkAfodZo0RV+5G8zLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.11 511/695] Remove *.orig pattern from .gitignore
Date: Wed,  2 Oct 2024 14:58:29 +0200
Message-ID: <20241002125842.880085786@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -142,7 +142,6 @@ GTAGS
 # id-utils files
 ID
 
-*.orig
 *~
 \#*#
 


