Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0044398FA;
	Thu, 30 Jul 2026 14:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423334; cv=none; b=sKIk8dYV+GrPyJ1N5zKkKY4p46+zvcQuyk/YPpHsD1sZQ49EtM8RWT0KiTr+kbsCuuG5jTv4ttQ0uY4fyE1pnKrKb1B09ebT+mgfmsVBYDxWT7719SJlWqnrs5KRP5dbDmCAhz0N8w/0tAlPovWPlsS2bV5Wm6q9z9weAl4y4D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423334; c=relaxed/simple;
	bh=EPwwDXvasaZEdF+4s2qC8q+ED+xH6YIWG9zqQkTYads=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wpl3ERhTcy2Kd6HgqozZGLban7xgCJqMJLnnjWks8FwJxku1q5IVAxScYxxK49nx4MGCjFJhHWNUjBVC9toFaW0Q3Ku9CEoGxcGdlB1kPAcjdtE3beJa+XtzZsbAIL78XMOYC5Ga4z3ImmiNG3mdZ9jwPgVXdCxiwoNBZUzQ/zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zoEJVjZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zoEJVjZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EDB1F000E9;
	Thu, 30 Jul 2026 14:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423333;
	bh=orJCMSvC+/ygJBEwgp3uN0tF5AnwUr7cactl585nNDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zoEJVjZwTbJyvHZiBO5CCQAYEXzbaHYY1GqxWU/+DVZhH80DO2uT4Ap827UdnTEk0
	 ER77gEuZ8brEl3HcLJbelPhAmyYRSm1rsdbqDUWeFcoykVP1FiOWoE7T/6U8g7Vr5i
	 oH4/l4PVEf/oGT0as4AOW1bb8TDW23b9D4R2du0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 694/744] drm/amd/pm: make pp_features read-only when scpm is enabled
Date: Thu, 30 Jul 2026 16:16:07 +0200
Message-ID: <20260730141459.020300914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

commit 53c78ab388bfc1a4d72e756815d0db0a842c812e upstream.

SCPM owns power feature control when enabled.

Make pp_features read-only during sysfs setup by clearing its write bits
and store callback.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6a5786e191fdce36c5db170e5209cf609e8f0087)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2682,6 +2682,11 @@ static int default_attr_update(struct am
 		     gc_ver != IP_VERSION(9, 4, 3)) ||
 		    gc_ver < IP_VERSION(9, 0, 0))
 			*states = ATTR_STATE_UNSUPPORTED;
+
+		if (adev->scpm_enabled) {
+			dev_attr->attr.mode &= ~S_IWUGO;
+			dev_attr->store = NULL;
+		}
 	} else if (DEVICE_ATTR_IS(gpu_metrics)) {
 		if (gc_ver < IP_VERSION(9, 1, 0))
 			*states = ATTR_STATE_UNSUPPORTED;


