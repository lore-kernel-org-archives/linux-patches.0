Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D893C2F5337;
	Fri,  7 Aug 2026 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116807; cv=none; b=I4Dtj1GjN0mZZ/EOr5j8c7Wzmzo+HfMbq7DJKhPf11SElca2k8SKoqXWPU/JzKhyK8hiAafimPnG6opBNQgj/LEwa4wST6JTRCkePc0OA6hTKAkKJO+WI6mI8r0bmKM6C7TyCQMqG96ZagfviIbhhB9VIIgROw8QsRdPXvWqNtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116807; c=relaxed/simple;
	bh=Huv8npom+UyXWRIM7iCmKr5v/s7V3/hGtNYnt8rvtwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5eyZs8FdJUtdOchGRLMt1u3nrH5SeecQ8P6kwY7Hv+5Wb3tNLwKc2U1B6aFB3ELqOgj8GrxCx2IKXdfBcwZ1nogzFyp1haeEhWsduqkYy8nY61CGbXagFlRv492p35ykxjxMxJul975zichPcSO0ej/2frUQrH/rEB2kXLRv0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+NdEkft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+NdEkft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC511F000E9;
	Fri,  7 Aug 2026 15:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116805;
	bh=m7ZaI3aR4BWdpsmRIvqT7MxnUjRvTbtY+hvD97orDWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+NdEkftVot95zeGi208JiVej22xi/a2A2M8eBlbwLU/T9AIIuNtW9qRkNsXBNT85
	 WsdGLzYlN0d1iwVs+YpV4Gr8isUDed2j1EAZEv22s5jkjl3KcvC7ozCxP8qAT1+2wN
	 B8PNwLA5lFpiAAdz3HUC7rdyqOxv5n47Wh4XXuEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Aleksandr Mezin <mezin.alexander@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 096/438] hwmon: (nzxt-smart2) DMA-align output buffer
Date: Fri,  7 Aug 2026 16:34:52 +0200
Message-ID: <20260807143430.036681263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 080bbf42faf77e6489ab30d5114c5f8f6ccbb1b8 ]

Sashiko reports:

When send_output_report() calls hid_hw_output_report(), the underlying USB
HID core calls usb_interrupt_msg() which maps this buffer directly for DMA.

When the DMA mapping flushes or invalidates the cacheline, it will corrupt
the adjacent variables (mutex, update_interval) that were modified
concurrently by the CPU. This causes memory corruption due to cacheline
sharing on non-coherent CPU architectures (such as ARM or MIPS). The DMA
API debugging tool (CONFIG_DMA_API_DEBUG) will trigger runtime warnings
for this violation.

Any operation that triggers send_output_report() (like setting a fan speed
or updating the interval) causes the USB DMA mapping. On systems with
non-coherent caches, this structural bug causes immediate and deterministic
memory corruption.

Align the output buffer to ARCH_DMA_MINALIGN to fix the problem.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 53e68c20aeb1 ("hwmon: add driver for NZXT RGB&Fan Controller/Smart Device v2.")
Cc: Aleksandr Mezin <mezin.alexander@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nzxt-smart2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/nzxt-smart2.c b/drivers/hwmon/nzxt-smart2.c
index e2316c46629d6..ff0c0bee0e839 100644
--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -203,7 +203,7 @@ struct drvdata {
 	 */
 	struct mutex mutex;
 	long update_interval;
-	u8 output_buffer[OUTPUT_REPORT_SIZE];
+	u8 output_buffer[OUTPUT_REPORT_SIZE] __aligned(ARCH_DMA_MINALIGN);
 };
 
 static long scale_pwm_value(long val, long orig_max, long new_max)
-- 
2.53.0



