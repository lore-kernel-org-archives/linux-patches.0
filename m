Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A7213FE6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FA3C433C8;
	Wed,  9 Aug 2023 10:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577838;
	bh=agrUiR7r23GEpnUiSCSmjXAKxoZdqOlSbk5TABi+KLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4hOaNvGiBZkYBsVZBa3aRnAIv5Y5ukya6LTCKyX3DJbu8pnznPE6nhxxnGOjF5DU
	 NzK1lH4OfyJuGsMCTkuUSi56ZHDdQ6+2SWntkBy37it0Wu8oeoeSHRIn1xrMpQ6wY/
	 yyOS9epZPHrhqXmWvXqKnRU84iY/8fBiF8D3SEls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sukrut Bellary <sukrut.bellary@linux.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 013/165] firmware: arm_scmi: Fix signed error return values handling
Date: Wed,  9 Aug 2023 12:39:04 +0200
Message-ID: <20230809103643.208399671@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sukrut Bellary <sukrut.bellary@linux.com>

[ Upstream commit 81b233b8dd72f2d1df3da8bd4bd4f8c5e84937b9 ]

Handle signed error return values returned by simple_write_to_buffer().
In case of an error, return the error code.

Fixes: 3c3d818a9317 ("firmware: arm_scmi: Add core raw transmission support")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Sukrut Bellary <sukrut.bellary@linux.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20230718085529.258899-1-sukrut.bellary@linux.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/raw_mode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/raw_mode.c b/drivers/firmware/arm_scmi/raw_mode.c
index 6971dcf72fb99..0493aa3c12bf5 100644
--- a/drivers/firmware/arm_scmi/raw_mode.c
+++ b/drivers/firmware/arm_scmi/raw_mode.c
@@ -818,10 +818,13 @@ static ssize_t scmi_dbg_raw_mode_common_write(struct file *filp,
 	 * before sending it with a single RAW xfer.
 	 */
 	if (rd->tx_size < rd->tx_req_size) {
-		size_t cnt;
+		ssize_t cnt;
 
 		cnt = simple_write_to_buffer(rd->tx.buf, rd->tx.len, ppos,
 					     buf, count);
+		if (cnt < 0)
+			return cnt;
+
 		rd->tx_size += cnt;
 		if (cnt < count)
 			return cnt;
-- 
2.40.1



