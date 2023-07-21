Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3D91ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E4CC433CA;
	Fri, 21 Jul 2023 18:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965454;
	bh=0pUfJIBp2hc9NQBmlBzlR7LOQhF7dGUU63YKR0g7/MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIkovS5mVKlJeynV9uInFx6IV6sivYTvvBhApZ2wbndvFo2WMXUO0mRFMmK+VBSzZ
	 alwypWuzITttY5ZVpd7MZ9MlpGGvAoqfXXE4vzPTyxxncR3q0jRtXAOIkbtkrTQrjq
	 Lsy3bp9JAI1Ta/242SkUdpLk6MNH4rxlGch1GE+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 290/292] net: dsa: ocelot: unlock on error in vsc9959_qos_port_tas_set()
Date: Fri, 21 Jul 2023 18:06:39 +0200
Message-ID: <20230721160541.416710183@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit cad7526f33ce1e7d387d1d0568a089e41deec5c2 upstream.

This error path needs call mutex_unlock(&ocelot->tas_lock) before
returning.

Fixes: 2d800bc500fb ("net/sched: taprio: replace tc_taprio_qopt_offload :: enable with a "cmd" enum")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1449,7 +1449,8 @@ static int vsc9959_qos_port_tas_set(stru
 		mutex_unlock(&ocelot->tas_lock);
 		return 0;
 	} else if (taprio->cmd != TAPRIO_CMD_REPLACE) {
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto err_unlock;
 	}
 
 	ret = ocelot_port_mqprio(ocelot, port, &taprio->mqprio);


