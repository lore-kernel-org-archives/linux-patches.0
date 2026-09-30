Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F734E50CF;
	Wed, 30 Sep 2026 15:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783621; cv=none; b=EYaRQK+kQn0qtP9IZYbCHqbGSZpL4PPlhCv1MXKck/EXM6hK7CXi2vrn2rD+AatyJDrUl38jihkU3QYOk2XPILha3BF77cYf3tZJCmVlZbrGWnhuR7SQCheUFeYUERGOtZmsGEqLG1rs2VsBcmZvL90bQdAqJ6NRh25YhWdQXIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783621; c=relaxed/simple;
	bh=fgJfMjxG7zS59CSL3JXLV52q7Dn1k9GwVHQLn5ViDbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcB9M2b6eC9l377d1vj8zhHJPiajq3G16NYYCH8icdNfHWV9QWbkPRjQAjZMpxlSRXoO/FX2X7RVg4SvLuV82vtFCW9lIQXJigzQNIhhdhjp90yUo9qJf5xTqbBMr6nxavADjizjeUiKGncJzIhrSulg0J2oEDGjp6rAMmZcBE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTqlVNBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTqlVNBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906161F00893;
	Wed, 30 Sep 2026 15:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783617;
	bh=yFlhLmyKupB/oNjQnDaMqRkicofNOlyozMripXS5MyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTqlVNBS4NDhtuNOmL27UeB7Qn+BvaZKMzecg/EOA92gKE8EBv/vakmCqnKfQgVbH
	 t2gARENPEOZQisS24zSAZM8egw19YKlZIlAbwu5eAMfg6YPe+WxdSgnDA5Rd7PUgXQ
	 UJVNfdZKvlWj6ZmHIQxGd7g6ytzuzDJl8b6CELp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 463/595] wifi: libertas_tf: fix UAF in lbtf_free_adapter()
Date: Wed, 30 Sep 2026 17:25:56 +0200
Message-ID: <20260930152357.641204812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit bbb9a0ab96d44a64529aafc7a16de460a1712f6a upstream.

lbtf_free_adapter() calls lbtf_free_cmd_buffer() to free the command
buffers before calling timer_delete_sync() to wait for the command
timer callback.  If the timer callback (command_timer_fn) is already
running when lbtf_free_cmd_buffer() frees the command array, the
callback dereferences priv->cur_cmd->cmdbuf which points to freed
memory.

Swap the order so that timer_delete_sync() runs first, ensuring any
in-flight callback has completed before the command buffers are freed.

Fixes: 06b16ae53192 ("libertas_tf: main.c, data paths and mac80211 handlers")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Link: https://patch.msgid.link/20260815115724.920628-1-yijiangshan@kylinos.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/libertas_tf/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -173,8 +173,8 @@ static int lbtf_init_adapter(struct lbtf
 static void lbtf_free_adapter(struct lbtf_private *priv)
 {
 	lbtf_deb_enter(LBTF_DEB_MAIN);
-	lbtf_free_cmd_buffer(priv);
 	timer_delete_sync(&priv->command_timer);
+	lbtf_free_cmd_buffer(priv);
 	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 


