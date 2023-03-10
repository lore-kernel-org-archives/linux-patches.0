Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCFA8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87750C4339E;
	Fri, 10 Mar 2023 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457591;
	bh=U9LwCidUUgPKBYh/I/AUlqjiF+BElbC3N7KpNePoHkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xh5iwpQshJU3LBc4xBkUDn1q4lC0Y8UqP7hXmKsg+yYhD/TbXkanEIT0nNhymerMH
	 QIDwL35u8NVv/yIZDxz2cvmDmqSpShsHg4rhOXAdK9Uh8SRv9pQdxCXuhVnIr2zXo1
	 Dul06k6ncVXackFT2bUoaEk88gWl3y5Tiaq3srbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.1 190/200] drm/display/dp_mst: Fix down message handling after a packet reception error
Date: Fri, 10 Mar 2023 14:39:57 +0100
Message-Id: <20230310133722.926583480@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Imre Deak <imre.deak@intel.com>

commit 1241aedb6b5c7a5a8ad73e5eb3a41cfe18a3e00e upstream.

After an error during receiving a packet for a multi-packet DP MST
sideband message, the state tracking which packets have been received
already is not reset. This prevents the reception of subsequent down
messages (due to the pending message not yet completed with an
end-of-message-transfer packet).

Fix the above by resetting the reception state after a packet error.

Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221214184258.2869417-2-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3859,7 +3859,7 @@ static int drm_dp_mst_handle_down_rep(st
 	struct drm_dp_sideband_msg_rx *msg = &mgr->down_rep_recv;
 
 	if (!drm_dp_get_one_sb_msg(mgr, false, &mstb))
-		goto out;
+		goto out_clear_reply;
 
 	/* Multi-packet message transmission, don't clear the reply */
 	if (!msg->have_eomt)


