Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A4133EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB97EC433EF;
	Mon, 16 Jan 2023 16:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884919;
	bh=ALzszPqXydxenigTkg+/oyZkuCBW0EGnk6IW4CBJjzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRHeVVBvbJGSGQlan8EhYGwJooSAze45Az3w+cSueRjFbQHt/r8tYuQ5VTDK/EcxG
	 wARBl8MxCNmmmZF/138E3CLOrhrrSG6sfk6WXsyyOFwNjxk3/ds3xUg3ATJG2qo3Jr
	 kGE80UL1BOIWLnN1J1+nl2U1VVlxryqbgkrDnWok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/183] platform/surface: aggregator: Add missing call to ssam_request_sync_free()
Date: Mon, 16 Jan 2023 16:51:35 +0100
Message-Id: <20230116154810.565558126@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit c965daac370f08a9b71d573a71d13cda76f2a884 ]

Although rare, ssam_request_sync_init() can fail. In that case, the
request should be freed via ssam_request_sync_free(). Currently it is
leaked instead. Fix this.

Fixes: c167b9c7e3d6 ("platform/surface: Add Surface Aggregator subsystem")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20221220175608.1436273-1-luzmaximilian@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/aggregator/controller.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/surface/aggregator/controller.c b/drivers/platform/surface/aggregator/controller.c
index 43e765199137..c6537a1b3a2e 100644
--- a/drivers/platform/surface/aggregator/controller.c
+++ b/drivers/platform/surface/aggregator/controller.c
@@ -1700,8 +1700,10 @@ int ssam_request_sync(struct ssam_controller *ctrl,
 		return status;
 
 	status = ssam_request_sync_init(rqst, spec->flags);
-	if (status)
+	if (status) {
+		ssam_request_sync_free(rqst);
 		return status;
+	}
 
 	ssam_request_sync_set_resp(rqst, rsp);
 
-- 
2.35.1



