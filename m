Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1E73F86FB;
	Wed, 20 May 2026 17:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297182; cv=none; b=ZWPkFPVRmuNvZH7szo0NrnAVPmDfucmqChutXvfu09jREtXwsEZQAtucHFcl1dUOkqnOeKtYM2JofoyFrBhJhCQibEh8crZtf7nI+VrXFDqrvp1MkkLavUXrfw3I8jEfjbSPcQsQPRrdjutL83pJ983/0Z55ibv4o4XWbj9Klfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297182; c=relaxed/simple;
	bh=yHhXkLitJJ7CRXd3TzsJK1pHL1NGlW3jiUoUie9JgtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rCu/9tixue9X5csz/2Wl97Lf1AIf6Q5yKuuykHnSVmrOL1Nrvo2OYq6r1vekvKcYtKPzyACd0tfXOXxEWLmD9+F5Ebdvw08SQ5xgomoxSiPVXC5GqKqgvSKa4rZUccFTXi+ymwtTglQ3sJmvc/i+5rrjhgMoTEUe7fiqdlBaXPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S92TGUzi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S92TGUzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405F01F000E9;
	Wed, 20 May 2026 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297180;
	bh=ti6qtQvMgB4BrGqvadbN6WUPuN93eLZsYBlbihfK5kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S92TGUzi7JJnCBuRN8qZ+qkNcYy3xZiVlXeW7KLzgWZut0nuNYyPDeUv2d9nYSSyV
	 xaxQuK+sY0MG2k0Fmd9zX57PXkK2u1fLx+Tu0lO7cbUEl2hl9PdvRCEOBK/nYcA7be
	 Bxk9DovJjRhI+WyrApvC61OOAq7xTa+D9CT9HA6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Rong Zhang <i@rong.moe>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.0 1080/1146] platform/x86: lenovo-wmi-helpers: Fix memory leak in lwmi_dev_evaluate_int()
Date: Wed, 20 May 2026 18:22:10 +0200
Message-ID: <20260520162212.679347304@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

commit 0c3887a134f191723b53e2a47e501b534c8723ee upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/lenovo/wmi-helpers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/lenovo/wmi-helpers.c
+++ b/drivers/platform/x86/lenovo/wmi-helpers.c
@@ -46,7 +46,6 @@ int lwmi_dev_evaluate_int(struct wmi_dev
 			  unsigned char *buf, size_t size, u32 *retval)
 {
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object *ret_obj __free(kfree) = NULL;
 	struct acpi_buffer input = { size, buf };
 	acpi_status status;
 
@@ -55,8 +54,9 @@ int lwmi_dev_evaluate_int(struct wmi_dev
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
+	union acpi_object *ret_obj __free(kfree) = output.pointer;
+
 	if (retval) {
-		ret_obj = output.pointer;
 		if (!ret_obj)
 			return -ENODATA;
 


