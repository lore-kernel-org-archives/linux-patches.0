Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEE21547F3;
	Mon, 14 Oct 2024 14:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916010; cv=none; b=NATBIerNCDyahh0v98N2Ms0SJ6rhPEagBMbOe+kMwsT7OwvJkNH/S/YlcUECWnyEUW51Uar7eKMK9TEfnH53brOpVd17vnrWM6ukThu3h62Rz5655+wFc/w2gjirIdidV80hnvHGjiT0OpMeceYqP5Ospu11klDgCq9Z/FrakV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916010; c=relaxed/simple;
	bh=aLbGIHC2Y+tPD2Qd70DQhUU+PjXiur/PBc1bRW26IkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3D9QA+oAsiQwPwcRAOYgImSRVZO38ekk/0sr78mh+g4D5NJEBMwefqpL/ZBkVd7zWwEcd77twJNGXNBgfuRStKRNWpB9ufihtznIBZlIrt5biPqMPQL8PuNNVi938XP0gusXHprxFSXGCfK0lqzQsVAESiiI1VF5GdfQwhngiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttPUpTKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttPUpTKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A66C4CEC3;
	Mon, 14 Oct 2024 14:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916010;
	bh=aLbGIHC2Y+tPD2Qd70DQhUU+PjXiur/PBc1bRW26IkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttPUpTKHarY2roBN2V3rWyoc/UBfkKbtJ4aOANTzybd6yymCO0xudwbd/SnmbCuNO
	 P1gdbXasy1d8m6EVNrPpWfHx62kdz3zE3Ekt9KdCTXbODrk/7lbumMJL8Y4PnyR/Uz
	 kHRWZznZEZP1TH5KnFKupZIK0TFBcbPm00N+Wx/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	"John Warthog9 Hawley (Tenstorrent)" <warthog9@eaglescrag.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 028/214] ktest.pl: Avoid false positives with grub2 skip regex
Date: Mon, 14 Oct 2024 16:18:11 +0200
Message-ID: <20241014141046.091051555@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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
index eb31cd9c977bf..e24cd825e70a6 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2047,7 +2047,7 @@ sub get_grub_index {
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



