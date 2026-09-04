Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30923BCD0A;
	Fri,  4 Sep 2026 05:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501485; cv=none; b=S0+7heYboLkzDXbBUiEuouy3ZR3qP0V5uDLT2G+BFFuydRsqpN2MDEfdER5n69e1DrFl2y67b2UgMKCk6LrB4DtOKNyIB39bAInnGpPYtVe4BjDDZDaTjrIhrc86LTXg38m8VYeZe6yOImqqEOcKYfnVzrbEtcf3a0nxOLXEoMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501485; c=relaxed/simple;
	bh=mRa+DT0op1vm/YAESwGNFHeN7jl3GPVZjdp5zS0Gmr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f+JKJ5LWtIJpA9N3q9DNw3FQfZWL6h0tRRkOtTzGqRtgoRli0mXPjgMBWafAcCVO+d8qlUpoCRhZ1nWnnZ7kC3oa41gLGsMKDTQrK010DYaHSCxMBKO2MwywCkuti3eic3OIo20ZUheWYhxjvlBKx+x/XOkPkOZ6d1YoB2No9f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtFoQ+Yc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtFoQ+Yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455711F00A3D;
	Fri,  4 Sep 2026 05:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501483;
	bh=IV7VBb9Jrou4fN6yxtPT/rwDXlyjK7Jaf14Gab2VoOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtFoQ+YcZVn0H3rQYG69u+y75f8qJ7CiByAjwo+ykygBZvTIRRzOSR4mf211on2cx
	 AkjBmvipX1pioHX2LmZHVBK4wWbq8txL6nqcOlAV3RkwcjQhTXaNG7xalf53AO6Hf/
	 U7o9YraW2odklL598w6zmm1/+OTC2aKk3JMqa+kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 425/552] platform/x86: ishtp_eclite: Fix ACPI device reference leak in probe error path
Date: Fri,  4 Sep 2026 06:59:42 +0200
Message-ID: <20260904045800.236424056@linuxfoundation.org>
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

From: Ma Ke <make_ruc2021@163.com>

commit 62b57396c26a1ce54963709928ea0d01fa522eea upstream.

ecl_ishtp_cl_probe() acquires a reference to an ACPI device via
acpi_find_eclite_device() but fails to release it in the error path
when acpi_opregion_init() fails. This results in a reference count
leak, preventing proper cleanup of the ACPI device.

Calling path: acpi_find_eclite_device() ->
acpi_dev_get_first_match_dev() -> acpi_dev_get_next_match_dev() ->
bus_find_device() -> get_device().

Found by code review.

Signed-off-by: Ma Ke <make_ruc2021@163.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Fixes: 7b6bf51de974 ("platform/x86: Add Intel ishtp eclite driver")
Link: https://patch.msgid.link/20260624014910.1226446-1-make_ruc2021@163.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/ishtp_eclite.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/ishtp_eclite.c
+++ b/drivers/platform/x86/intel/ishtp_eclite.c
@@ -600,13 +600,16 @@ static int ecl_ishtp_cl_probe(struct ish
 	rv = acpi_opregion_init(opr_dev);
 	if (rv) {
 		dev_err(cl_data_to_dev(opr_dev), "ACPI opregion init failed\n");
-		goto err_exit;
+		goto err_put;
 	}
 
 	/* Reprobe devices depending on ECLite - battery, fan, etc. */
 	acpi_dev_clear_dependencies(opr_dev->adev);
 
 	return 0;
+
+err_put:
+	acpi_dev_put(opr_dev->adev);
 err_exit:
 	ishtp_set_connection_state(ecl_ishtp_cl, ISHTP_CL_DISCONNECTING);
 	ishtp_cl_disconnect(ecl_ishtp_cl);


