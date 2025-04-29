Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC5E253B7E;
	Tue, 29 Apr 2025 18:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949875; cv=none; b=anTdBl2LrhBCes3100G6u74DDS5W3bpi9rk6Jj8Wd79c8mvkoaKZHdgfcfTmJJuAIzPhMadIVCap31bRvVO4jEW65xIHNreqn42jDKj0gHE/Jqzfi1NfZwCeFWNdcUp5WfPR4I6wcZpZ+2iVAUGECXFPT/p/jQ8aRS71e7L/NgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949875; c=relaxed/simple;
	bh=J0vT28ayD33QMh8T9KC0YE/FLvI4yY0R6JZU0IqDxqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+67T10/WVrooV4UQumDqSy7vAXs5uhZyAE+IAPGkC8l3J6DXs+zXHn45dihOMBj6QxoMp/kBB0KJwInKR/vVsj0isqKgqbyfSZKyIhsVWJ18rH2F57UPkQ/7bO4TudADFX9O0kQSCErmKZU90gHOWilyp+uS2u8Dz11Zl0AJNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIMagE/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIMagE/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA50AC4CEE3;
	Tue, 29 Apr 2025 18:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949875;
	bh=J0vT28ayD33QMh8T9KC0YE/FLvI4yY0R6JZU0IqDxqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIMagE/8f8r2b3J7HAc2hYY9ygoQQfKji7VK5/6EaOtpSOdVto64a1+S+vksCJJrw
	 5kSPfh16hLVhSLJKeax7BCBtOYl9iWLLt2ErPbY7EYAQgzBGxhrZconNAqZgLsrm89
	 8l/ty3wE1QkjkPW0dSQCOohvKZ2u6A08Nx91BlrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 084/167] usb: chipidea: ci_hdrc_imx: fix usbmisc handling
Date: Tue, 29 Apr 2025 18:43:12 +0200
Message-ID: <20250429161055.156647742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 4e28f79e3dffa52d327b46d1a78dac16efb5810b upstream.

usbmisc is an optional device property so it is totally valid for the
corresponding data->usbmisc_data to have a NULL value.

Check that before dereferencing the pointer.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: 74adad500346 ("usb: chipidea: ci_hdrc_imx: decrement device's refcount in .remove() and in the error path of .probe()")
Cc: stable <stable@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20250316102658.490340-2-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -511,7 +511,8 @@ disable_hsic_regulator:
 		cpu_latency_qos_remove_request(&data->pm_qos_req);
 	data->ci_pdev = NULL;
 err_put:
-	put_device(data->usbmisc_data->dev);
+	if (data->usbmisc_data)
+		put_device(data->usbmisc_data->dev);
 	return ret;
 }
 
@@ -535,7 +536,8 @@ static void ci_hdrc_imx_remove(struct pl
 		if (data->hsic_pad_regulator)
 			regulator_disable(data->hsic_pad_regulator);
 	}
-	put_device(data->usbmisc_data->dev);
+	if (data->usbmisc_data)
+		put_device(data->usbmisc_data->dev);
 }
 
 static void ci_hdrc_imx_shutdown(struct platform_device *pdev)


