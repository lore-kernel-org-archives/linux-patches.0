Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFE81C862D;
	Tue, 13 Oct 2026 12:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894428; cv=none; b=Q7WXk2ZhJ6LBG9XEhV6MiRhPINd6BXnINXwg/OwiW3unvoLzXtATloXdUIK1BGAE+WiSbe0IRllDHfjV0AdIPHQ9dEmWFih37Rt1dejmWeFSGCfmPGLxEKCua/1jDjmiaBJGI5QJN6ouE0hkIUAo5xoIQOyLUACep+nQ15Sixhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894428; c=relaxed/simple;
	bh=jfAzAHJwbM5P0i/eyQWu/SXZuJQQ1y5souzzCEEOiSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYPC3acohOxazqFOoSIR4esN85EZkKEjb/d/gRfxxXf+KmJsLte7LRTUrF85GyUWoj2fJ/1ikOwa96Dj2fzDPdz6pNVS1f+VTWT8VdwPpBh8LposmvfrYnqSkdoG9SNnjYMxLr6cdbpY19Mjn8NeS64bNK+C4Dx88gEtr6S2qlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AH+k/3F6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AH+k/3F6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104D51F000FF;
	Tue, 13 Oct 2026 12:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894427;
	bh=fr1d9LRIM7Ui/w9rk+0Aviw1W8tsavhqP4eG1wSp+Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AH+k/3F6cQoC/Vh8UeRZUzMGsx0P0bhtOm6vNW/KiXdcaJNhQmd43W0S83LiJfqAe
	 yM6D4aL1xnx7+OZ2k6qDvsbSXnk1HUY6BKK0Gz8fLselfxyaKGaSzt+eau3R/ga/Tf
	 BUb0NlW0UwEbCEdDK1Y5d717xHOBVNRD5e6IZa/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 557/621] net: make dev_xdp_sb_prog_count() see programs attached through a link
Date: Tue, 13 Oct 2026 13:39:12 +0200
Message-ID: <20261013112934.029254741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d333c8bca6dc3c5e978f6698d39dd799f3b0dc8d ]

ethtool refuses to enable tcp-data-split on a device running
a single-buffer XDP program (which can't deal with the payload
landing in a separate buffer). dev_xdp_sb_prog_count() only looks
at xdp_state[].prog though, ignoring bpf_link integration.
Get the prog pointer from dev_xdp_prog(), which will consult both.

bpf_xdp_link_update() needs a bit of a touch-up, too, since
ethtool calls dev_xdp_sb_prog_count() with just the instance
lock (for ops-locked devices) - we now have to make sure the
link updates happen under that lock.

Spotted by AI while reviewing the XDP propagation series,
verified and tested on netdevsim with a C test along these lines:

  link = bpf_program__attach_xdp(prog, ifindex);
  system("ethtool -G eth0 tcp-data-split on")

Fixes: 197258f0ef68 ("net: ethtool: add hds_config member in ethtool_netdev_state")
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20261001012559.297751-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b963fe9bd73ec..079352a20cb99 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10206,13 +10206,15 @@ EXPORT_SYMBOL_GPL(dev_xdp_prog_count);
 
 u8 dev_xdp_sb_prog_count(struct net_device *dev)
 {
+	struct bpf_prog *prog;
 	u8 count = 0;
 	int i;
 
-	for (i = 0; i < __MAX_XDP_MODE; i++)
-		if (dev->xdp_state[i].prog &&
-		    !dev->xdp_state[i].prog->aux->xdp_has_frags)
+	for (i = 0; i < __MAX_XDP_MODE; i++) {
+		prog = dev_xdp_prog(dev, i);
+		if (prog && !prog->aux->xdp_has_frags)
 			count++;
+	}
 	return count;
 }
 
@@ -10592,11 +10594,12 @@ static int bpf_xdp_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
 	bpf_op = dev_xdp_bpf_op(xdp_link->dev, mode);
 	err = dev_xdp_install(xdp_link->dev, mode, bpf_op, NULL,
 			      xdp_link->flags, new_prog);
+	if (!err)
+		old_prog = xchg(&link->prog, new_prog);
 	netdev_unlock_ops(xdp_link->dev);
 	if (err)
 		goto out_unlock;
 
-	old_prog = xchg(&link->prog, new_prog);
 	bpf_prog_put(old_prog);
 
 out_unlock:
-- 
2.53.0



