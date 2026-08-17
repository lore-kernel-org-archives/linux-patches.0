Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775EB43BDCD;
	Mon, 17 Aug 2026 13:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974954; cv=none; b=IKsdU22jejB8tgOdrttxvKcDBWINaK40xrb06SYwvbgpNOXyqSse6Xz9Vh4+RRX2b0KMswMavRDEl33PZP2dHniYHcA8R/p+5AfvjrM8icgTiIs1kQzlO8Owd+NXUpiMGRjkjgAWjcaoq4iQVhGA5dnL5GvDalgid7glw3+t8/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974954; c=relaxed/simple;
	bh=vWaALERu7Dx4tgzlVxv4MjCBuwaDrxgMHfN8OjcgYIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0ZBsw6y3BqBfuxqH76eUh81VkAXZdG3OaFVq/nPsobNuY3e3MDmpGe7bqMhdsip0Yija47rTZkX8zYWWBbDBXkiHgFo0OItDUrQdb6ReEACHlpvio58bqeqUUXw/knA8ClpeDMAxvl2mcPLKI2X1oc0la6FO/CFbSxqDbLiqEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz7ynt7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz7ynt7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B1B1F00ACA;
	Mon, 17 Aug 2026 13:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974949;
	bh=hnzgcdXUhlBuQ0ViJ7ZeW0ojYj32/LTr7tv3dnJcg3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vz7ynt7mz5ZgeR3XNK7fkQ4qUdcqyL89m4EygBvjBFnQ+eyv9VWDmwFhD3cX/v0mU
	 KBtOHKzjsl26SZJ/hAHHl+Tpv1ZCo0IU5e7YkTws7anwJV9lwf1wejUfrs9TbtNjyW
	 2VO7j3UorwH3WEU7bahD2vxi/mQ2yU1NTUXUgJSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/250] vhost-scsi: Validate T10 PI scatterlist counts
Date: Mon, 17 Aug 2026 15:30:34 +0200
Message-ID: <20260817132539.426985054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Linfeng Sun <slf@hdu.edu.cn>

[ Upstream commit d876c493fc4b811941bfeb4c80beb2dfc4bf025e ]

When T10 PI is negotiated, vhost-scsi splits protection bytes from
the data iterator before mapping the request scatterlists. A malformed
request can claim protection bytes that cover or exceed the full payload
length. The former leaves no data bytes to map, while the latter
underflows exp_data_len before advancing the iterator. Both cases can let
a zero data SGL count reach sg_alloc_table_chained(), which triggers
BUG_ON(!nents).

Reject protection lengths that cover or exceed the payload before
subtracting prot_bytes and advancing the iterator. Also propagate
negative errors from the protection SGL calculation before calling the
allocator, matching the data SGL path.

Fixes: bca939d5bcd0 ("vhost-scsi: Dynamically allocate scatterlists")
Suggested-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Assisted-by: OpenAI-Codex:GPT-5
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Message-ID: <20260727081841.923151-1-slf@hdu.edu.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 98e4f68f4e3cb..65a57de0080ef 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -971,6 +971,9 @@ vhost_scsi_mapal(struct vhost_scsi *vs, struct vhost_scsi_cmd *cmd,
 	if (prot_bytes) {
 		sgl_count = vhost_scsi_calc_sgls(prot_iter, prot_bytes,
 						 VHOST_SCSI_PREALLOC_PROT_SGLS);
+		if (sgl_count < 0)
+			return sgl_count;
+
 		cmd->prot_table.sgl = cmd->prot_sgl;
 		ret = sg_alloc_table_chained(&cmd->prot_table, sgl_count,
 					     cmd->prot_table.sgl,
@@ -1416,6 +1419,11 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			 * actual data payload length.
 			 */
 			if (prot_bytes) {
+				if (prot_bytes >= exp_data_len) {
+					vq_err(vq, "Protection data exceeds payload length\n");
+					goto err;
+				}
+
 				exp_data_len -= prot_bytes;
 				prot_iter = data_iter;
 				iov_iter_truncate(&prot_iter, prot_bytes);
-- 
2.53.0



