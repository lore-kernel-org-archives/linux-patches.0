Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1366E4BC00E;
	Fri, 15 May 2026 16:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862503; cv=none; b=NzrmA9150fhJrOIwTeaarbvXO/kK/olU0qnnEK14i8vzJDSfZofMCo0JE3eagxFMQAoJ/MHs5W7hmOXMOnGEvIorjyL5XlVE8H9jSug4eriBh0TR7odeaJ7NRJNhNVmtwQs1JymsOUzagKQOCt5mV0q5kKLoye7A7VxW4S4QVxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862503; c=relaxed/simple;
	bh=RCNTZ/dNaL8pAz15EbRn4BYzqAIiW8AIeCDFhj/Qxyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODP/L4grDiHafFIfzZKZbwylNbx98cYXCUTH6Aig7ytGy1cfLsda5ZS3peCntwN+vsz4lvfZK18lE+gwV89M/3mmDZa2kfMXG2tcfuuPz3CnjRiMR5HZC9VmCLhqd7JBl4XJMFu13zrH7Zu2GBMt9NrsnJO8+y5P9UlMbd4hzSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qr0gdn5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qr0gdn5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956D3C2BCB0;
	Fri, 15 May 2026 16:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862502;
	bh=RCNTZ/dNaL8pAz15EbRn4BYzqAIiW8AIeCDFhj/Qxyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qr0gdn5xj4OPgBAtqr7MosrVupjruY+kSJYLjZwW4DgcTmhz9jY+ey4G4CzePIE7s
	 ugXDThqo3GxN3YEiNLP7d/aGUTYo+V6zfws2Cx+cxgJRjlod5/AbTVkIXDphkAZFcI
	 idE2wQbitCEK+iouYsJEewQToPM73EODno20BYYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 072/201] media: iris: fix QCOM_MDT_LOADER dependency
Date: Fri, 15 May 2026 17:48:10 +0200
Message-ID: <20260515154700.093780518@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit a297c5165f91366cbc3490e630aabd1c0f70efb8 upstream.

When build-testined with CONFIG_QCOM_MDT_LOADER=m and VIDEO_QCOM_IRIS=y,
the kernel fails to link:

x86_64-linux-ld: drivers/media/platform/qcom/iris/iris_firmware.o: in function `iris_fw_load':
iris_firmware.c:(.text+0xb0): undefined reference to `qcom_mdt_get_size'
iris_firmware.c:(.text+0xfd): undefined reference to `qcom_mdt_load'

The problem is the conditional 'select' statement. Change this to
make the driver built-in here regardless of CONFIG_ARCH_QCOM.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Fixes: d19b163356b8 ("media: iris: implement video firmware load/unload")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/iris/Kconfig
+++ b/drivers/media/platform/qcom/iris/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_QCOM_IRIS
         depends on VIDEO_DEV
         depends on ARCH_QCOM || COMPILE_TEST
         select V4L2_MEM2MEM_DEV
-        select QCOM_MDT_LOADER if ARCH_QCOM
+        select QCOM_MDT_LOADER
         select QCOM_SCM
         select VIDEOBUF2_DMA_CONTIG
         help


