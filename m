Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720221A76A1;
	Tue, 30 Jul 2024 17:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360291; cv=none; b=jIGKTuaM0mAgq42hWCWT3lHHBtD6WjxHCOTP5icFfKrapjKCs/y6X0T76gQsdgg+daF8AFYWRZV81rPmV+cuo2qzJ1lLKVXlKhxXyQT0taiuj0YVFMWXTzuPeOAcUUolD6aECI+80JDSFS6KkEJkvx5kpJbWirJF4JFpwPrA3A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360291; c=relaxed/simple;
	bh=V19M6ukeoWiV4cbITcL6xmaovxb67XZZFq5eyd/47eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOee67uPnCK9l8h+64sH4P46ChvX5dgutKNQwzZmQQCMmeiC9MoMKB7zg29lDGaNn5d1cZ+W+avYyX2PBJhaROwht2Ce4DWtWMHdzmZxp82L2LLmpSPizQ3tu2IKtCbq4m7O4pC0oN2omOZTXwT0YManfUqaN9fm/I55T+9VNXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTaEIkdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTaEIkdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C37C32782;
	Tue, 30 Jul 2024 17:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360291;
	bh=V19M6ukeoWiV4cbITcL6xmaovxb67XZZFq5eyd/47eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTaEIkdUSPz/2+zp+XZyK2gZX9c5Wvo0cLnsMzq9qjyj3+23b1ExonzJUMwBrv8px
	 amjvmMqzcSw2TN5aEhKoIA191UK6kalFddqoVQ3ztnE98HnJmJQ5ZpBjKPAC3Y9V5a
	 HPpL8zHMhykufnTVGs+Wf6BjTRJB+FWYzZTrZxoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 627/809] ALSA: ump: Dont update FB name for static blocks
Date: Tue, 30 Jul 2024 17:48:23 +0200
Message-ID: <20240730151749.607687478@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9a4ab167cfb1dea1df0c0c948205a62c7eb3b85b upstream.

When a device tries to update the FB name string even if its Endpoint
is declared as static, we should skip it, just already done for the FB
info update reply.

Fixes: 37e0e14128e0 ("ALSA: ump: Support UMP Endpoint and Function Block parsing")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240722135929.8612-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -806,6 +806,13 @@ static int ump_handle_fb_name_msg(struct
 	if (!fb)
 		return -ENODEV;
 
+	if (ump->parsed &&
+	    (ump->info.flags & SNDRV_UMP_EP_INFO_STATIC_BLOCKS)) {
+		ump_dbg(ump, "Skipping static FB name update (blk#%d)\n",
+			fb->info.block_id);
+		return 0;
+	}
+
 	ret = ump_append_string(ump, fb->info.name, sizeof(fb->info.name),
 				buf->raw, 3);
 	/* notify the FB name update to sequencer, too */


