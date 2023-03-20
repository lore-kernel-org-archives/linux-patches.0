Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD231C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16D4C433D2;
	Mon, 20 Mar 2023 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324747;
	bh=ERsc99xAh4cxNfhLGd0MSLhrJQwmE+3XfHiZEDwNR1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urHbDjxTKyjlaVfwrSgWmSODm7/zEooo7y9jjgGlqjenR2t9I7fc+ITerY/SR+wL+
	 /iSM8qUyq4o9K+gsEr5mjxDzphitnurfbk+jtIo+Y+B7hbJwOHOJCliEpQYqKdX4TY
	 BTEqgfoKLK91mkqtdrFokPGJFRhAE1LwV+DmuGhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/115] qed/qed_dev: guard against a possible division by zero
Date: Mon, 20 Mar 2023 15:53:59 +0100
Message-Id: <20230320145450.569555432@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 1a9dc5610ef89d807acdcfbff93a558f341a44da ]

Previously we would divide total_left_rate by zero if num_vports
happened to be 1 because non_requested_count is calculated as
num_vports - req_count. Guard against this by validating num_vports at
the beginning and returning an error otherwise.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: bcd197c81f63 ("qed: Add vport WFQ configuration APIs")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230309201556.191392-1-d-tatianin@yandex-team.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 0410c3604abdb..ba445724ee65e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -5022,6 +5022,11 @@ static int qed_init_wfq_param(struct qed_hwfn *p_hwfn,
 
 	num_vports = p_hwfn->qm_info.num_vports;
 
+	if (num_vports < 2) {
+		DP_NOTICE(p_hwfn, "Unexpected num_vports: %d\n", num_vports);
+		return -EINVAL;
+	}
+
 	/* Accounting for the vports which are configured for WFQ explicitly */
 	for (i = 0; i < num_vports; i++) {
 		u32 tmp_speed;
-- 
2.39.2



