Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9931830DEBB;
	Tue,  2 Sep 2025 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819800; cv=none; b=I+hLJGnanVzQimHDY1I4aKvqckqG7crCBgSdw9wn4HA2EkcxlGVmcdjA0W5hCbQweL/LQqIXpU7lDd2jogdNy0dfJn7Fl6RdhLwvoY+/mU6kxZ2bMk7ODEjF2sQrvsxxdpauyQsmdqEl/CNbD3XRSLrIJzA+BX1WtnXvUYTBsX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819800; c=relaxed/simple;
	bh=7wetER8GfehqJ/NSnNKMF1xUGwVEudZJK6NmhfoJ3es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gH0Chn61kE2aTuQAoUwDLNh5HLIkEKTzHvNxTVu65ZDax7QKuVPDlk/mcS/IKGLy57zuHPgRghiRk7Hu8du5nURK0Csv1PJ1ZriJBpyYrZ37xjIt7gFiThJPyc0JISiLkwUJNyw/2A9iKgt5yBBX5lJaRq4yL8D/PsPgxUlrtqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxZYEnSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxZYEnSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22875C4CEF5;
	Tue,  2 Sep 2025 13:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819800;
	bh=7wetER8GfehqJ/NSnNKMF1xUGwVEudZJK6NmhfoJ3es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxZYEnSplPspdzFR3I3ZvnOPcSb+tFIkhwd5UCx5n05GpmBmIb6REI4jxQJTxQ3CO
	 oTScpOKG5nuaT3aFxY02JU6sVCLOZJpHQOkB8KJW/I51o+VUthiTPPsOsy3XnNfI9F
	 a90GYXkUw3FzWCYA03j7q5H2DjdBumqdsTO1P2Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 132/142] drm/amdgpu/gfx11: set MQD as appriopriate for queue types
Date: Tue,  2 Sep 2025 15:20:34 +0200
Message-ID: <20250902131953.340270366@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 27f5e0c1321ee280189cea16044de2e157dc4bb9 upstream.

Set the MQD as appropriate for the kernel vs user queues.

Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 063d6683208722b1875f888a45084e3d112701ac)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4124,6 +4124,8 @@ static int gfx_v11_0_gfx_mqd_init(struct
 #endif
 	if (prop->tmz_queue)
 		tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, TMZ_MATCH, 1);
+	if (!prop->kernel_queue)
+		tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_NON_PRIV, 1);
 	mqd->cp_gfx_hqd_cntl = tmp;
 
 	/* set up cp_doorbell_control */
@@ -4276,8 +4278,10 @@ static int gfx_v11_0_compute_mqd_init(st
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, UNORD_DISPATCH, 1);
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, TUNNEL_DISPATCH,
 			    prop->allow_tunneling);
-	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, PRIV_STATE, 1);
-	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, KMD_QUEUE, 1);
+	if (prop->kernel_queue) {
+		tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, PRIV_STATE, 1);
+		tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, KMD_QUEUE, 1);
+	}
 	if (prop->tmz_queue)
 		tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, TMZ, 1);
 	mqd->cp_hqd_pq_control = tmp;


