Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481E41C75F9;
	Sat, 12 Sep 2026 13:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220738; cv=none; b=dtrqhmhZOoDkDyQZhwWdM2SOZZNafrjVteIrdZvKtuCVuszYF9RT298yLe67fVCqAXO80CEG5R1y4ms7ke/9WIlmC5PZ1vo56zTnGu/BYYY4TELFhRAkKL7zzOwsgT1DVk7HDrzo9BubElUr8xCBd70oA1B3+yOfp3hMtb9NfFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220738; c=relaxed/simple;
	bh=Zt4lSHGk1eJfR4m7jQm+py62WXi5wEwoWQTxG72JWAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=far5Rwx+JmQ8OlpGd9LwX/Zocb35Ku8CjYXQK6AG+KxhSWLM2MGrHAW5Yl9cSj6nUfkikuRaR0zymcN45LsIgkk0HTRD+G1Ibo2LDYi/aKY0Av97HhIhqUtMg6kzIMmjbw33UHsOCiDE6znI8Rh0Gz1sKJ71LG/ibgseQrsx8Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiYTVTmL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiYTVTmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A131F000FF;
	Sat, 12 Sep 2026 13:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220737;
	bh=tSEiDBKKkfxWN2kvQHBSwBvm/I2Jhv8Haq2lm/ZOqMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QiYTVTmLs04K33RcxAY5NsG8cRBT6qikv3nXj9HQ05r6sXzl+2KlXX9/VqPgeJ6Si
	 vgFcP05UBHmKRgNUuECo0GL5VyaIFT27BEWRrYE6DNzwFkBB1OGmHUt8ppYCktQeXa
	 WcRiLiKnxiRHzZ2XbxkKvN4CMCNMJ2Ll9qXissE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0238/1424] platform/x86: ishtp_eclite: Fix ACPI device reference leak in probe error path
Date: Sat, 12 Sep 2026 08:44:30 +0200
Message-ID: <20260912065612.612780973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


