Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CE4347532;
	Fri,  4 Sep 2026 05:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499857; cv=none; b=JdVNzIgqhcj0VJs3TaBUB07agsyo135Cv69EYGs4tWyRCOc/tKfKTLII9ldO78fWx1a5FfUR7hukMVkbLCL+Owel0xDIhol6Nf30nXn9VtLtTAm+XkqCe1hkDqFjOGXpzIXX28oQAy0zPQL4qv8asdUlpfPPQ30F80IhCnsAEtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499857; c=relaxed/simple;
	bh=JNBhFkvPKJ9K3wa49bK2H/4DU4agbYbFnioAik9o4sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ivJfz8hpiM2cbAReXM6kIkZazayk24AyvmHfce5Jr8U9TdX6KKb6B7QIqkpJPMAkZ7whbBr5NE40BIl0tINipmycwr8C8TbzstazuhbLTpu1WYmFBtx96FnxOd4s/G6FxhKNhdy8aE5wZLUfkVCERquUlM6klx285GjM/I3/PjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlpdD8xi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlpdD8xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42CF1F00A3D;
	Fri,  4 Sep 2026 05:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499856;
	bh=PXP26sD2KLfNUTkGx2ip8jcSjHrakuGiyx52PTzf5IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XlpdD8xiBeoU5Pe7IUPtK1kI06Y0RglmbcobB3KpoQW/TWNXJhDzEEb4/DGsSo9pB
	 nnDtDeBJLm9WxbNuBAJ/UBr8wnnkV/RIfJnYFq+v4jo0LU+AwWIAuqKcZ9ocHh6ww0
	 VlHWzPFFHXMf99RRP7KZF9ZhbZtxGJOIppgnNHfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 565/713] platform/x86: ishtp_eclite: Fix ACPI device reference leak in probe error path
Date: Fri,  4 Sep 2026 06:58:53 +0200
Message-ID: <20260904045816.483970060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


