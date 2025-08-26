Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C539353364;
	Tue, 26 Aug 2025 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216350; cv=none; b=DQSVUQxPxpFvOTfZh5rAFstL074H3x5FZVIG/Ch3F6cDUEZKuLA/LrsHNoMD80GMRjMuP9mV6kzfedRBHYvVhfXX0qNd1GBMOUVK3y0b1ymgS3AWNe1kZvu0aL7L/OFas2SrQBjb1r1CQlQmht8ZvbvI2JmsQZZO/zrVzO/6ANw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216350; c=relaxed/simple;
	bh=G22Msik/hG3vEj3O0E+zCiDWlFGXEAH6aqGnBVhghlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iK7oYvz2N+RGgbnGw+N1LMYLPO47WpnjvDRoIPQbH3Dqg5eyuAv3eRXltN/Ly9SF4Lfs65dS12Lla/+hTGjbrKGllXgNL/6V8Xy8Z/XQlDIF1+8SE/+iI22btarTP00UAQrIQGVxK3C+nV+q30KsIv9u9C3zExtcbs4J6f/Y0Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5spZzL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5spZzL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D913C19422;
	Tue, 26 Aug 2025 13:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216349;
	bh=G22Msik/hG3vEj3O0E+zCiDWlFGXEAH6aqGnBVhghlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5spZzL1JVnGS35dQW6fAXvQe3A5u2iCPX9JPcuCBJw+vVBkhwbAvE3Qq+iqFyb92
	 unKzKHB268Pq0YmCfoc3EaeEknCqPibz/H2hu4/FbS8QmppAtRlAD6wq/u3YotU3p6
	 3ZenWmsUMZq86PIQ0P9LRqZ0r5QtaEvKzDcwMoHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 377/644] net: ncsi: Fix buffer overflow in fetching version id
Date: Tue, 26 Aug 2025 13:07:48 +0200
Message-ID: <20250826110955.764813834@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>

[ Upstream commit 8e16170ae972c7fed132bc928914a2ffb94690fc ]

In NC-SI spec v1.2 section 8.4.44.2, the firmware name doesn't
need to be null terminated while its size occupies the full size
of the field. Fix the buffer overflow issue by adding one
additional byte for null terminator.

Signed-off-by: Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
Reviewed-by: Paul Fertser <fercerpav@gmail.com>
Link: https://patch.msgid.link/20250610193338.1368-1-kalavakunta.hari.prasad@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/internal.h | 2 +-
 net/ncsi/ncsi-rsp.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 2c260f33b55c..ad1f671ffc37 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -110,7 +110,7 @@ struct ncsi_channel_version {
 	u8   update;		/* NCSI version update */
 	char alpha1;		/* NCSI version alpha1 */
 	char alpha2;		/* NCSI version alpha2 */
-	u8  fw_name[12];	/* Firmware name string                */
+	u8  fw_name[12 + 1];	/* Firmware name string                */
 	u32 fw_version;		/* Firmware version                   */
 	u16 pci_ids[4];		/* PCI identification                 */
 	u32 mf_id;		/* Manufacture ID                     */
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 8668888c5a2f..d5ed80731e89 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -775,6 +775,7 @@ static int ncsi_rsp_handler_gvi(struct ncsi_request *nr)
 	ncv->alpha1 = rsp->alpha1;
 	ncv->alpha2 = rsp->alpha2;
 	memcpy(ncv->fw_name, rsp->fw_name, 12);
+	ncv->fw_name[12] = '\0';
 	ncv->fw_version = ntohl(rsp->fw_version);
 	for (i = 0; i < ARRAY_SIZE(ncv->pci_ids); i++)
 		ncv->pci_ids[i] = ntohs(rsp->pci_ids[i]);
-- 
2.39.5



