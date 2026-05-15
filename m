Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125D317C220;
	Fri, 15 May 2026 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862225; cv=none; b=ciLAlX5BPuITV6Ke9Kkyxkze4al+tjbPuAMPILNxoB2WCE1pDCnr0xb4pdaB0d7cYAJQkYSgUgYlq3rN/dr9/hNhs9SMXPCRKKU6cbqz/iE5Kl4+PuVNtbixswes9mYIWiiX29ee9bap5IbcurRaXpX68hjrtn4nxhxssaSWWTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862225; c=relaxed/simple;
	bh=qYZvqDEDPK9a2QjOoP9f0i5KDOVZiJl51CUfqdQEwxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJLVvdxgv/5ieDyYSb1+e5Kkn8VeJuMiZZ17ppmv5ISQ9gTyt9lnX3AsK1PdvGih8c96Az+dYFJBH65vufKFRlZPAoGuuT3VFKBBmCixtj6ihBbMyYzIclQ00bbdt5Z7EOPA4uwWFHK7EpgJocsgak1aIoN3iTwZawn8uImiakM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3KRc2kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3KRc2kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629CAC2BCB0;
	Fri, 15 May 2026 16:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862224;
	bh=qYZvqDEDPK9a2QjOoP9f0i5KDOVZiJl51CUfqdQEwxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3KRc2kfZYBfcu/jqIM44u3PKatfWrmzPnHkky5PKJPv9Zla3hYlKdr+ZjfJuG5iT
	 ntlSrVVRNLnXctD8I4pr0vA71Oz3kydpDXpQ/S2NC01W16qxXS4QynySpdEcSex1W7
	 rrBHKfcT0FIkyOwXaXHtycQhpKBV67jDgT8HmAaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Shetaia <Amir.Shetaia@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 114/188] drm/amdkfd: validate SVM ioctl nattr against buffer size
Date: Fri, 15 May 2026 17:48:51 +0200
Message-ID: <20260515154659.804050075@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/overflow.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -1676,6 +1677,16 @@ static int kfd_ioctl_smi_events(struct f
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
@@ -3122,7 +3133,11 @@ out:
 
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
@@ -3219,7 +3234,8 @@ static const struct amdkfd_ioctl_desc am
 	AMDKFD_IOCTL_DEF(AMDKFD_IOC_SMI_EVENTS,
 			kfd_ioctl_smi_events, 0),
 
-	AMDKFD_IOCTL_DEF(AMDKFD_IOC_SVM, kfd_ioctl_svm, 0),
+	AMDKFD_IOCTL_DEF_V(AMDKFD_IOC_SVM, kfd_ioctl_svm,
+			   kfd_ioctl_svm_validate, 0),
 
 	AMDKFD_IOCTL_DEF(AMDKFD_IOC_SET_XNACK_MODE,
 			kfd_ioctl_set_xnack_mode, 0),
@@ -3341,6 +3357,12 @@ static long kfd_ioctl(struct file *filep
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
@@ -1036,10 +1036,13 @@ extern struct srcu_struct kfd_processes_
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


