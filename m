Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577EB3EDE45;
	Tue, 12 May 2026 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609342; cv=none; b=tinu0OIEo7qYqW0XL75WG83QHFhO9eCgJD5ycYgFeiBinDUzgEZKlQ2d6JkuUh6YJzNywNJqQToJjb4uUUiGaHAr/5LQNqfo4lVAzUWlYBZJxaAjRNXHO1UghPa2cQMd/D9Q1NIZ0p9lV4unqgFgiwlBJo4GfjMyGI2dszDBhLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609342; c=relaxed/simple;
	bh=m8q0PEv/Qw6PoxqNry0mEOsPDdeYUa2yPXBcJgmlMzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PX+zKYk0fAJiacDHi3s6OfWN2/aAwqyQGaoRMY96k2hq/n19ycXISMWYkNRQIZXaV6nBD5BO4jHzgGLA74B0F0g4K8GYIcomjTNIy8vo4L6bP1QtOzagwkNmvEulaaGPkavCQhPpVMIoRt1Ufjus2xL7UbMGCAkKflLP/AY/tLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdlDpWHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdlDpWHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1C7C2BCB0;
	Tue, 12 May 2026 18:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609342;
	bh=m8q0PEv/Qw6PoxqNry0mEOsPDdeYUa2yPXBcJgmlMzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdlDpWHd5zjp+1c/bjhOlTIdc2xXt2jbOObayiOIhSSKW9Zz2Nblfeg6MXseybB7Z
	 FoEc927BrrPdnQrdIKBywxkC25i4n7kGjtd1feqgThrlGr5MAG4SGDC5cIDL+oFj6T
	 Jp3q3X8ieAz7Og6HcFTefvWtMl9Mn2mHavrsNZG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 7.0 156/307] thermal/drivers/sprd: Fix temperature clamping in sprd_thm_temp_to_rawdata
Date: Tue, 12 May 2026 19:39:11 +0200
Message-ID: <20260512173943.417174848@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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


