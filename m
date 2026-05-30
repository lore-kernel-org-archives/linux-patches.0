Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A51D32D42B;
	Sat, 30 May 2026 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160797; cv=none; b=cuy54D4MUUAtviLZUvlNLhHGNm+uCxR1OmJAiK3Sp9RBHdJE2JKOX4q4xEKc4G3+3beACpnHRmAxPSTFW8EM1Js+8PiGfGu9HG+THhjR+c29pW3h5G91LVqKnCdUtghXab5as5WVgE7uqZhC3mo6rrp/vxZbUIsrj1N4vjRRJOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160797; c=relaxed/simple;
	bh=tVuKWpCKJLEmFz9h4d81/G8Kg21//jsnGKsTBzH3pvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESTatzbKKkEbzmewdRP544+dP/tAiFe1s2JADtmpFlJoz27eI14/eWYHsDJeSEs80tqqsF2TScUOXcGlo/hdIfHelLBhec4Xz0Y7hbQe1ILgQFxW1i3bgYuSjUPsWIl+NUzJ635zSR3HSkF/ZLXEkdJQnt4dN6Z7CJ8hW16/7mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZHPTN0Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZHPTN0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FC11F00893;
	Sat, 30 May 2026 17:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160796;
	bh=Qu2jXj8Aic6kawJT9F4pKSP/LN6AWTPntgDfbl7khqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZHPTN0ZEK25F3iVCyEbHVpdQuxiUe8Y+7EZkug4z0uOaieSyWQZqjnJ5ceYo8Erh
	 /lDjf+B+x2Lga/26Z8HkPUFk5eoAVkqfuQ+yz2CtgMsYDiEIAiVYbE2pMBvAleOccw
	 gGr/3mxEyB8Axc1jOJBEPnUjfTcI+cVVnOt354j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Shetaia <Amir.Shetaia@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 408/969] drm/amdkfd: validate SVM ioctl nattr against buffer size
Date: Sat, 30 May 2026 17:58:52 +0200
Message-ID: <20260530160311.547892427@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alysa Liu <Alysa.Liu@amd.com>

commit 045e0ff208f0838a246c10204105126611b267a1 upstream.

Validate nattr field against the buffer size, preventing
out-of-bounds buffer access via user-controlled attribute count.

Reviewed-by: Amir Shetaia <Amir.Shetaia@amd.com>
Signed-off-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5eca8bfdfa456c3304ca77523718fe24254c172f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |   26 ++++++++++++++++++++++++--
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h    |    3 +++
 2 files changed, 27 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -26,6 +26,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/overflow.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -1614,6 +1615,16 @@ static int kfd_ioctl_smi_events(struct f
 	return kfd_smi_event_open(pdd->dev, &args->anon_fd);
 }
 
+static int kfd_ioctl_svm_validate(void *kdata, unsigned int usize)
+{
+	struct kfd_ioctl_svm_args *args = kdata;
+	size_t expected = struct_size(args, attrs, args->nattr);
+
+	if (expected == SIZE_MAX || usize < expected)
+		return -EINVAL;
+	return 0;
+}
+
 #if IS_ENABLED(CONFIG_HSA_AMD_SVM)
 
 static int kfd_ioctl_set_xnack_mode(struct file *filep,
@@ -2672,7 +2683,11 @@ static int kfd_ioctl_criu(struct file *f
 
 #define AMDKFD_IOCTL_DEF(ioctl, _func, _flags) \
 	[_IOC_NR(ioctl)] = {.cmd = ioctl, .func = _func, .flags = _flags, \
-			    .cmd_drv = 0, .name = #ioctl}
+			    .validate = NULL, .cmd_drv = 0, .name = #ioctl}
+
+#define AMDKFD_IOCTL_DEF_V(ioctl, _func, _validate, _flags) \
+	[_IOC_NR(ioctl)] = {.cmd = ioctl, .func = _func, .flags = _flags, \
+			    .validate = _validate, .cmd_drv = 0, .name = #ioctl}
 
 /** Ioctl table */
 static const struct amdkfd_ioctl_desc amdkfd_ioctls[] = {
@@ -2769,7 +2784,8 @@ static const struct amdkfd_ioctl_desc am
 	AMDKFD_IOCTL_DEF(AMDKFD_IOC_SMI_EVENTS,
 			kfd_ioctl_smi_events, 0),
 
-	AMDKFD_IOCTL_DEF(AMDKFD_IOC_SVM, kfd_ioctl_svm, 0),
+	AMDKFD_IOCTL_DEF_V(AMDKFD_IOC_SVM, kfd_ioctl_svm,
+			   kfd_ioctl_svm_validate, 0),
 
 	AMDKFD_IOCTL_DEF(AMDKFD_IOC_SET_XNACK_MODE,
 			kfd_ioctl_set_xnack_mode, 0),
@@ -2882,6 +2898,12 @@ static long kfd_ioctl(struct file *filep
 		memset(kdata, 0, usize);
 	}
 
+	if (ioctl->validate) {
+		retcode = ioctl->validate(kdata, usize);
+		if (retcode)
+			goto err_i1;
+	}
+
 	retcode = func(filep, process, kdata);
 
 	if (cmd & IOC_OUT)
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -924,10 +924,13 @@ extern struct srcu_struct kfd_processes_
 typedef int amdkfd_ioctl_t(struct file *filep, struct kfd_process *p,
 				void *data);
 
+typedef int amdkfd_ioctl_validate_t(void *kdata, unsigned int usize);
+
 struct amdkfd_ioctl_desc {
 	unsigned int cmd;
 	int flags;
 	amdkfd_ioctl_t *func;
+	amdkfd_ioctl_validate_t *validate;
 	unsigned int cmd_drv;
 	const char *name;
 };


