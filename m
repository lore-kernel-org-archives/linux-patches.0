Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39CF1E907E;
	Wed,  6 Nov 2024 13:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898754; cv=none; b=h4fxBdCHJRcoVGWmYgI5PPvnN8UeXg8GjvYdg6lvXZIJr/9KAFlP+WtLSvGho8yYMPKPiSWgg+neMt1GsXUf01axYEhmDjbaklWHX/j9jkf0J/qX3FmK2eBsxF2OA4qFRT7GQa8fBaS488pL2T6BG0WFemm8R6E0gie8JibseVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898754; c=relaxed/simple;
	bh=nWEJdMDJwwMvIz1mmCyBhDa8KxkeiHZN5cMd3vPpZzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZnY2/K14Do8vSbYehJnJxn+qcyfhrwVFsNf0BufJ57I5skDRaq3eBjOhDQ7tYB/S0iqo7sJf+7b7rcq50vKizbbei9TMpwTiEzgCz7u/CULHP0qYZiyiWnyhmGVhy/Xd6kGvXuBnHZA0ukhvbC8O4H2muGHFdVz6BF8DBdT11k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2udCG43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2udCG43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE50C4CECD;
	Wed,  6 Nov 2024 13:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898754;
	bh=nWEJdMDJwwMvIz1mmCyBhDa8KxkeiHZN5cMd3vPpZzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2udCG431i0WOJUaLrdjSzPqrmFNIq0+ysvWW8V8NkEe7kYUiCi6ujKqZ4ycobE/y
	 yEDVvO/Kpyt59MHl+5sQ9dj+X3jtnF9exFbJ+3oHkXUpo4FCcsdAGVHS5UVWLfHzBL
	 FfD/4HSnmHLlVZ2zZvdy+yBXwGwhOMI4JukjI2HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	"John Warthog9 Hawley (Tenstorrent)" <warthog9@eaglescrag.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 308/462] ktest.pl: Avoid false positives with grub2 skip regex
Date: Wed,  6 Nov 2024 13:03:21 +0100
Message-ID: <20241106120339.135025223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d36612c620981..e7adb429018b2 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1954,7 +1954,7 @@ sub get_grub_index {
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



