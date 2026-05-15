Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B203F44CE;
	Fri, 15 May 2026 16:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861966; cv=none; b=b086npVyvm2E7wt0LyNv+nrFWlZRtNyab0AjuVGMLo6JLxSPWoRaBrLry6iHnKZxIGlMGByL226YaEn7EIRDfD6vCvah32+MUVOsByfyKHLhZvVTxa24qUt4S5HdH0RB9GhoW0LJAM2wBfs6qlluOYi7LM8kU1hXtZPWjn6MzPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861966; c=relaxed/simple;
	bh=TpmMhSC+KZPiabktms3Sp9kUMdsg0gXj3XCa0+dCD9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDumE2h9WXkPnKLObjGQ7ufEub9nr52qGiAB21S7+ZGw7ZNMQ1qCR9NbRtTFQid0spct/qfD/TKP0wTpLW1XTwnFrFD+72s/BD0lP4SrZfCM89rM+hYYNlrtETFR5MpNb0oksl3NxIXrxMKSXf2J+4mNBSlge+vb8L8IMpEh9o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eknXwpQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eknXwpQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B256C2BCB0;
	Fri, 15 May 2026 16:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861965;
	bh=TpmMhSC+KZPiabktms3Sp9kUMdsg0gXj3XCa0+dCD9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eknXwpQFF550Po5v5B94+43DYlJTw9xBiVuj3YoeYzq65bcjMWiN94c3drNGOjit9
	 P2BVkc64WBIgMRB6JN7P7kephOGr0CAnNmgvvPO3UYkE9L48eD3pxKaB3Vn29h7iPM
	 Y7CAFwRkJAxkV3XG0RU+PHQeIhdnBpjYvyz5ftaw=
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
Subject: [PATCH 6.18 055/188] media: iris: fix QCOM_MDT_LOADER dependency
Date: Fri, 15 May 2026 17:47:52 +0200
Message-ID: <20260515154658.508059037@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


