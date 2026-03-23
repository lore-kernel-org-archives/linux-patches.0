Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F4823BCFD;
	Mon, 23 Mar 2026 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274658; cv=none; b=DJwtWokH7rYnkB/btHx3PcQbyyr6qFcf2ryvTA2RLnEXflDi8baYqVttw2j/lgsGkwpalYb0nF8Kn79XLK50dDp6jMvrCTOHBaNW4ioidVDfNKjWk4x34quNYQdypOHTbSuSGoxyO2BSGoiUSMrFCyAiQq5s1tSQkgM62g2Fao0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274658; c=relaxed/simple;
	bh=ZGSkvr59zLDic5ydJw1JuwxnaLq6kQaTfaobWBgvMmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mt/bcjHCpUQh93xt4iss/Uv90kK5CL+pVUYE0Eru9E2CGdaDeV1koPpQAVjMdVccEBetunnBpHxuHLF4f637sk4e8t6BCO76A4bBo5TqRuYKUO4q4sKROfbMIjbEqlCD6Q82YkzOgbNgv8Iz+6rg6EZzSyKC9KJJGI/rV7awqEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rb1eek0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rb1eek0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C4CC4CEF7;
	Mon, 23 Mar 2026 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274657;
	bh=ZGSkvr59zLDic5ydJw1JuwxnaLq6kQaTfaobWBgvMmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rb1eek0qG0JLSLNIgJplOJzYyxHQd6yAHXAkCn+pLEtDrQDOAuoV+6+lWu4vcgLiO
	 QQqOsfQdIriaSHzbVKnoJjA5tSCxdbVL6d6p4V0R1CBxVb6vZXEfWtNbmm0hhr6ofS
	 bbZbTa8hAkfyU7/xmAAmDj+kEY+c7avvmhy1po/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nicolas Pitre <npitre@baylibre.com>
Subject: [PATCH 6.18 066/212] vt: save/restore unicode screen buffer for alternate screen
Date: Mon, 23 Mar 2026 14:44:47 +0100
Message-ID: <20260323134505.856686795@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <npitre@baylibre.com>

commit 5eb608319bb56464674a71b4a66ea65c6c435d64 upstream.

The alternate screen support added by commit 23743ba64709 ("vt: add
support for smput/rmput escape codes") only saves and restores the
regular screen buffer (vc_origin), but completely ignores the corresponding
unicode screen buffer (vc_uni_lines) creating a messed-up display.

Add vc_saved_uni_lines to save the unicode screen buffer when entering
the alternate screen, and restore it when leaving. Also ensure proper
cleanup in reset_terminal() and vc_deallocate().

Fixes: 23743ba64709 ("vt: add support for smput/rmput escape codes")
Cc: stable <stable@kernel.org>
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Link: https://patch.msgid.link/5o2p6qp3-91pq-0p17-or02-1oors4417ns7@onlyvoer.pbz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c            |    8 ++++++++
 include/linux/console_struct.h |    1 +
 2 files changed, 9 insertions(+)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1345,6 +1345,8 @@ struct vc_data *vc_deallocate(unsigned i
 			kfree(vc->vc_saved_screen);
 			vc->vc_saved_screen = NULL;
 		}
+		vc_uniscr_free(vc->vc_saved_uni_lines);
+		vc->vc_saved_uni_lines = NULL;
 	}
 	return vc;
 }
@@ -1890,6 +1892,8 @@ static void enter_alt_screen(struct vc_d
 	vc->vc_saved_screen = kmemdup((u16 *)vc->vc_origin, size, GFP_KERNEL);
 	if (vc->vc_saved_screen == NULL)
 		return;
+	vc->vc_saved_uni_lines = vc->vc_uni_lines;
+	vc->vc_uni_lines = NULL;
 	vc->vc_saved_rows = vc->vc_rows;
 	vc->vc_saved_cols = vc->vc_cols;
 	save_cur(vc);
@@ -1911,6 +1915,8 @@ static void leave_alt_screen(struct vc_d
 		dest = ((u16 *)vc->vc_origin) + r * vc->vc_cols;
 		memcpy(dest, src, 2 * cols);
 	}
+	vc_uniscr_set(vc, vc->vc_saved_uni_lines);
+	vc->vc_saved_uni_lines = NULL;
 	restore_cur(vc);
 	/* Update the entire screen */
 	if (con_should_update(vc))
@@ -2233,6 +2239,8 @@ static void reset_terminal(struct vc_dat
 	if (vc->vc_saved_screen != NULL) {
 		kfree(vc->vc_saved_screen);
 		vc->vc_saved_screen = NULL;
+		vc_uniscr_free(vc->vc_saved_uni_lines);
+		vc->vc_saved_uni_lines = NULL;
 		vc->vc_saved_rows = 0;
 		vc->vc_saved_cols = 0;
 	}
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -160,6 +160,7 @@ struct vc_data {
 	struct uni_pagedict **uni_pagedict_loc; /* [!] Location of uni_pagedict variable for this console */
 	u32 **vc_uni_lines;			/* unicode screen content */
 	u16		*vc_saved_screen;
+	u32		**vc_saved_uni_lines;
 	unsigned int	vc_saved_cols;
 	unsigned int	vc_saved_rows;
 	/* additional information is in vt_kern.h */


