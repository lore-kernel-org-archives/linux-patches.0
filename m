Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77551145B27;
	Tue, 21 Jul 2026 17:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654634; cv=none; b=lUS62FY0aNhPcAhUbENR3a3VPVVRK136D65JfZtAlLBqB2evHeFDcBfz7COycr9sd47Ovr0/j72Kf/cZuIKVTZzjNBaNS7qfTby/f6DJYPu/Q1BwGVmQlEbjMMiezJd3xRLeSjGnDEsPlUWgZJIUn+npK7poD3TF8AtDXzLx8aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654634; c=relaxed/simple;
	bh=8i5eU2tdUDkXeWgLhyf4bHQHLknxL8loMV+5T7ko+sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tKMKYUIFFYOA+qSx4G0TRZs4bRWJSwVR3EqG/99rAFBC/fH5vis9Is7lfXnQbXOdb15VGuY8HFMJtpjVKfHTy41GCvebnqjrJraUeyfg/LUQZLQNxOxARkxjwzFQSKkTbWwxvVwpX6rY+zZcdcKahaMffeoetDExDHCaiLqyd8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcFHnZ/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcFHnZ/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD881F000E9;
	Tue, 21 Jul 2026 17:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654633;
	bh=hEqMWVz+AUHkeA0NaAi4o9JFWSfJkv38LAECmhsRmSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcFHnZ/CjCviJPOSYwKma4pfv0XB+zTanLpVgeXjDZA54tXyadaX0tIp5MvQR5an8
	 PhtiuxIX2dm8V0y2rCjorY4eH2LYCRh4tOJLEJjgmpG8CKKRrwbLe2zW0cEG8U2LlJ
	 WZXUdJoS2qml3L4mvgSC8IJl2aS2OAQDhb2ZNB38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.1 1779/2077] platform/x86/intel/tpmi: use cleanup helpers in mem_write()
Date: Tue, 21 Jul 2026 17:24:12 +0200
Message-ID: <20260721152634.709932201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhaoJinming <zhaojinming@uniontech.com>

commit a221557958e3a82d8565729d445a7385963f30b6 upstream.

In mem_write(), the temporary array returned by
parse_int_array_user() must be released on all exit paths.
Convert the array variable to use cleanup.h scope-based
cleanup so it is freed automatically on return.

This also moves the array declaration next to
parse_int_array_user() as required by cleanup.h usage
guidelines.

Fixes: 8e0a2fc68ec3 ("platform/x86/intel/tpmi: Use 32 bit aligned address for debugfs mem write")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Link: https://patch.msgid.link/20260521130848.2860219-1-zhaojinming@uniontech.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/vsec_tpmi.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/platform/x86/intel/vsec_tpmi.c b/drivers/platform/x86/intel/vsec_tpmi.c
index 8c4e2474b30c..3b76cccb975f 100644
--- a/drivers/platform/x86/intel/vsec_tpmi.c
+++ b/drivers/platform/x86/intel/vsec_tpmi.c
@@ -50,6 +50,7 @@
 #include <linux/auxiliary_bus.h>
 #include <linux/bitfield.h>
 #include <linux/debugfs.h>
+#include <linux/cleanup.h>
 #include <linux/delay.h>
 #include <linux/intel_tpmi.h>
 #include <linux/intel_vsec.h>
@@ -473,7 +474,7 @@ static ssize_t mem_write(struct file *file, const char __user *userbuf, size_t l
 	struct seq_file *m = file->private_data;
 	struct intel_tpmi_pm_feature *pfs = m->private;
 	u32 addr, value, punit, size;
-	u32 num_elems, *array;
+	u32 num_elems;
 	void __iomem *mem;
 	int ret;
 
@@ -481,15 +482,14 @@ static ssize_t mem_write(struct file *file, const char __user *userbuf, size_t l
 	if (!size)
 		return -EIO;
 
+	u32 *array __free(kfree) = NULL;
 	ret = parse_int_array_user(userbuf, len, (int **)&array);
 	if (ret < 0)
 		return ret;
 
 	num_elems = *array;
-	if (num_elems != 3) {
-		ret = -EINVAL;
-		goto exit_write;
-	}
+	if (num_elems != 3)
+		return -EINVAL;
 
 	punit = array[1];
 	addr = array[2];
@@ -498,15 +498,11 @@ static ssize_t mem_write(struct file *file, const char __user *userbuf, size_t l
 	if (!IS_ALIGNED(addr, sizeof(u32)))
 		return -EINVAL;
 
-	if (punit >= pfs->pfs_header.num_entries) {
-		ret = -EINVAL;
-		goto exit_write;
-	}
+	if (punit >= pfs->pfs_header.num_entries)
+		return -EINVAL;
 
-	if (addr >= size) {
-		ret = -EINVAL;
-		goto exit_write;
-	}
+	if (addr >= size)
+		return -EINVAL;
 
 	mutex_lock(&tpmi_dev_lock);
 
@@ -525,9 +521,6 @@ static ssize_t mem_write(struct file *file, const char __user *userbuf, size_t l
 unlock_mem_write:
 	mutex_unlock(&tpmi_dev_lock);
 
-exit_write:
-	kfree(array);
-
 	return ret;
 }
 
-- 
2.55.0



