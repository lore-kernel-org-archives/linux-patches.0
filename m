Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33018BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECAFC433D2;
	Tue,  7 Mar 2023 18:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214468;
	bh=P6HOpyN/XyldF+qZ1RMx9qaU0NScjd4vs8p3ZGSYO3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALyBpgc+p0Bknxsozv3lgfhJsM3+3UN49BzBJE9QS4UHuOQ5rcXwWvVTk109aU7hr
	 ns3D5wOCbqvosGUb1x32CNIKfWEJH1fOxE0G9iv1G+fN7UHYGUdlp7HPP4OV7qFdl1
	 +IYmnc2SQaa9Jjogy8UU9mWyNXTcsPOTZSUBVPN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Chopra <manishc@marvell.com>,
	Bhaskar Upadhaya <bupadhaya@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Alok Prasad <palok@marvell.com>,
	Ariel Elior <aelior@marvell.com>
Subject: [PATCH 6.1 802/885] qede: fix interrupt coalescing configuration
Date: Tue,  7 Mar 2023 18:02:16 +0100
Message-Id: <20230307170036.742072557@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manish Chopra <manishc@marvell.com>

commit 908d4bb7c54caa58253a363d63e797a468eaf321 upstream.

On default driver load device gets configured with unexpected
higher interrupt coalescing values instead of default expected
values as memory allocated from krealloc() is not supposed to
be zeroed out and may contain garbage values.

Fix this by allocating the memory of required size first with
kcalloc() and then use krealloc() to resize and preserve the
contents across down/up of the interface.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Fixes: b0ec5489c480 ("qede: preserve per queue stats across up/down of interface")
Cc: stable@vger.kernel.org
Cc: Bhaskar Upadhaya <bupadhaya@marvell.com>
Cc: David S. Miller <davem@davemloft.net>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2160054
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -970,8 +970,15 @@ static int qede_alloc_fp_array(struct qe
 		goto err;
 	}
 
-	mem = krealloc(edev->coal_entry, QEDE_QUEUE_CNT(edev) *
-		       sizeof(*edev->coal_entry), GFP_KERNEL);
+	if (!edev->coal_entry) {
+		mem = kcalloc(QEDE_MAX_RSS_CNT(edev),
+			      sizeof(*edev->coal_entry), GFP_KERNEL);
+	} else {
+		mem = krealloc(edev->coal_entry,
+			       QEDE_QUEUE_CNT(edev) * sizeof(*edev->coal_entry),
+			       GFP_KERNEL);
+	}
+
 	if (!mem) {
 		DP_ERR(edev, "coalesce entry allocation failed\n");
 		kfree(edev->coal_entry);


