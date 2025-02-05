Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BC118E368;
	Wed,  5 Feb 2025 15:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767839; cv=none; b=eeDLXV89LJBabAcNzcIQZPCAe2MfEhm4gRS9Gr5aDOgnCT0dbZ72IospJlh3ERFmNwB2aLWBb+EbOlNI8KSmXK71ZHs89NzwJMDFcJ6bIkL6xPMgA3TnqqlzpG4sz0YkwNphTNCYLYTfjXMnhb+F7945sipz0BJMkHTVfrgro3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767839; c=relaxed/simple;
	bh=YNvH35D7KuM0SQPHksmQWtuwtvodKrkyToF3wWwJUpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ueHktW/PBAhcypELoythCy1tSrZAuhVg0vkHIh//j2ylrNw5QlfTe4uDbaSNo4Fo7d37IujZq9DgMOH04pKwoY93X9DZabuktFrPUDlO3Z/SrZx8u5125IpqHFoIVRdfHQHO8fD477nfk50nQudHfyh+e0stm0Wb3o5TtT9HH7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naZhONY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naZhONY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BA6C4CED1;
	Wed,  5 Feb 2025 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767839;
	bh=YNvH35D7KuM0SQPHksmQWtuwtvodKrkyToF3wWwJUpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naZhONY/6bhMHis0mDG/TsJ/eAaLj8IjEkjcj4cJKunamHjcFt3Vcw1qT60akWANk
	 fAUb8A4WAxxepXfocqhOR70ZC5EsVXXGKp9EnFTb9SihTGZGH1YQL5on59mgNtmwRQ
	 scHuqLlsIDIZEmBaOmAIv5+5sPo87Y+UxyrTGXDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Wichelmann <marcus.wichelmann@hetzner-cloud.de>,
	Stanislav Fomichev <sdf@fomichev.me>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 516/590] net: xdp: Disallow attaching device-bound programs in generic mode
Date: Wed,  5 Feb 2025 14:44:31 +0100
Message-ID: <20250205134515.006858224@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 3595599fa8360bb3c7afa7ee50c810b4a64106ea ]

Device-bound programs are used to support RX metadata kfuncs. These
kfuncs are driver-specific and rely on the driver context to read the
metadata. This means they can't work in generic XDP mode. However, there
is no check to disallow such programs from being attached in generic
mode, in which case the metadata kfuncs will be called in an invalid
context, leading to crashes.

Fix this by adding a check to disallow attaching device-bound programs
in generic mode.

Fixes: 2b3486bc2d23 ("bpf: Introduce device-bound XDP programs")
Reported-by: Marcus Wichelmann <marcus.wichelmann@hetzner-cloud.de>
Closes: https://lore.kernel.org/r/dae862ec-43b5-41a0-8edf-46c59071cdda@hetzner-cloud.de
Tested-by: Marcus Wichelmann <marcus.wichelmann@hetzner-cloud.de>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20250127131344.238147-1-toke@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7c3e2a448e5c6..2e0fe38d0e877 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9595,6 +9595,10 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 			NL_SET_ERR_MSG(extack, "Program bound to different device");
 			return -EINVAL;
 		}
+		if (bpf_prog_is_dev_bound(new_prog->aux) && mode == XDP_MODE_SKB) {
+			NL_SET_ERR_MSG(extack, "Can't attach device-bound programs in generic mode");
+			return -EINVAL;
+		}
 		if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
 			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
 			return -EINVAL;
-- 
2.39.5



