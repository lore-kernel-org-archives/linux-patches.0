Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E103A76033;
	Mon, 15 Apr 2024 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192188; cv=none; b=g6jKoEdnj+nHiEC04vJACOpSA8WJxsfs5OmqVolZZYXkPuT6pZM1R8AhTkWCcWs5ywrPGi60xC5u6QK+2PAcLyqu5qzeDIYy83E6aIwK3O6i+sjMlKZEMEnpO6GU7eukv+6Nh5g5ESmqa8kRxe4OxsTrbu2FHvf3aXae63VJdoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192188; c=relaxed/simple;
	bh=0rkNGPE7i1zbvU5PaiiuPkcEnpGEfZkfMa9A9QBS7Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pplvZSSk+LABOBrtChpB0/wrWJRHiJNCSd45jM8pZVBcA3xBS/knHWOufYtIkrrKQMIAMJxHebK80nreHcrMUpmbkxZJqpuGc5Tlal7xwjeerdCj4RJlY/L3PDlqNRrgXfq0+OxpSj+3+0nE6ObApBKIAiDNqgqrvgHWS7gifpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euXPff8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euXPff8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6B4C113CC;
	Mon, 15 Apr 2024 14:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192187;
	bh=0rkNGPE7i1zbvU5PaiiuPkcEnpGEfZkfMa9A9QBS7Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euXPff8oiAk+iPl/1Kz36orekIBfnwTbI3d4OLytj608lW6GmdPJpBVqn/Q6o+yWQ
	 63RuOlVZvG/0q3/G6RefaMQQIHUCmQ+2kDp6oO/o7lQgThdgQy84YjvgxOJgHYGdT0
	 Z3vIcMchIC4uQG7qSpBOI49JLGb5pdgrksQQs9sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/45] scsi: qla2xxx: Fix off by one in qla_edif_app_getstats()
Date: Mon, 15 Apr 2024 16:21:15 +0200
Message-ID: <20240415141942.491923184@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4406e4176f47177f5e51b4cc7e6a7a2ff3dbfbbd ]

The app_reply->elem[] array is allocated earlier in this function and it
has app_req.num_ports elements.  Thus this > comparison needs to be >= to
prevent memory corruption.

Fixes: 7878f22a2e03 ("scsi: qla2xxx: edif: Add getfcinfo and statistic bsgs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/5c125b2f-92dd-412b-9b6f-fc3a3207bd60@moroto.mountain
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 40a03f9c2d21f..ac702f74dd984 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1012,7 +1012,7 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 			if (fcport->edif.enable) {
-				if (pcnt > app_req.num_ports)
+				if (pcnt >= app_req.num_ports)
 					break;
 
 				app_reply->elem[pcnt].rekey_count =
-- 
2.43.0



