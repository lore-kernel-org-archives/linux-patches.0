Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA682427F97;
	Fri,  4 Sep 2026 06:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502803; cv=none; b=Kg8GcmVthU48cbiuRT4vd3Q4UtI1T+tzR7p1V6ZQyfj8vEE0oQNyYDqwISTXoKxzE2trDPX6GXfT5jDbq0NsOVFV97ebqvHBTYgTSVzuxRotmUEEnaw69Uy2svmocIiwoxa8nHMPbvJObTUsRpsqA3KEJs095mV3Uoe6XMganVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502803; c=relaxed/simple;
	bh=bPWMBz7nqlFMnu0zu21cbGTd+rfrJApG9gqB+2cVfnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GFQfc7kO12Tyo9kSQD0Nc5mVgaDNR1Hm4Ftyn3mJnbnSTCL65txmnrABgLv9clPwH8RCcWQOhOpdQcaxNgdzwxWuXSG3pmmdW49k9X74uTsctMZzXLglfV1l+NWFqvySJhypGgXCRfXUxhMTdYFUlj5g5J/lFu06+yK5IaT3B1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtlLTe8G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtlLTe8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501DA1F00A3D;
	Fri,  4 Sep 2026 06:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502801;
	bh=Tc3PQEKJZTpdmz2G2c6o19i+Y1X/DpeInRBKiw4rWE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtlLTe8GxAwpAtbd2VrKul8JNG5Mq8PAZZ22wrh1yGbQGU6T0nvd774hMoKS5oesj
	 s5XHPtgz8vY6KK40rlXFeoVaKMES/ip6XbWAggunXZV1vK1mwDdqJsxzJjgg9TdNcp
	 b8YnJ0jFgKz/7Q9SVJs29sY87O2EbuuK69Id9JS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 318/403] platform/x86: ishtp_eclite: Fix ACPI device reference leak in probe error path
Date: Fri,  4 Sep 2026 07:02:01 +0200
Message-ID: <20260904045742.068592679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


