Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A29E2741C9;
	Tue, 11 Nov 2025 01:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824467; cv=none; b=rJC5NbrN9rCw14W34tzI/iQW13L97A/n6xiYEPMSiKnMHn0c/BlT3NVWionW85GW2NQtixal616qBWD0QrQOAG5VuP2eBRMPyLqbcQVClPriV4qWb6z+ysV4RrUCYIg0tlkN20FIk9Krb/mUkOeaV7heMtYxHpGqhS+kg8sNLlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824467; c=relaxed/simple;
	bh=wy47GdRzKuwHNdUC5Bx7aS3pFeKCr2NwpecUePLn2Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AI6L4A1FUfs8wobCImB9JVrHH8sJZaSIYijPN2fYrYMgty5/JN74G9Y87CRwWCA0jSY8oCo+oNCIKO+4q7EUqbT+vTyc7jA46Ayla5I4xAmGGEF89TH8LJnjoc+PhSw4xeGVnAMRD0dbcxhfzrXl+izutk7+PjYkrWrpz7CSdhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5sijHFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5sijHFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC66C4CEF5;
	Tue, 11 Nov 2025 01:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824467;
	bh=wy47GdRzKuwHNdUC5Bx7aS3pFeKCr2NwpecUePLn2Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5sijHFPxJ0WhXqofTZFNq2HloB72wDCFCs8fcUM9rLjmoR88EKO6wn23LnRQY2E1
	 3Z2LVVMtaKCNDgihfF1sYUkpTWR+qkrDJ9sLMv+6EsXepXyWafLs86IqtG5EAGSHWu
	 eA7oCKsfOnK3SS3i0CFUSfbN40UdJi2lQf+0rgJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 452/565] char: misc: restrict the dynamic range to exclude reserved minors
Date: Tue, 11 Nov 2025 09:45:08 +0900
Message-ID: <20251111004537.058519784@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 31b636d2c41613e3bd36256a4bd53e9dacfa2677 ]

When this was first reported [1], the possibility of having sufficient
number of dynamic misc devices was theoretical, in the case of dlm driver.
In practice, its userspace never created more than one device.

What we know from commit ab760791c0cf ("char: misc: Increase the maximum
number of dynamic misc devices to 1048448"), is that the miscdevice
interface has been used for allocating more than the single-shot devices it
was designed for. And it is not only coresight_tmc, but many other drivers
are able to create multiple devices.

On systems like the ones described in the above commit, it is certain that
the dynamic allocation will allocate certain reserved minor numbers,
leading to failures when a later driver tries to claim its reserved number.

Instead of excluding the historically statically allocated range from
dynamic allocation, restrict the latter to minors above 255. That also
removes the need for DYNAMIC_MINORS and the convolution in allocating minor
numbers, simplifying the code.

Since commit ab760791c0cf ("char: misc: Increase the maximum number of
dynamic misc devices to 1048448") has been applied, such range is already
possible. And given such devices already need to be dynamically created,
there should be no systems where this might become a problem.

[1] https://lore.kernel.org/all/1257813017-28598-3-git-send-email-cascardo@holoscopio.com/

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://lore.kernel.org/r/20250423-misc-dynrange-v4-1-133b5ae4ca18@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 792a1412faffe..8d8c4bcf07e1c 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -58,9 +58,8 @@ static LIST_HEAD(misc_list);
 static DEFINE_MUTEX(misc_mtx);
 
 /*
- * Assigned numbers, used for dynamic minors
+ * Assigned numbers.
  */
-#define DYNAMIC_MINORS 128 /* like dynamic majors */
 static DEFINE_IDA(misc_minors_ida);
 
 static int misc_minor_alloc(int minor)
@@ -69,34 +68,17 @@ static int misc_minor_alloc(int minor)
 
 	if (minor == MISC_DYNAMIC_MINOR) {
 		/* allocate free id */
-		ret = ida_alloc_max(&misc_minors_ida, DYNAMIC_MINORS - 1, GFP_KERNEL);
-		if (ret >= 0) {
-			ret = DYNAMIC_MINORS - ret - 1;
-		} else {
-			ret = ida_alloc_range(&misc_minors_ida, MISC_DYNAMIC_MINOR + 1,
-					      MINORMASK, GFP_KERNEL);
-		}
+		ret = ida_alloc_range(&misc_minors_ida, MISC_DYNAMIC_MINOR + 1,
+				      MINORMASK, GFP_KERNEL);
 	} else {
-		/* specific minor, check if it is in dynamic or misc dynamic range  */
-		if (minor < DYNAMIC_MINORS) {
-			minor = DYNAMIC_MINORS - minor - 1;
-			ret = ida_alloc_range(&misc_minors_ida, minor, minor, GFP_KERNEL);
-		} else if (minor > MISC_DYNAMIC_MINOR) {
-			ret = ida_alloc_range(&misc_minors_ida, minor, minor, GFP_KERNEL);
-		} else {
-			/* case of non-dynamic minors, no need to allocate id */
-			ret = 0;
-		}
+		ret = ida_alloc_range(&misc_minors_ida, minor, minor, GFP_KERNEL);
 	}
 	return ret;
 }
 
 static void misc_minor_free(int minor)
 {
-	if (minor < DYNAMIC_MINORS)
-		ida_free(&misc_minors_ida, DYNAMIC_MINORS - minor - 1);
-	else if (minor > MISC_DYNAMIC_MINOR)
-		ida_free(&misc_minors_ida, minor);
+	ida_free(&misc_minors_ida, minor);
 }
 
 #ifdef CONFIG_PROC_FS
-- 
2.51.0



