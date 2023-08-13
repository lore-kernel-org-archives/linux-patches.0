Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0718D9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C04DC433C7;
	Sun, 13 Aug 2023 21:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962521;
	bh=3CXrZMmtM4Xp0zbcOlojaQ+TqZLurmB7IjBVu6NdyVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vl3y1hm2JxpwOQPUc/n9Su6ZqKjMtxNSj+oEdlcRqTF3kyd+cpmgXJkA0z3SnDQ1x
	 jZh8tYkE+iaYRQBEIa27j3sU/nKCrKSK8KsFyq5DroIi/eAoXBQ611ExK6Y26JnbXc
	 t1Hn5a3TZSqF065trY/9+bvsqX5YGMkYjvcK7MCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 030/149] drm/amdgpu: add S/G display parameter
Date: Sun, 13 Aug 2023 23:17:55 +0200
Message-ID: <20230813211719.707861445@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit bf0207e1727031798f300afa17f9bbeceac6da87 upstream.

Some users have reported flickerng with S/G display.  We've
tried extensively to reproduce and debug the issue on a wide
variety of platform configurations (DRAM bandwidth, etc.) and
a variety of monitors, but so far have not been able to.  We
disabled S/G display on a number of platforms to address this
but that leads to failure to pin framebuffers errors and
blank displays when there is memory pressure or no displays
at all on systems with limited carveout (e.g., Chromebooks).
Add a option to disable this as a debugging option as a
way for users to disable this, depending on their use case,
and for us to help debug this further.

v2: fix typo

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h               |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c           |   11 +++++++++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +++
 3 files changed, 15 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -242,6 +242,7 @@ extern int amdgpu_num_kcq;
 
 #define AMDGPU_VCNFW_LOG_SIZE (32 * 1024)
 extern int amdgpu_vcnfw_log;
+extern int amdgpu_sg_display;
 
 #define AMDGPU_VM_MAX_NUM_CTX			4096
 #define AMDGPU_SG_THRESHOLD			(256*1024*1024)
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -185,6 +185,7 @@ int amdgpu_num_kcq = -1;
 int amdgpu_smartshift_bias;
 int amdgpu_use_xgmi_p2p = 1;
 int amdgpu_vcnfw_log;
+int amdgpu_sg_display = -1; /* auto */
 
 static void amdgpu_drv_delayed_reset_work_handler(struct work_struct *work);
 
@@ -930,6 +931,16 @@ MODULE_PARM_DESC(vcnfw_log, "Enable vcnf
 module_param_named(vcnfw_log, amdgpu_vcnfw_log, int, 0444);
 
 /**
+ * DOC: sg_display (int)
+ * Disable S/G (scatter/gather) display (i.e., display from system memory).
+ * This option is only relevant on APUs.  Set this option to 0 to disable
+ * S/G display if you experience flickering or other issues under memory
+ * pressure and report the issue.
+ */
+MODULE_PARM_DESC(sg_display, "S/G Display (-1 = auto (default), 0 = disable)");
+module_param_named(sg_display, amdgpu_sg_display, int, 0444);
+
+/**
  * DOC: smu_pptable_id (int)
  * Used to override pptable id. id = 0 use VBIOS pptable.
  * id > 0 use the soft pptable with specicfied id.
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1634,6 +1634,9 @@ static int amdgpu_dm_init(struct amdgpu_
 		}
 		break;
 	}
+	if (init_data.flags.gpu_vm_support &&
+	    (amdgpu_sg_display == 0))
+		init_data.flags.gpu_vm_support = false;
 
 	if (init_data.flags.gpu_vm_support)
 		adev->mode_info.gpu_vm_support = true;


