Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0B61863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3925C433EF;
	Wed, 28 Dec 2022 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239101;
	bh=dsKCOMVgNega0a5a9Z/vNNlAAsvl2rzfbIZGODXGg7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h738Xb4oACzwFhrksXOlKak8F1FFKdilJhQMpcm00tTtcVvqnd/qwdDYCSOmEo7aF
	 hdQ+kW7HZZR1v8QU06zkh4aIURSzOw5w1T+5xg3VP0KS144HEfYkzO7lW5oc14HCFY
	 NW2vLavc5L0jxFf4XwwecknftiEi99cNwPORR5B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Ding <victording@chromium.org>,
	Prashant Malani <pmalani@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/731] platform/chrome: cros_ec_typec: zero out stale pointers
Date: Wed, 28 Dec 2022 15:33:55 +0100
Message-Id: <20221228144300.260282157@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Victor Ding <victording@chromium.org>

[ Upstream commit 9a8aadcf0b459c1257b9477fd6402e1d5952ae07 ]

`cros_typec_get_switch_handles` allocates four pointers when obtaining
type-c switch handles. These pointers are all freed if failing to obtain
any of them; therefore, pointers in `port` become stale. The stale
pointers eventually cause use-after-free or double free in later code
paths. Zeroing out all pointer fields after freeing to eliminate these
stale pointers.

Fixes: f28adb41dab4 ("platform/chrome: cros_ec_typec: Register Type C switches")
Fixes: 1a8912caba02 ("platform/chrome: cros_ec_typec: Get retimer handle")
Signed-off-by: Victor Ding <victording@chromium.org>
Acked-by: Prashant Malani <pmalani@chromium.org>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20221207093924.v2.1.I1864b6a7ee98824118b93677868d22d3750f439b@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index d63be2b3d10e..b94abb8f7706 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -157,8 +157,10 @@ static int cros_typec_get_switch_handles(struct cros_typec_port *port,
 
 role_sw_err:
 	typec_switch_put(port->ori_sw);
+	port->ori_sw = NULL;
 ori_sw_err:
 	typec_mux_put(port->mux);
+	port->mux = NULL;
 mux_err:
 	return -ENODEV;
 }
-- 
2.35.1



