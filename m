Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AAA29B77C;
	Thu, 25 Jun 2026 13:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393092; cv=none; b=dANr0rwk6Rs061W9wOGe6DvlPQutvdIf3Rn1hxjXckGJjr5lv4ZB1+SXKBi9sRZhhVptZqCavJLv6j/XWj/mlZLbAd4cL7CiQi7LhzAU0Yt7KeetHlV8CIDZJwdCRXWEB1JTTFtwUe9atl1ymu0R8SOIOGNZ7drbn3sICtS4vLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393092; c=relaxed/simple;
	bh=U29JaSPFdth0W3i93z8glwy0wwD1X/UdMM4dZJnTG8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iojdq1RGqO0Bt+7WS6GMHhK6mrmHmVSme3I+2ZDxr6d08VZ/AFAG10WWtpOSSJZ9jz4ZZgOBuyliK+8FU7cb/BIW8pOKsh5PBuYWDLLVsqyJER6UvUeboGglsmOif/Q1QtX//mGEUx3ZRM9vGp8gus3F8K8QC2gnNnxbN0wMbo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADCMiglJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADCMiglJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EAF1F00A3A;
	Thu, 25 Jun 2026 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393090;
	bh=KAM/1qLCoNKhjnL+pjuoW2vUSMFY9hqKYFn9BfvHe7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADCMiglJnANZ1oM1BzPno7Rxgzt9+zIYK+bAdsUd/8JSD8mjqeqQJf2XayNOxTBBh
	 GJE+NBSK7J+43F2oW8K+XDvwa+6UeTworP/Ag4xxReYkQ4PWmRsdnJ788ZNcuDavLK
	 83Cy5ipi8VSAv88ecZa+NrZzOo/UpoUoRQGiARD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.0 41/49] Input: rmi4 - fix bit count in bitmap_copy()
Date: Thu, 25 Jun 2026 14:03:53 +0100
Message-ID: <20260625125643.299523917@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit f22dbbcbd1f70ed004a7bf8837e0f0c3cc230b78 upstream.

bitmap_copy() takes number of bits, not bytes (or longs). Correct
the bit count in rmi_driver_set_irq_bits() and
rmi_driver_clear_irq_bits().

Fixes: 2b6a321da9a2 ("Input: synaptics-rmi4 - add support for Synaptics RMI4 devices")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Link: https://patch.msgid.link/20260505045952.1570713-7-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_driver.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -388,9 +388,8 @@ static int rmi_driver_set_irq_bits(struc
 							__func__);
 		goto error_unlock;
 	}
-	bitmap_copy(data->current_irq_mask, data->new_irq_mask,
-		    data->num_of_irq_regs);
 
+	bitmap_copy(data->current_irq_mask, data->new_irq_mask, data->irq_count);
 	bitmap_or(data->fn_irq_bits, data->fn_irq_bits, mask, data->irq_count);
 
 error_unlock:
@@ -419,8 +418,8 @@ static int rmi_driver_clear_irq_bits(str
 							__func__);
 		goto error_unlock;
 	}
-	bitmap_copy(data->current_irq_mask, data->new_irq_mask,
-		    data->num_of_irq_regs);
+
+	bitmap_copy(data->current_irq_mask, data->new_irq_mask, data->irq_count);
 
 error_unlock:
 	mutex_unlock(&data->irq_mutex);


