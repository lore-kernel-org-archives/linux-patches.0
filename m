Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8703319F43A;
	Thu,  3 Jul 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556247; cv=none; b=aQAvqHK5Z1tlN7RAw8hUMAhFc9lf686+RzVlZQQvINObtsMKDVt/LxCu0/ynMIXnftvDvNf4ZSpS/Cv0qwhynsno6Z8RFl1hPiJ4QVsI32TlIn1/T6dnAhZ2qM8icPAA7B+NueY5bqjzdOV6oKbxrairXVkDd8Q3cmV4w6LV77I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556247; c=relaxed/simple;
	bh=k0MUjCPv3KegxtcXbHkE/zQtFTwv/Tnrbk57rKOE0MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nu5nKAKPmu/zYJFcwaPG4MLr7bALoBhdodftW1oW5XpZb08qckcS26ijX4AVDequJuT+vyNw+k7kCVYNEXptaZ47bCo+5odZT+QJzF5y6ya4gC6nSY/eRQiFlqWN4dS/NH0dMNr1QbLbD1b2Up5AZmNM9rEUO4CL+eN7ZkIAlk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kK6jmGLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kK6jmGLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB9BC4CEEE;
	Thu,  3 Jul 2025 15:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556247;
	bh=k0MUjCPv3KegxtcXbHkE/zQtFTwv/Tnrbk57rKOE0MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kK6jmGLaGnVRs5EOFDp3PBguMravKbH6ejyZHIPOwGiHUX8nqBqJ/n9iZ3cT3WKuP
	 Cv5GiMmS50XA3wT6HdBzh+7YkbVhIsnIa8I1n7an521/IoeXplR6aLV8IdGpmT3Uyg
	 zwaNmLcGKo0mVeM5Kx69GqubvbHrrI9TzuZCpC80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 120/132] eth: bnxt: fix one of the W=1 warnings about fortified memcpy()
Date: Thu,  3 Jul 2025 16:43:29 +0200
Message-ID: <20250703143944.098143733@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit 833c4a8105ac8c2df42ec061be09a5a682454f69 upstream.

Fix a W=1 warning with gcc 13.1:

In function ‘fortify_memcpy_chk’,
    inlined from ‘bnxt_hwrm_queue_cos2bw_cfg’ at drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c:133:3:
include/linux/fortify-string.h:592:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
  592 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The field group is already defined and starts at queue_id:

struct bnxt_cos2bw_cfg {
	u8			pad[3];
	struct_group_attr(cfg, __packed,
		u8		queue_id;
		__le32		min_bw;

Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20230727190726.1859515-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -130,7 +130,7 @@ static int bnxt_hwrm_queue_cos2bw_cfg(st
 					    BW_VALUE_UNIT_PERCENT1_100);
 		}
 		data = &req->unused_0 + qidx * (sizeof(cos2bw) - 4);
-		memcpy(data, &cos2bw.queue_id, sizeof(cos2bw) - 4);
+		memcpy(data, &cos2bw.cfg, sizeof(cos2bw) - 4);
 		if (qidx == 0) {
 			req->queue_id0 = cos2bw.queue_id;
 			req->unused_0 = 0;


