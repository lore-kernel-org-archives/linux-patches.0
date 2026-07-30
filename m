Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03C23A5433;
	Thu, 30 Jul 2026 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421671; cv=none; b=UwkkbLY6LikUkXMlWy+SvsOEnhRGZEV5mm3CfhjTgeziHN8FbdEpKa07kPyvn0uJVy/dNRRNWqQPDEfRGIsoU4XzIOBgCGggqP18LFZ5IynxUqNN930iGWuwmNtLakyuSiTORUCWksWrnIrXUJtDEtBdnTDjEquNwr5baV+Qudc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421671; c=relaxed/simple;
	bh=dtQGyc3K20YO4Kk9KkGKCU3f9sDqpstCp32+CckdAkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O1+nHi78zh6r0rwMfn/DbuWiEaAQxd65o6COC8RCmIyrevZsl2yuHIGDOdz6ETwAozsu+cuNQmvZUaZSMKRV/ZVyrWzGxnOtUjByz/q5KWEEBppuEe7lRI/CjmKIIfAPfPrVMJKJ2FJRaErtEweKpKC+MoVdABl8ObLm1sV76Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jG9GB+eo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jG9GB+eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143CC1F000E9;
	Thu, 30 Jul 2026 14:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421670;
	bh=5eQiOFrwViGtmBxh1QpuWFnqPyGnFeuzhzJf9yG35tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jG9GB+eoFuDBfU/fphmKHwW//L/JGCY1NGeFKltD5JshSveuoDvVRuX+uX4XJoBDs
	 iulTQB7TvljjyCusF2tqPAPPabe1CG/yRE+Swuiuk63HKI7ijqSjnn3i/XMKtWYLj9
	 hYQy7f3bZdNJo3keL3ogEfTkBfA3aSORPMqvjY2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 183/744] platform/x86/intel/vsec: free ACPI discovery data on early errors
Date: Thu, 30 Jul 2026 16:07:36 +0200
Message-ID: <20260730141448.175326859@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 09b2ae290a241ce1f5f738fb65c35f449dcf663d ]

intel_vsec_add_dev() may attach an ACPI discovery table copy to the
intel_vsec_device before passing ownership to intel_vsec_add_aux(). The
normal auxiliary-device release path frees that copy, but the earliest
intel_vsec_add_aux() failures free only the outer structure directly.

Route those direct frees through a common helper so acpi_disc is
released consistently on the parent, xarray, and ID allocation failure
paths.

Fixes: 22fa2ebc11a1 ("platform/x86/intel/vsec: Plumb ACPI PMT discovery tables through vsec")
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Link: https://patch.msgid.link/CAMuQ4bUtJtYNTguKoiXngROJw0QQQcrvW3=3_B0-hpMQOFqvCQ@mail.gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 3ae4557b32b478..5ab2215fdd7fa8 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -103,6 +103,12 @@ static void intel_vsec_remove_aux(void *data)
 	auxiliary_device_uninit(data);
 }
 
+static void intel_vsec_dev_free(struct intel_vsec_device *intel_vsec_dev)
+{
+	kfree(intel_vsec_dev->acpi_disc);
+	kfree(intel_vsec_dev);
+}
+
 static void intel_vsec_dev_release(struct device *dev)
 {
 	struct intel_vsec_device *intel_vsec_dev = dev_to_ivdev(dev);
@@ -111,8 +117,7 @@ static void intel_vsec_dev_release(struct device *dev)
 
 	ida_free(intel_vsec_dev->ida, intel_vsec_dev->auxdev.id);
 
-	kfree(intel_vsec_dev->acpi_disc);
-	kfree(intel_vsec_dev);
+	intel_vsec_dev_free(intel_vsec_dev);
 }
 
 static const struct vsec_feature_dependency *
@@ -218,20 +223,22 @@ int intel_vsec_add_aux(struct device *parent,
 	struct auxiliary_device *auxdev = &intel_vsec_dev->auxdev;
 	int ret, id;
 
-	if (!parent)
+	if (!parent) {
+		intel_vsec_dev_free(intel_vsec_dev);
 		return -EINVAL;
+	}
 
 	ret = xa_alloc(&auxdev_array, &intel_vsec_dev->id, intel_vsec_dev,
 		       PMT_XA_LIMIT, GFP_KERNEL);
 	if (ret < 0) {
-		kfree(intel_vsec_dev);
+		intel_vsec_dev_free(intel_vsec_dev);
 		return ret;
 	}
 
 	id = ida_alloc(intel_vsec_dev->ida, GFP_KERNEL);
 	if (id < 0) {
 		xa_erase(&auxdev_array, intel_vsec_dev->id);
-		kfree(intel_vsec_dev);
+		intel_vsec_dev_free(intel_vsec_dev);
 		return id;
 	}
 
-- 
2.53.0



