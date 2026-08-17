Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AD743BDB1;
	Mon, 17 Aug 2026 13:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974128; cv=none; b=Lkllw6aFwVjgJ//8TdWjq5NFEbeuvJ/t8b9+tNKfjMsJLAgsABLMNnUay0oblYbWuMk+9t8INLhZYkRkYq+5wInQsZCSQydtvkoHdmwaSzw5Y2geCLtUIJYO7wMkdi2Jd2yqrvye8mwp3+JqR4CI8aBkno5w9DyD5xP0znc1ARw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974128; c=relaxed/simple;
	bh=ABXlD4FSbPY6g8WBcqs1lI8V5aJ2MZxp73f67gIyiv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4swRoY5gtB0B3VuAbmh3toUBSZxBM8Cz2CvKObsLUBcsZIVRgzNR8qzCObGbqCyhAqqrjKlQ+u4E8zHE7Uf9rlUcbiot++2k5sp765G+3M1gZq++N5esZ5EhRkGzwVPV6hUusOMlRKzglNnxuQd86MCwKwZ7n3PtalkGD7s5NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+yapaS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+yapaS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C6C1F00A3D;
	Mon, 17 Aug 2026 13:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974126;
	bh=mwto5VBEJHieUXYxfAq7cEHLpKWOHbOFOqzGUWEwrDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+yapaS4jvTzksWiHy7SBpFoE+7hkL8OakcOs6CYHh0SkKKXtr4Wi4S2Nt0A5wy7C
	 wea1ciIIQrpBcbcxhMXfmcWSt+r8Iyei0v8hfgVNpYS7oKFRSUoRFWeXN6gqeFmg4n
	 tsHBAsTuPekNbI+F2HZxckf+jHh0dOtYO3cGzzDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 081/271] vhost-scsi: Validate T10 PI scatterlist counts
Date: Mon, 17 Aug 2026 15:30:06 +0200
Message-ID: <20260817132540.072452994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9a1253b9d8c50..c79197edb1637 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -972,6 +972,9 @@ vhost_scsi_mapal(struct vhost_scsi *vs, struct vhost_scsi_cmd *cmd,
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



