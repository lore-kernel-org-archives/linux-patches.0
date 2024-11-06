Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0871DF991;
	Wed,  6 Nov 2024 12:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895505; cv=none; b=V/FEHnRL0jvXp4jpEvaS3rVTgYbgKuJ7HIHQN/3VoBfmr3lj2EHP1I2kuyOyxgye9g3HX92OpS9/Lj3wdsRwxtHV7JGoSUTqIQJAUPOJMITsPzDA0fKCcAzGYQQVRgelDmkLnD/evJ7AYVRPQGyEoL/OIDU2jIhdPum3dZROyFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895505; c=relaxed/simple;
	bh=KChvJT4IjdTdm/J696c0rUu41Br9ASlslcK8AWXuQhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FculpahAxR0S3Rmtm6jqPmYeUOwAW85ZJ2dxNPe4LHagitNIWPew9YrkjZ5/dUoN5DnEPsx0ZKu2yXpezVX6LAOwwPE8OEKvdENe6qFdAzDWK31fFYMarL8w+dlmr9D9UlJfVj/+zQDgXibjA3D0gADAvL77DPO/QWPPJVVhJ50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNp+RMOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNp+RMOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31E3C4CECD;
	Wed,  6 Nov 2024 12:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895505;
	bh=KChvJT4IjdTdm/J696c0rUu41Br9ASlslcK8AWXuQhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNp+RMOgVpSR733jyRIhyM0lBLr4p1cePnjYkR/dnlU0nLz9BLetHR8q9RAk89ylU
	 TRYsBg83fP2nglH17l2W05F6XBfjdlQfEydH0B4mt8dOI1tfxV3TthsmKiwiIypBqr
	 fRIZ5flbtVK5mB542B+eUKGIz/VZTY1+QCwRyLnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	"John Warthog9 Hawley (Tenstorrent)" <warthog9@eaglescrag.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 239/350] ktest.pl: Avoid false positives with grub2 skip regex
Date: Wed,  6 Nov 2024 13:02:47 +0100
Message-ID: <20241106120326.854597085@linuxfoundation.org>
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

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 2351e8c65404aabc433300b6bf90c7a37e8bbc4d ]

Some distros have grub2 config files with the lines

    if [ x"${feature_menuentry_id}" = xy ]; then
      menuentry_id_option="--id"
    else
      menuentry_id_option=""
    fi

which match the skip regex defined for grub2 in get_grub_index():

    $skip = '^\s*menuentry';

These false positives cause the grub number to be higher than it
should be, and the wrong kernel can end up booting.

Grub documents the menuentry command with whitespace between it and the
title, so make the skip regex reflect this.

Link: https://lore.kernel.org/20240904175530.84175-1-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: John 'Warthog9' Hawley (Tenstorrent) <warthog9@eaglescrag.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index a29d9e125b00b..fe73902a197c6 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1969,7 +1969,7 @@ sub get_grub_index {
     } elsif ($reboot_type eq "grub2") {
 	$command = "cat $grub_file";
 	$target = '^\s*menuentry.*' . $grub_menu_qt;
-	$skip = '^\s*menuentry';
+	$skip = '^\s*menuentry\s';
 	$submenu = '^\s*submenu\s';
     } elsif ($reboot_type eq "grub2bls") {
         $command = $grub_bls_get;
-- 
2.43.0



