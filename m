Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6EA3815E1;
	Fri,  4 Sep 2026 05:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500364; cv=none; b=J/o0jlG7a+u04yM06c5LSGpqbiotylE8WP+l7rC3Qq8MODRRwBuyForllSgh2uSPbV6S5uP8ElAi59+LzLMpOoLb3B8ZwCHwqFjY5Bx7sUk5R3zwIfwzpMDzlirngOhmPz9ZdMGzkhXHAqHIm2M+VgjhHhCm4P6l5rsk0CFVbNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500364; c=relaxed/simple;
	bh=QVHm3Pfj5pxhVvwuKfXs2s0p+a8uMuOCkyX5DtTtTDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKsFag2OqluD5yKImmD7Zq2tysML5w0oJouyZ6hsm7ZZc5geCpc4Y8f+gj9YMpskBu/aRTIS6/gsK5ljVnkcx6PSCXq6zAHEqRxJdJwu2Xx7iiTI2EKIm3YuMBOv7ukgum8yUcMhHO7OilrRr/lxZX4LT3sPS0a5E4aJML+02C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qASksBeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qASksBeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85161F00A3D;
	Fri,  4 Sep 2026 05:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500363;
	bh=jJFyy8hQ0VNKXUTe0LvVKA3MAnSbx6Z4zhBS9uz0W8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qASksBeLoed5fzJnvcx+edgFTUHWAOCuDsmOrsKa+FRa9pN22vdHIK0gRA6FxLllq
	 M4WHA4RDAbhQy8yKp75Vs+tgCDsANe1H0xA8zvUT33foO6sGzUYOCHXWpT3wQ0nZWj
	 NpfLb3B3BOh+ADuwHkUbiO1CktUyBaCwxi6lAQSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Rong Zhang <i@rong.moe>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/552] platform/x86: lenovo-wmi-helpers: Fix memory leak in lwmi_dev_evaluate_int()
Date: Fri,  4 Sep 2026 06:52:46 +0200
Message-ID: <20260904045748.038303578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

[ Upstream commit 0c3887a134f191723b53e2a47e501b534c8723ee ]

lwmi_dev_evaluate_int() leaks output.pointer when retval == NULL (found
by sashiko.dev [1]).

Fix it by moving `ret_obj = output.pointer' outside of the `if (retval)'
block so that it is always freed by the __free cleanup callback.

No functional change intended.

Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Fixes: e521d16e76cd ("platform/x86: Add lenovo-wmi-helpers")
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260331181208.421552-1-derekjohn.clark%40gmail.com [1]
Signed-off-by: Rong Zhang <i@rong.moe>
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Link: https://patch.msgid.link/20260510042546.436874-2-derekjohn.clark@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo/wmi-helpers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/lenovo/wmi-helpers.c b/drivers/platform/x86/lenovo/wmi-helpers.c
index f6fef6296251e..910e024a5c828 100644
--- a/drivers/platform/x86/lenovo/wmi-helpers.c
+++ b/drivers/platform/x86/lenovo/wmi-helpers.c
@@ -45,7 +45,6 @@ int lwmi_dev_evaluate_int(struct wmi_device *wdev, u8 instance, u32 method_id,
 			  unsigned char *buf, size_t size, u32 *retval)
 {
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object *ret_obj __free(kfree) = NULL;
 	struct acpi_buffer input = { size, buf };
 	acpi_status status;
 
@@ -54,8 +53,9 @@ int lwmi_dev_evaluate_int(struct wmi_device *wdev, u8 instance, u32 method_id,
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
+	union acpi_object *ret_obj __free(kfree) = output.pointer;
+
 	if (retval) {
-		ret_obj = output.pointer;
 		if (!ret_obj)
 			return -ENODATA;
 
-- 
2.53.0



