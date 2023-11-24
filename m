Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F982EB15;
	Fri, 24 Nov 2023 19:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09RNWtlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F726C433C8;
	Fri, 24 Nov 2023 19:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853543;
	bh=/Q2id4fhWRIfRa4vMey1DHTn/v98/oKrU09C8W7yGfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09RNWtlgZWP3l6QGodvbfunqqx7rL/opEszgkXbMVYlz7/bnL/CPDUfN3F+Q+hOhP
	 S8QHdI+6Qo4euG45L8HdMu5GZN4bnHwOWKRNX5+X0EN5vMpAwnMPdAOJo2/kr69S+a
	 0zGNXr5nLJqXL9gGcU7URTzaSJH+5rJiWvA7qLNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 230/297] i3c: master: svc: fix SDA keep low when polling IBIWON timeout happen
Date: Fri, 24 Nov 2023 17:54:32 +0000
Message-ID: <20231124172008.239723988@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit dfd7cd6aafdb1f5ba93828e97e56b38304b23a05 upstream.

Upon IBIWON timeout, the SDA line will always be kept low if we don't emit
a stop. Calling svc_i3c_master_emit_stop() there will let the bus return to
idle state.

Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Cc:  <stable@vger.kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231023161658.3890811-6-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -366,6 +366,7 @@ static void svc_i3c_master_ibi_work(stru
 					 SVC_I3C_MSTATUS_IBIWON(val), 0, 1000);
 	if (ret) {
 		dev_err(master->dev, "Timeout when polling for IBIWON\n");
+		svc_i3c_master_emit_stop(master);
 		goto reenable_ibis;
 	}
 


