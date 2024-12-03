Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A4C2B9B9;
	Tue,  3 Dec 2024 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242486; cv=none; b=T6pmBrooOJ1sT4lxiNG8NqpM+8G6alLYLOSJf01HkWMVcfnuUFkn8FI4Q7MokHH01XlzaeB+/8+I2ZkSkx7D7t0cLdBu4WLeMA3lpapB8zs1m/AebMBhi8txqeFPi0vKghjz/vXJ3WkDpAVjkQKE3Bo4s19ijwkdMFBfQ9/qepk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242486; c=relaxed/simple;
	bh=+6dSZIcSwQdMEQ7iHuEsmZ0WgSei7QsOLj4D7A+ZkXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhEZD8Nh2WDZDG438Ffc2jxA5j94clzT4Mf57/auxPxwAsVDv84onAyo1yE2ASasLvdTyB2ACGlKlnrXvTFiHXnaqAI09aZK+JC0bTrHCJOG/B+80LhjnWsK4DWWGmw8Io5PkB7DoWWgkyQjLfZ1wYc4qO9aPlGuZJPFbVtBPA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kjIH7M3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kjIH7M3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8C1C4CECF;
	Tue,  3 Dec 2024 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242485;
	bh=+6dSZIcSwQdMEQ7iHuEsmZ0WgSei7QsOLj4D7A+ZkXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kjIH7M30pj/RIIaZNdYt487lGOQi+SISayr9+66kAheNQRmnLXV9jmxKPrxyy4Xr
	 PIgyetrZAcpDFHoEwqV4GW+7n2Z6pMu3qT/dmFzGeaypQ2H7RKa8Kfx3Oxfa2RizSt
	 TpHME+BMf5nxXiLSkloPxSrQX4AZ6MtPtEybAab4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Rosenberg <drosen@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 687/826] Revert "f2fs: remove unreachable lazytime mount option parsing"
Date: Tue,  3 Dec 2024 15:46:54 +0100
Message-ID: <20241203144810.554811624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,6 +150,8 @@ enum {
 	Opt_mode,
 	Opt_fault_injection,
 	Opt_fault_type,
+	Opt_lazytime,
+	Opt_nolazytime,
 	Opt_quota,
 	Opt_noquota,
 	Opt_usrquota,
@@ -226,6 +228,8 @@ static match_table_t f2fs_tokens = {
 	{Opt_mode, "mode=%s"},
 	{Opt_fault_injection, "fault_injection=%u"},
 	{Opt_fault_type, "fault_type=%u"},
+	{Opt_lazytime, "lazytime"},
+	{Opt_nolazytime, "nolazytime"},
 	{Opt_quota, "quota"},
 	{Opt_noquota, "noquota"},
 	{Opt_usrquota, "usrquota"},
@@ -918,6 +922,12 @@ static int parse_options(struct super_bl
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


