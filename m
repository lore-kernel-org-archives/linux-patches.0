Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9303A7F4C;
	Mon,  4 May 2026 14:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903845; cv=none; b=H2utOdGk6l8YxwZFpm/aiAu+/MxS81Yba63/bNDzI7tdd5ow5WrH07PMNktCSWpmt+8YA0wjtd4VwafBeXDS1Rfng4nP8GJspZGrPvrr119rQMQt4q7x7wJQ2J4TlWGQAWx0UlAChk0p3Y0gkkGiDNmPvl2EosCRpC6rb6z/7cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903845; c=relaxed/simple;
	bh=WyDigtKvx6ELkIMHyQ2Dx0d/bOFL3ZyY+pKHKABGdhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTq1XfPge+tCrVUTLUWjrlm1zwD1B/WZKYpurBX+20m6bkpIoM+b2ZVycQ7rGLMV7u7i0vaXxDAwFB9g+B1Ok71Tdbb7AwzeWNOsi8iAHVr61xEELF2NKyDSEF3CSGvJYS5vo21Q+mfs+Rtxo9J2bxE7E5IXZNzWjvMRPeqbcHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxMN+j5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxMN+j5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552D8C2BCB8;
	Mon,  4 May 2026 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903845;
	bh=WyDigtKvx6ELkIMHyQ2Dx0d/bOFL3ZyY+pKHKABGdhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxMN+j5cJsV8TuqjfzEtocDi8/g62jWw8iEd5do0qiND4t/5NYZzEQi6vlsjUY4Pn
	 mLxhcuHFXGnY8egFR6Uf70gPOHy0qB5RDBLzcKRV7u+BPJ/11B0umLgTWZnTfc7sJX
	 7PUUgo72ZVqUzLjd31rNbneLrZdU/zrAnpEOsr8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Levinsky <ben.levinsky@amd.com>,
	Tanmay Shah <tanmay.shah@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.18 083/275] remoteproc: xlnx: Only access buffer information if IPI is buffered
Date: Mon,  4 May 2026 15:50:23 +0200
Message-ID: <20260504135146.007196746@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Ben Levinsky <ben.levinsky@amd.com>

commit 38dd6ccfdfbbe865569a52fe1ba9fa1478f672e6 upstream.

In the receive callback check if message is NULL to prevent
possibility of crash by NULL pointer dereferencing.

Signed-off-by: Ben Levinsky <ben.levinsky@amd.com>
Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Fixes: 5dfb28c257b7 ("remoteproc: xilinx: Add mailbox channels for rpmsg")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260303235127.2317955-3-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/xlnx_r5_remoteproc.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/remoteproc/xlnx_r5_remoteproc.c
+++ b/drivers/remoteproc/xlnx_r5_remoteproc.c
@@ -232,17 +232,19 @@ static void zynqmp_r5_mb_rx_cb(struct mb
 
 	ipi = container_of(cl, struct mbox_info, mbox_cl);
 
-	/* copy data from ipi buffer to r5_core */
+	/* copy data from ipi buffer to r5_core if IPI is buffered. */
 	ipi_msg = (struct zynqmp_ipi_message *)msg;
-	buf_msg = (struct zynqmp_ipi_message *)ipi->rx_mc_buf;
-	len = ipi_msg->len;
-	if (len > IPI_BUF_LEN_MAX) {
-		dev_warn(cl->dev, "msg size exceeded than %d\n",
-			 IPI_BUF_LEN_MAX);
-		len = IPI_BUF_LEN_MAX;
+	if (ipi_msg) {
+		buf_msg = (struct zynqmp_ipi_message *)ipi->rx_mc_buf;
+		len = ipi_msg->len;
+		if (len > IPI_BUF_LEN_MAX) {
+			dev_warn(cl->dev, "msg size exceeded than %d\n",
+				 IPI_BUF_LEN_MAX);
+			len = IPI_BUF_LEN_MAX;
+		}
+		buf_msg->len = len;
+		memcpy(buf_msg->data, ipi_msg->data, len);
 	}
-	buf_msg->len = len;
-	memcpy(buf_msg->data, ipi_msg->data, len);
 
 	/* received and processed interrupt ack */
 	if (mbox_send_message(ipi->rx_chan, NULL) < 0)


