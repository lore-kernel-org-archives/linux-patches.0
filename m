Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5736D285CAE;
	Sun,  7 Jun 2026 10:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826651; cv=none; b=O6dJVjJmjn7dAtUgczsv8MRkDTfFyV+bzD3ewJz1gs/kUKRhLSaUA0ONbnBwmFSmF4JF4zggT8mbA/w96vZSG5maHQRq9aWBznJopSe+ytZBI/HWHM2zQwc4N7DXyrMWqbvGZvEwIPpzdeT024PW9ptacDHvyzDSpq0HnVSSsfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826651; c=relaxed/simple;
	bh=/Ui56z4ldBb/5jxWLup9zMA2loOPArahthhCWO25Wxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmLDqgnhJAlFJobKDIRxkggroTQyGDVF4ctG++IprV4j9UnxsjQ3T3daLTaOK/TFmtkCVt9c/K96Ds6EwjRC3LavuJ7RLLGyM6kXURxfGhxpJpg40Nm2of5hQKlINLv8Vfmm5fOZj/KEFKpmx+9Vj6K6Ft9FSoJXpS3r68Kfy+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/mdwQ08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/mdwQ08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611A11F00893;
	Sun,  7 Jun 2026 10:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826650;
	bh=KI1TjeSyhxczjXyousXxNytQHa67IGpI7yZTvBJ+dY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/mdwQ08sgevSsPZwb1Z1coZudZvfGsRaIHQYVzAnF9j4A9pQ63at39HNFfK8Qoun
	 fP24OSTOEXwpRNy1qRCBuQYfzxJDcOmyto3t3ZBI/aVa4FLILwgSRsug0ZSuRDToVP
	 +OVqmaGKooniSIl3CqxScKi7iJ++Q1wW/QDD7IW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/307] drm/v3d: Release indirect CSD GEM reference on CPU job free
Date: Sun,  7 Jun 2026 11:56:40 +0200
Message-ID: <20260607095727.770204981@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 6eb6e5acafa46854d4363e6c34981289995f3ace ]

v3d_get_cpu_indirect_csd_params() takes a reference to the indirect BO via
drm_gem_object_lookup() and stashes it in cpu_job->indirect_csd.indirect,
but nothing on the CPU job teardown path ever drops that reference.

Drop the extra reference in v3d_cpu_job_free(). The NULL check covers ioctl
errors before the lookup ran and CPU job types other than
V3D_CPU_JOB_TYPE_INDIRECT_CSD, which leave the field zero-initialised.

Cc: stable@vger.kernel.org
Fixes: 18b8413b25b7 ("drm/v3d: Create a CPU job extension for a indirect CSD job")
Assisted-by: Claude:claude-opus-4.7
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260515-v3d-cpu-job-leaks-v1-2-7f147cbbf935@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_submit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/v3d/v3d_submit.c b/drivers/gpu/drm/v3d/v3d_submit.c
index 40c21aaade0d67..23472c7af41a96 100644
--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -130,6 +130,9 @@ v3d_cpu_job_free(struct kref *ref)
 	v3d_performance_query_info_free(&job->performance_query,
 					job->performance_query.count);
 
+	if (job->indirect_csd.indirect)
+		drm_gem_object_put(job->indirect_csd.indirect);
+
 	v3d_job_free(ref);
 }
 
-- 
2.53.0



