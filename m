Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C7722F0B;
	Thu, 18 Jan 2024 10:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575207; cv=none; b=YjW21xu4Dg9kGBTORIFOCTrm3RwT6Atmi9gboVsxeHIRNtFTPMbX4Wr19O2dGK5/Y3rjSfRNXBbi+c6oMkx/LLUnXiUIgy2M/Yl5WuTGdAwR1rNsr5P9qAh85F7B1IhMKHGTBxihzy6V080NZpxZplER9lUNy8e135Kkokvkq/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575207; c=relaxed/simple;
	bh=0zwAZ1sqscdePjJFnL1BhVzpukguGRzR2+PCbaYYtSA=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=EAAGZ8Of2z78aGHVi8HYLnbaKW+qWRcJSa1TaVA1uidWyilK4bY0LgbwwGd/kkg3m2/tA98DrORvI1D/SQs3TjddHoZwOqhO1dek2jiiVhzdy4t5qRIYOPw9lGqTvhEnZ9HZrXQTW9xkc5mgr6nZMFvqKU7vQl61lWDNunRJb9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzI2WZH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzI2WZH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B4AC433C7;
	Thu, 18 Jan 2024 10:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575207;
	bh=0zwAZ1sqscdePjJFnL1BhVzpukguGRzR2+PCbaYYtSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzI2WZH63Dns1Id+tm0yFIhE3AVFKFZhTTGhgU4+0hLgGJ5r/TfS/0jcgGeDzBJFT
	 jaeHpHX+ERNerCk2AYdVqPfn+98ALV0oVKVLr5LQNnJ9bduyX2OgBCqHZscs/c8jNa
	 n0gLQRpF9H3DsqEftDuv3bUsfii42X7OjA0qmKwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/150] pds_vdpa: clear config callback when status goes to 0
Date: Thu, 18 Jan 2024 11:47:51 +0100
Message-ID: <20240118104322.286626640@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit dd3b8de16e90c5594eddd29aeeb99e97c6f863be ]

If the client driver is setting status to 0, something is
getting shutdown and possibly removed.  Make sure we clear
the config_cb so that it doesn't end up crashing when
trying to call a bogus callback.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Message-Id: <20231110221802.46841-3-shannon.nelson@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/pds/vdpa_dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 52b2449182ad..9fc89c82d1f0 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -461,8 +461,10 @@ static void pds_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
 
 	pds_vdpa_cmd_set_status(pdsv, status);
 
-	/* Note: still working with FW on the need for this reset cmd */
 	if (status == 0) {
+		struct vdpa_callback null_cb = { };
+
+		pds_vdpa_set_config_cb(vdpa_dev, &null_cb);
 		pds_vdpa_cmd_reset(pdsv);
 
 		for (i = 0; i < pdsv->num_vqs; i++) {
-- 
2.43.0



