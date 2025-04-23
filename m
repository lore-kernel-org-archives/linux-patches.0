Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2C21A317A;
	Wed, 23 Apr 2025 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421450; cv=none; b=IY8TWDm2MUp0dWvm8vqvKVmvVBGWVdjkjAijxl7EHXVb8Y/xBxoUnrEfizmg+SCkl8VqAE3u0XYy8IXRv/KjvmDO62OnD52/xm+KI6nz+/mPmnB4spNBzaiE4W45awdEEy0R1As4H9wCrs7DSp224nAlRdYNavJKk3NwfA9jZG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421450; c=relaxed/simple;
	bh=cCyZKUzO0RJJZsZxZZ9WBIRtuYWfrqCYWNzUnhfzO1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZ8gh1MbxIbT6Vo6+yo351Ipz9weO4kZpn2dDUseSfJETW6i0nQilMQJZ/1f240/MVRglq64eXya63yVy+NjoUa/CJizZ817TM60MNPRmzuevIZI4IkH8+prcDl9cbFC/mSYvupXy45BDWPiUiizvvf+mYBZCK1sl2XUTJrDeO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIZjQBN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIZjQBN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03EFC4CEE2;
	Wed, 23 Apr 2025 15:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421450;
	bh=cCyZKUzO0RJJZsZxZZ9WBIRtuYWfrqCYWNzUnhfzO1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIZjQBN0lDRmHNdtLOGeglblHnCxS4euyGRAJy1v15Bfng4RplQU9urNmwY0E9F+F
	 p0ZjmRTBrpLrdfN8/Hbd3nijlWTM//3x/cuEq8JCzy3Iq+CSWYr+LoYUhn6CnnG+SE
	 DOibW6vPyJhp76Klyjukb+p3Mo8l/0Dm3x2uc9RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 138/291] clk: qcom: gdsc: Release pm subdomains in reverse add order
Date: Wed, 23 Apr 2025 16:42:07 +0200
Message-ID: <20250423142630.046575627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 0e6dfde439df0bb977cddd3cf7fff150a084a9bf upstream.

gdsc_unregister() should release subdomains in the reverse order to the
order in which those subdomains were added.

I've made this patch a standalone patch because it facilitates a subsequent
fix to stable.

Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250117-b4-linux-next-24-11-18-clock-multiple-power-domains-v10-1-13f2bb656dad@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gdsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -523,7 +523,7 @@ void gdsc_unregister(struct gdsc_desc *d
 	size_t num = desc->num;
 
 	/* Remove subdomains */
-	for (i = 0; i < num; i++) {
+	for (i = num - 1; i >= 0; i--) {
 		if (!scs[i])
 			continue;
 		if (scs[i]->parent)


