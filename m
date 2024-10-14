Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3F91C3050;
	Mon, 14 Oct 2024 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919753; cv=none; b=EoHHa2HXmh6nbcxnaiqaqRuYbirKLq9XJ7VdAhU8wpvdKg0w/MOLG5wywNxMb3XtN46Q9tPvxbWTTwa5IYMxqUYmhkisGHCUbBQH5MfqzmgQrwrxskZ53R+94/0tGxI8u976ZDlVtLH5V0LXTkfBuFYLcEHc9MB6sFBT2U4NNVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919753; c=relaxed/simple;
	bh=1xNBLg0C9zYkhGCUHTPCxsJJ2A0j6POo56mb4Pfgr04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDgMISXZopJIDHknwW6yijRC9jUZsxX5moxqe+lQLZg2bqF20qlZ7N0vxYseXduidLlcS0rxOpwmWVpVG6YhehEBzmufbh1Tvw848dnLR1EYXQv3GJK4LG6xoB9h2+U/ZQyDiFVY7mNOiEau9LlNpaGePWO8nHfdVm8jyXUsQCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tda1yt2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tda1yt2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04876C4CED0;
	Mon, 14 Oct 2024 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919752;
	bh=1xNBLg0C9zYkhGCUHTPCxsJJ2A0j6POo56mb4Pfgr04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tda1yt2CFKQK7nZNDj+gyN4f4AQqP8kk0ugD7Oc3V8LxLil5ETA98HVGnktD0RlgP
	 p1QHT/79OzEos0ENjjeqVf1KhBYxa5XrTM7jhgVC+PqkCGZXEab3XfCn+/SM4W7mCz
	 Yhe9YR0B7WerD8N9A+yOolx1NgR1Xh6ssKh5JsC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	"John Warthog9 Hawley (Tenstorrent)" <warthog9@eaglescrag.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 695/798] ktest.pl: Avoid false positives with grub2 skip regex
Date: Mon, 14 Oct 2024 16:20:49 +0200
Message-ID: <20241014141245.372962347@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 449e45bd69665..99e17a0a13649 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2036,7 +2036,7 @@ sub get_grub_index {
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



