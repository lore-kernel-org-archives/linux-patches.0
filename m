Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E021484896;
	Thu, 17 Sep 2026 15:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660189; cv=none; b=C85VRtAhoPI0b3XQR/0xdHhB/iys46YQyimRGXN9oGXam9P3W4ex2V0ZMzLmTKns6xzLh9dbX3E0bbfvmV85OcB5XtOHzLP8BvuskmqnFNtozqZIEkJuIbPxESYUROaIpcqnLc7MfK0uwk4Ixr76z4OtqTe4Smenkx8vDOv40V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660189; c=relaxed/simple;
	bh=O3LDVX+4BqFRdIOe6YQQ1o4I9dViD67WteN48LbqGqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shHo7QaAbZSn2ZfOaiIBuvWpqq9q1uqbC51hLLT/DYblN9VrtzSW9FoWRA5FQQ47P+37G8r4nzt1A9G9/BUkCITQ2G+lA7SGf04FF8J69qZWXeR19MDNCr3AWliDBThy4AdnPdyXBJVBP3CZKMahGDzSg1BVMTaeSgGmDPJOEb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJJS1Ah6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJJS1Ah6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12931F00893;
	Thu, 17 Sep 2026 15:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660182;
	bh=d+CAQrBf5QmYt2+Axm6BrZyvqoMJwyAIMFmx3Pldc3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJJS1Ah6qfP1zf86t+SNEBcLBnEkoRUHuLCGd3T69clY0jll8LoQlG5MYbn4Xa7WE
	 TfjU+oX7uxn/Fwxa+nXpsN9luhRU8ghxtErvjFCvxOeB6Tgr1JfAQEqhjAjN9FIN7F
	 TMt05v/EwOAni81Fcn9yyN0Q74eE5M3LDrOuXLSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.2 507/733] accel: ethosu: Fix ethosu_job_open() return value
Date: Thu, 17 Sep 2026 16:13:35 +0100
Message-ID: <20260917151404.749748993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

commit b3c8d4672f7a8735e2884cefcd89286268e88b2e upstream.

A WARN_ON() returns a 0 or 1, not the original negative errno. Just drop
the WARN_ON() as the FD open will pass the return code to userspace and
there's only one possible source of the error (drm_sched_entity_init()).

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260827-ethosu-fixes-v1-1-346f9ea8791c@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_job.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/accel/ethosu/ethosu_job.c
+++ b/drivers/accel/ethosu/ethosu_job.c
@@ -356,12 +356,10 @@ int ethosu_job_open(struct ethosu_file_p
 {
 	struct ethosu_device *dev = ethosu_priv->edev;
 	struct drm_gpu_scheduler *sched = &dev->sched;
-	int ret;
 
-	ret = drm_sched_entity_init(&ethosu_priv->sched_entity,
-				    DRM_SCHED_PRIORITY_NORMAL,
-				    &sched, 1, NULL);
-	return WARN_ON(ret);
+	return drm_sched_entity_init(&ethosu_priv->sched_entity,
+				     DRM_SCHED_PRIORITY_NORMAL,
+				     &sched, 1, NULL);
 }
 
 void ethosu_job_close(struct ethosu_file_priv *ethosu_priv)


