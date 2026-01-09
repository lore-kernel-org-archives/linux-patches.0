Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC32835B138;
	Fri,  9 Jan 2026 12:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962324; cv=none; b=aBrojEzH/u6AN5Jj7Rvk0Ne4Jbc+Tt123EBGGV5hoHLWmp7zKVL6S0aigFdJvjSrJcjRpevKPfOmegSj95YSbt8jbLBOzorveLftPfMb78bVHXU0IGt03otUyyFsypxJDIGqjYUfduQ/OUEZZszFQIiREl4NHMIQrwGlx27GsCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962324; c=relaxed/simple;
	bh=uHYzwNcqIicwhevKUVKHGJLViNuovIXE+MU9QQbx2FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSvjBBONGR9PmWhw0dkRGsJImWzJv8L8iAB2hFG7NzrnYq9HeMyTF1q4qtLN95c2eQOCtUfwZxazuL8HmecqCZL80lDAzBNANbynVmVfKMjB6Mgq8f+Oh4docZ7pE5z1we1mvIGSKJSPuULCaPV9zDxr87ecFsMBLZVuI5YdVjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTlNFw6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTlNFw6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2966FC16AAE;
	Fri,  9 Jan 2026 12:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962324;
	bh=uHYzwNcqIicwhevKUVKHGJLViNuovIXE+MU9QQbx2FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTlNFw6XpJNpqUI0zyuuUrKCdYR1KJ9/eLJKHsVFSWP+/Eud0q7QgrOQlWoQ5WdKn
	 GzYPmsP4EYHbVzTMnp3xtoR/P4GQX13Oi3swjDRGF8HTwwA2anfLOtj0KoGxstoEY2
	 l7vn625o0KfsAEEVUL2LbE3bakkSxbBA/r2/HvRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Warthog9 Hawley <warthog9@kernel.org>,
	"John W. Krahn" <jwkrahn@shaw.ca>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 326/634] ktest.pl: Fix uninitialized var in config-bisect.pl
Date: Fri,  9 Jan 2026 12:40:04 +0100
Message-ID: <20260109112129.795391262@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit d3042cbe84a060b4df764eb6c5300bbe20d125ca upstream.

The error path of copying the old config used the wrong variable in the
error message:

 $ mkdir /tmp/build
 $ ./tools/testing/ktest/config-bisect.pl -b /tmp/build config-good /tmp/config-bad
 $ chmod 0 /tmp/build
 $ ./tools/testing/ktest/config-bisect.pl -b /tmp/build config-good /tmp/config-bad good
 cp /tmp/build//.config config-good.tmp ... [0 seconds] FAILED!
 Use of uninitialized value $config in concatenation (.) or string at ./tools/testing/ktest/config-bisect.pl line 744.
 failed to copy  to config-good.tmp

When it should have shown:

 failed to copy /tmp/build//.config to config-good.tmp

Cc: stable@vger.kernel.org
Cc: John 'Warthog9' Hawley <warthog9@kernel.org>
Fixes: 0f0db065999cf ("ktest: Add standalone config-bisect.pl program")
Link: https://patch.msgid.link/20251203180924.6862bd26@gandalf.local.home
Reported-by: "John W. Krahn" <jwkrahn@shaw.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/config-bisect.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/ktest/config-bisect.pl
+++ b/tools/testing/ktest/config-bisect.pl
@@ -741,9 +741,9 @@ if ($start) {
 	die "Can not find file $bad\n";
     }
     if ($val eq "good") {
-	run_command "cp $output_config $good" or die "failed to copy $config to $good\n";
+	run_command "cp $output_config $good" or die "failed to copy $output_config to $good\n";
     } elsif ($val eq "bad") {
-	run_command "cp $output_config $bad" or die "failed to copy $config to $bad\n";
+	run_command "cp $output_config $bad" or die "failed to copy $output_config to $bad\n";
     }
 }
 


