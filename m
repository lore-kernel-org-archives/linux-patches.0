Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F5917A2FE;
	Wed, 19 Feb 2025 09:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957029; cv=none; b=u5ALVbX9CnITeoFjytiK6rnqwKWGxUFRXIbNfeuMvjwFZFtum5n2OYIjXQJQea++wMFjW5uwrh0n2mDStkn+m+Grqj6a6jD32st8oG25TpMcM1LHuueS0qBSRRahNr7aprFtRsvVyxRguqO00S5CpZzjZMGLYscfxYD8pnBuOOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957029; c=relaxed/simple;
	bh=TR8KfIsNXfQTdT0NUE5G+J4X1IVnD7wBx1f5RKm3c0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXp2IP0KL8Tnz5mv/4H2O27lRXMogavUUXLGME2NuLxkcAX93l7grW1/6ruDtemQ6y1VYas6W7i4/U9QJqBBhul4dxmMJHlDUETWSiA7slVWDIDkKEk+IzaeuevJn6UJ7NY5XRWOy8Ob6sqJkVHJE2riRjo+1J+LOnJdPeFNNCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ix+EeWsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ix+EeWsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668F0C4CED1;
	Wed, 19 Feb 2025 09:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957028;
	bh=TR8KfIsNXfQTdT0NUE5G+J4X1IVnD7wBx1f5RKm3c0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ix+EeWsnifKHj1xv0dQcJXxEkMKrsqTpernsRbIQYCOOL0Uhjqy+28RCJwMNo8IX9
	 KVR+6sWyGO836e8PL1kzpIr3+o+hd/xCRJeQfL8i0+3NkiHVZTpEkenIehBJc3DU/G
	 EmYxdL2yQ9USqQab1gqb9eigSnW51GlLeOKHUNBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.1 352/578] drm/komeda: Add check for komeda_get_layer_fourcc_list()
Date: Wed, 19 Feb 2025 09:25:56 +0100
Message-ID: <20250219082706.869520946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 79fc672a092d93a7eac24fe20a571d4efd8fa5a4 upstream.

Add check for the return value of komeda_get_layer_fourcc_list()
to catch the potential exception.

Fixes: 5d51f6c0da1b ("drm/komeda: Add writeback support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/r/20241219090256.146424-1-haoxiang_li2024@163.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
@@ -160,6 +160,10 @@ static int komeda_wb_connector_add(struc
 	formats = komeda_get_layer_fourcc_list(&mdev->fmt_tbl,
 					       kwb_conn->wb_layer->layer_type,
 					       &n_formats);
+	if (!formats) {
+		kfree(kwb_conn);
+		return -ENOMEM;
+	}
 
 	err = drm_writeback_connector_init(&kms->base, wb_conn,
 					   &komeda_wb_connector_funcs,


