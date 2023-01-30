Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81DC28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530C3C433D2;
	Mon, 30 Jan 2023 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087977;
	bh=NxrHvvFT5My6cG6qxXoZGdOAwmb1fc0K47iCZGwbUTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bY3bYEKJgz1qhqZbZ9Ub+sNNlHmBH7bM8h4F/5VdabXSbAFXTMPhXV3FioajFRi9m
	 Cz+wwpJn0M6DZjNkL207HuNrUDnNxOLfXSnNXP6YwneYr16Gi9LaIpHCRnvdLRqO96
	 ij9PMzB8BAo3ToFumCkk3SidLmZez9d3ztN80fkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szymon Heidrich <szymon.heidrich@gmail.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/204] wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid
Date: Mon, 30 Jan 2023 14:50:10 +0100
Message-Id: <20230130134318.292029219@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Szymon Heidrich <szymon.heidrich@gmail.com>

[ Upstream commit b870e73a56c4cccbec33224233eaf295839f228c ]

Since resplen and respoffs are signed integers sufficiently
large values of unsigned int len and offset members of RNDIS
response will result in negative values of prior variables.
This may be utilized to bypass implemented security checks
to either extract memory contents by manipulating offset or
overflow the data buffer via memcpy by manipulating both
offset and len.

Additionally assure that sum of resplen and respoffs does not
overflow so buffer boundaries are kept.

Fixes: 80f8c5b434f9 ("rndis_wlan: copy only useful data from rndis_command respond")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230111175031.7049-1-szymon.heidrich@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rndis_wlan.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 63ce2443f136..70841d131d72 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -694,8 +694,8 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 		struct rndis_query	*get;
 		struct rndis_query_c	*get_c;
 	} u;
-	int ret, buflen;
-	int resplen, respoffs, copylen;
+	int ret;
+	size_t buflen, resplen, respoffs, copylen;
 
 	buflen = *len + sizeof(*u.get);
 	if (buflen < CONTROL_BUFFER_SIZE)
@@ -730,22 +730,15 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 
 		if (respoffs > buflen) {
 			/* Device returned data offset outside buffer, error. */
-			netdev_dbg(dev->net, "%s(%s): received invalid "
-				"data offset: %d > %d\n", __func__,
-				oid_to_string(oid), respoffs, buflen);
+			netdev_dbg(dev->net,
+				   "%s(%s): received invalid data offset: %zu > %zu\n",
+				   __func__, oid_to_string(oid), respoffs, buflen);
 
 			ret = -EINVAL;
 			goto exit_unlock;
 		}
 
-		if ((resplen + respoffs) > buflen) {
-			/* Device would have returned more data if buffer would
-			 * have been big enough. Copy just the bits that we got.
-			 */
-			copylen = buflen - respoffs;
-		} else {
-			copylen = resplen;
-		}
+		copylen = min(resplen, buflen - respoffs);
 
 		if (copylen > *len)
 			copylen = *len;
-- 
2.39.0



