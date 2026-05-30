Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E25B313E34;
	Sat, 30 May 2026 18:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166052; cv=none; b=NGQY93d2qzs5AYJSiVREJyuJRp7RJ5ELb6Pj/DG6UY9RAMti1WKfZy9FaWOQKDp2LwoN9F5o3eWdAjS92jH/nQ+IqsUZJ+Aec1i+PuBCTy1NeGHUPri9kXLMsENeo4FMyvdx+wgR48pJDo25xn0CFnzukYYqvih4C4a2kpcMNRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166052; c=relaxed/simple;
	bh=nPulmcLNM1aUwSR8KtUDtU82A9lXOBkUp92erpJZkpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBaQTrv5+/a1NIBKv+Olh51pI4ecAjcb7MbU0Vb/QfmICuWycpZuFls0ljqCYV1y5zz/aP5QvgbiFpPKKKNiZ6eOwm7egSv+fmtnsIUAb0vY2dT8iLv/XbPDchPim/2Sw0/udT0carWw48WO4u9p4kT3Z7LVSCnc32QAZQIuaDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpS9rHXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpS9rHXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942DC1F00893;
	Sat, 30 May 2026 18:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166051;
	bh=I+TQjC7T4iTOYhFw8+t+KNnTLWZ6vqZRWP6NgBcT8JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpS9rHXDu/0jbxOajPpKojuzrrlfpJpVznmAhohYg42hphjkE0DJe4MAQhc+f9ATy
	 kHlYY+jJpTf+qe4fJImDUbJasLi+W1AHazvQpz6dM1VCOQgErP5qVgxj6eZpohygUk
	 eQ/2sgfKbKmxdTl03Dj77vvsnYP9Ba8XMXftllbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 5.10 242/589] thermal/drivers/sprd: Fix temperature clamping in sprd_thm_temp_to_rawdata
Date: Sat, 30 May 2026 18:02:03 +0200
Message-ID: <20260530160231.362141342@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 83c0f9a5d679a6f8d84fc49b2f62ea434ccab4b6 upstream.

The temperature was never clamped to SPRD_THM_TEMP_LOW or
SPRD_THM_TEMP_HIGH because the return value of clamp() was not used. Fix
this by assigning the clamped value to 'temp'.

Casting SPRD_THM_TEMP_LOW and SPRD_THM_TEMP_HIGH to int is also
redundant and can be removed.

Fixes: 554fdbaf19b1 ("thermal: sprd: Add Spreadtrum thermal driver support")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260307102422.306055-1-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/sprd_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -192,7 +192,7 @@ static int sprd_thm_temp_to_rawdata(int
 {
 	u32 val;
 
-	clamp(temp, (int)SPRD_THM_TEMP_LOW, (int)SPRD_THM_TEMP_HIGH);
+	temp = clamp(temp, SPRD_THM_TEMP_LOW, SPRD_THM_TEMP_HIGH);
 
 	/*
 	 * According to the thermal datasheet, the formula of converting


