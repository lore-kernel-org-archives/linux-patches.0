Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ED12EBB84;
	Tue, 12 May 2026 17:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607962; cv=none; b=oNrnigJml1D/js1rHYywhxfqdesvIIogjVi6jIGmD59YF/KBu3bO/ala9n+COZomVa79ulzT0OkQUEZ7pmjsRFYADT7A4gJiZ1ZNFQGSLUw5H1GF/5wpqTZSKq6p9LwzLEBUyFO2C553wPrI6TPxlzHaaTVfejPO08OGL3985so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607962; c=relaxed/simple;
	bh=yRH6RuM4W8hKiq3WpI0nj+fMvrnC+PgBp+cmAi7HP64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XE6pIuGkZHvrW44SC/mlL5D3SkWmsumBaF3FLq8miytWboBBlor7KybqePd4oqZa7J45BLzTU/BKq/PbngiZ8AM3FwQGrEnSNCpUNdO7i5v+rhLl3ELrjZi56d08/wul3mnmSMQa/+h1DQXkvbV2g/XJH6X0vKbxHsNvKbo2BHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnWxUlY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnWxUlY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4F8C2BCB0;
	Tue, 12 May 2026 17:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607962;
	bh=yRH6RuM4W8hKiq3WpI0nj+fMvrnC+PgBp+cmAi7HP64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnWxUlY+IOjSWk3n3GRlkzIqvRiqe3LRk27jaZQphG+9auterKrXJByW9tYT4RrEg
	 0UgX5+n0FVypk3IU0/O/3ubGayf+X//rsYzis6nGWuhbnPwVuP/StzHP4NhYQbbURi
	 eC9jTxcHA4qs4usI61hs3n6t6iOJMbzFSty8q/J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 6.12 101/206] thermal/drivers/sprd: Fix temperature clamping in sprd_thm_temp_to_rawdata
Date: Tue, 12 May 2026 19:39:13 +0200
Message-ID: <20260512173934.996300642@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


