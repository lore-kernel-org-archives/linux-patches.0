Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CBC2EC086;
	Thu, 25 Jun 2026 13:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393178; cv=none; b=DrRYuelueQ0TuI0Db9ti8aM1PODtuQElt9pVo0E+LV1ujurtafvZQ0p0mtZxLA4XAoKoovJE+TLz8kHwFTOXyLLxxkCD3WMN8p+8U6ncoL7wAiED0clPS2zx70WI7/DcW2clKqthZTWUDeBZgtj+VxX5uZ47yo2bpU0/cS4ifC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393178; c=relaxed/simple;
	bh=f8qR+u1N/x3rmZpdqcpgDoFwWTzCy0kBV2ylWoYNHE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zgkz+mBdaB3OTG49lrLRGJxMYwyk1XCNn4rHaiUay9mGczcsq/fGJnb6CUtU2LLdGNY0pCDsGIhyhKjDKATzQYsNTR+sBTTKvHb588/03sR7ngqM20UyupN1RRJ8VxT4n4A/8Z9zokpzX5RFq8djCiEdLeRpyNcH57mvME78oVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=el8GcXLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="el8GcXLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71AB1F000E9;
	Thu, 25 Jun 2026 13:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393177;
	bh=PTb3zmEcALupxCZd7m46KscOGb3sV1XvDDxz6JUBn4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=el8GcXLnKyWwuzpeKBW7Jlhw+sGdugE5iYNWcMMral6x3LsXqXbRb3a1M20LydrxQ
	 8gu38P+BeFB46sO1KSzuybN7IDLjK+f51YzfNygap5TZfM2zjE5E7a5wCV2QOYy5a6
	 zQIEuzKTE1/AFGWZU5LI9zWmcOMj7A9LLdPUKrfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 13/21] Input: rmi4 - fix bit count in bitmap_copy()
Date: Thu, 25 Jun 2026 14:04:05 +0100
Message-ID: <20260625125615.103212727@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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


