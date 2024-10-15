Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585A71C07F8;
	Tue, 15 Oct 2024 13:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997553; cv=none; b=d30X2GCnVg1PQH2qU4ljd+y7FsaiFca5E/Kbxd4lgByB529TAhSRhtVDOC2GmlKYELPJd9X9K/OnMl8y/otbCDyD85toTnQlN6oN1DmQwAm/HrcoRwExIgBh8BmtfwEvLlkyBY2Oec9dQl/fyiCwSOKjYa2K4pEO+J7FoDcYHoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997553; c=relaxed/simple;
	bh=+Puqsq4E0/rZSl6raPyN3vTuDWUtoC5FjKNlygQSDz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhPmTkrBJMhW8AdiN8WtXY+z9EdCzFa2C8Wbx+YzwM8xtn7N2yex2DSlB2hmVVfLlZSgcoRH5uBhYpJAaHJTNtJpStTx8tZhp7lrGQ7Tjr02AAolA8ippGdUi7Q3bUNPcx2sX9K9hH53v3ofB5BQ/srPWgcvo45gw7O6A1Juh60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZRnQC6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZRnQC6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A6BC4CEC6;
	Tue, 15 Oct 2024 13:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997553;
	bh=+Puqsq4E0/rZSl6raPyN3vTuDWUtoC5FjKNlygQSDz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZRnQC6a/OVhzbX65gCTe8mBoqHOCPGDj1MKafTN729nuqt26LVJm5sg1D0f/nE7Z
	 YxuUU3OfX4sTQ9bkWkA2fhc/nwwwZLS3Kc4Y53u6OTjAVQ/0ycNicAPciOWYZf3OyZ
	 aPbY6WcWU6x8Z+uN7fXH1tvyC8vt30EnP7+Eh9SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 217/518] Remove *.orig pattern from .gitignore
Date: Tue, 15 Oct 2024 14:42:01 +0200
Message-ID: <20241015123925.372234487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -124,7 +124,6 @@ GTAGS
 # id-utils files
 ID
 
-*.orig
 *~
 \#*#
 


