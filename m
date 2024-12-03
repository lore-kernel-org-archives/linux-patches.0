Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8FE1E3DED;
	Tue,  3 Dec 2024 15:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239655; cv=none; b=WGIXso6uG3ngflBL141du9eAZ0WmgWA6LBO8JjDXe2NnqErfW7iXb6tO4CwT8K9zCk4GnUx9wdvbHDnQTh+dXGN5+exnjdHV3L9W2+jIZNayhk0ZpIUc9oP8t2kDn+qaRzmBYeawYwXFAfLGcCRw/FVj1lNbDEY+cANuMBiQtdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239655; c=relaxed/simple;
	bh=jxz2bcEhwqnTHPpzGEvU3t/kPoFX4HwgBq1KMJ2BSLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEL4iR2Z3vFbXmw/nDE5oK6hK9lkcS8DSnsfzpM3GEpfO3v6od/q9I/KlLSm9L8ZCr1aRrvyEZfBsrO9IPiQhuel/E40ne99jjHs3+W/7NG67Yg0gb5ZJ37G6asm9bHSAz+X1/J7a8LGGGItDObtDpNjxq74/hKm/tA8bzsWbEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hC927Pbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hC927Pbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7397DC4CECF;
	Tue,  3 Dec 2024 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239654;
	bh=jxz2bcEhwqnTHPpzGEvU3t/kPoFX4HwgBq1KMJ2BSLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hC927PbhmmkfGUMEH4xD12TAO1YX065tOzTFDNYRiaxfR8Jx2Ieew6uKiXyo/VVso
	 P+4vYZM3ITpOwabO1PPybDc0mVf4bCMF05PeAf/ZfK13D+bGQfmbtAFcU8qt9R1+yY
	 CNxM0NT7RLpSC74IcUD9uE8uagXT2mPr/2WUcInk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Rosenberg <drosen@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.11 689/817] Revert "f2fs: remove unreachable lazytime mount option parsing"
Date: Tue,  3 Dec 2024 15:44:21 +0100
Message-ID: <20241203144022.867879792@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit acff9409dd40beaca2bd982678d222e2740ad84b upstream.

This reverts commit 54f43a10fa257ad4af02a1d157fefef6ebcfa7dc.

The above commit broke the lazytime mount, given

mount("/dev/vdb", "/mnt/test", "f2fs", 0, "lazytime");

CC: stable@vger.kernel.org # 6.11+
Signed-off-by: Daniel Rosenberg <drosen@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -151,6 +151,8 @@ enum {
 	Opt_mode,
 	Opt_fault_injection,
 	Opt_fault_type,
+	Opt_lazytime,
+	Opt_nolazytime,
 	Opt_quota,
 	Opt_noquota,
 	Opt_usrquota,
@@ -227,6 +229,8 @@ static match_table_t f2fs_tokens = {
 	{Opt_mode, "mode=%s"},
 	{Opt_fault_injection, "fault_injection=%u"},
 	{Opt_fault_type, "fault_type=%u"},
+	{Opt_lazytime, "lazytime"},
+	{Opt_nolazytime, "nolazytime"},
 	{Opt_quota, "quota"},
 	{Opt_noquota, "noquota"},
 	{Opt_usrquota, "usrquota"},
@@ -919,6 +923,12 @@ static int parse_options(struct super_bl
 			f2fs_info(sbi, "fault_type options not supported");
 			break;
 #endif
+		case Opt_lazytime:
+			sb->s_flags |= SB_LAZYTIME;
+			break;
+		case Opt_nolazytime:
+			sb->s_flags &= ~SB_LAZYTIME;
+			break;
 #ifdef CONFIG_QUOTA
 		case Opt_quota:
 		case Opt_usrquota:


