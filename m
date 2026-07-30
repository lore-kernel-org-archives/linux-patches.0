Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9275643E9DF;
	Thu, 30 Jul 2026 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424253; cv=none; b=Cz1yJTUUt7L0gt2YvC1wjFRyBtIR4kvxeFj5rZKr4+u7lXpvMCZ8QLLLRWq4DzgqWrhopf+AqDY26dwdImNWcEDrFTuGLn/TgQsTBDZ9xQHI67oFz3MXSFw7IA1kHjOuxOO+i16XD3+VUZQrScoBDt+ycAwurSJbg1yths8acwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424253; c=relaxed/simple;
	bh=Rk1ZRlqQ2nkcCVptDp4TQq3lfuECKvTYrW4J9OuG30k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EitpQPVvAP81pdSigrI9A+gdOO2Fvuq2VoXDFCMQMfPws1zy2Pt3InxyiKRTrdj6449xK/72u33zB1gqMsMS+39Dbcnm8OrzxbEHItZ1fIfB/4DMnNjna+vTe8kR2Fmlr1eZ/oLJpBGdcnDMKQDCYj8T8snMJqY7qsxLXM9HbOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldDiMDlQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldDiMDlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D751F00A3A;
	Thu, 30 Jul 2026 15:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424247;
	bh=7PJS9Yi+2QZXgtkJ1cSMnb6Bgvepe2nrouExPWp5qLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldDiMDlQnXd+1pVviZSM+B5+hzgnlz3pwubzNn9TR3f85wNuKboysVV/DLNcKqbPR
	 ARxYrY25DU0pcnIInM8ML1VSMyNWfHlahKuuURWSXXavV/3cWead/n4KzFB08FuN8w
	 09a8urzlMS1eh3k84GAEi6VVtRiRIRO8p8av4KEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 328/675] drm/dp/mst: fix OOB reads on 2-byte fields in sideband reply parsers
Date: Thu, 30 Jul 2026 16:10:58 +0200
Message-ID: <20260730141452.098475683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

commit 6b89ba3dba2f583626fb693e47e951ffb8bf591f upstream.

Three sideband reply parsers read 16-bit fields as:

  val = (raw->msg[idx] << 8) | (raw->msg[idx+1]);

and check bounds only after the fact. When idx == raw->curlen,
raw->msg[idx+1] reads one byte past the received message data into
the following struct fields (curchunk_len, curchunk_idx, curlen).

Affected functions:
 - drm_dp_sideband_parse_enum_path_resources_ack()
   full_payload_bw_number and avail_payload_bw_number fields
 - drm_dp_sideband_parse_allocate_payload_ack()
   allocated_pbn field
 - drm_dp_sideband_parse_query_payload_ack()
   allocated_pbn field

Fix by using a single combined check (idx + 2 > curlen) before each
2-byte read. Since the check is strictly tighter than idx > curlen,
no separate step is needed.

Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Ashutosh Desai <ashutoshdesai993@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
[added fixes tag]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260510203128.2884846-1-ashutoshdesai993@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -934,16 +934,13 @@ static bool drm_dp_sideband_parse_enum_p
 	repmsg->u.path_resources.port_number = (raw->msg[idx] >> 4) & 0xf;
 	repmsg->u.path_resources.fec_capable = raw->msg[idx] & 0x1;
 	idx++;
-	if (idx > raw->curlen)
+	if (idx + 2 > raw->curlen)
 		goto fail_len;
 	repmsg->u.path_resources.full_payload_bw_number = (raw->msg[idx] << 8) | (raw->msg[idx+1]);
 	idx += 2;
-	if (idx > raw->curlen)
+	if (idx + 2 > raw->curlen)
 		goto fail_len;
 	repmsg->u.path_resources.avail_payload_bw_number = (raw->msg[idx] << 8) | (raw->msg[idx+1]);
-	idx += 2;
-	if (idx > raw->curlen)
-		goto fail_len;
 	return true;
 fail_len:
 	DRM_DEBUG_KMS("enum resource parse length fail %d %d\n", idx, raw->curlen);
@@ -961,12 +958,9 @@ static bool drm_dp_sideband_parse_alloca
 		goto fail_len;
 	repmsg->u.allocate_payload.vcpi = raw->msg[idx];
 	idx++;
-	if (idx > raw->curlen)
+	if (idx + 2 > raw->curlen)
 		goto fail_len;
 	repmsg->u.allocate_payload.allocated_pbn = (raw->msg[idx] << 8) | (raw->msg[idx+1]);
-	idx += 2;
-	if (idx > raw->curlen)
-		goto fail_len;
 	return true;
 fail_len:
 	DRM_DEBUG_KMS("allocate payload parse length fail %d %d\n", idx, raw->curlen);
@@ -980,12 +974,9 @@ static bool drm_dp_sideband_parse_query_
 
 	repmsg->u.query_payload.port_number = (raw->msg[idx] >> 4) & 0xf;
 	idx++;
-	if (idx > raw->curlen)
+	if (idx + 2 > raw->curlen)
 		goto fail_len;
 	repmsg->u.query_payload.allocated_pbn = (raw->msg[idx] << 8) | (raw->msg[idx + 1]);
-	idx += 2;
-	if (idx > raw->curlen)
-		goto fail_len;
 	return true;
 fail_len:
 	DRM_DEBUG_KMS("query payload parse length fail %d %d\n", idx, raw->curlen);


