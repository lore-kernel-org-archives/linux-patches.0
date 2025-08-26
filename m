Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FDA34F496;
	Tue, 26 Aug 2025 14:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217818; cv=none; b=teddqDlKvgZYoHT3OoW/2OUJLK8q6FayjZFjLbozPaP+8YKVAoYbPsQqmAJ0IYjjY77fZEoodfl9fuM8aF9VPswwIkfigjw81JAfBRDVb4eOQx0Dj45TanJ7zXr1cjTlg9/vrX33Cja+Hw+8QXzMEJ9qHF8JMYMYmucpbxd4S0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217818; c=relaxed/simple;
	bh=+ODs0a6v/pa2Bq8GHBC1fy63Syk9N5khm5iE6K/S43s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m6npmi4XRY3Q9vAcjPqqyQrw0ckDs76kCTG6k+ZJypWt6LVkLOo0JgI79WjPTrm5D+fgYDd1ZATbQ6UstBNFyEw1L/1l7jQcWT+16jj8xXoNlDVvi5doi2xfbT61oaIISL3GPXw5dq81QGVdRpZJP1elC+GpSF1x+Q4lbJyed1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNfSAT8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNfSAT8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEC1C4CEF1;
	Tue, 26 Aug 2025 14:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217816;
	bh=+ODs0a6v/pa2Bq8GHBC1fy63Syk9N5khm5iE6K/S43s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNfSAT8kRu0GxQg+KtFVKRUsPQN9Kq5FO1kb8vs6MnLR33Wr21hZwUM9EqqjsGiOV
	 tbdq9j1zlJ7/Oz6yRyJ0hyarpjMNBMM2M1a/fcB5PoHJuSH29x6Sx7PfTKZzmDD/DI
	 iPHppnAtqzsxIQTuRUegt+ei5XBw4+u1Vc8aA/ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/523] net: thunderx: Fix format-truncation warning in bgx_acpi_match_id()
Date: Tue, 26 Aug 2025 13:07:58 +0200
Message-ID: <20250826110931.037869868@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 53d20606c40678d425cc03f0978c614dca51f25e ]

The buffer bgx_sel used in snprintf() was too small to safely hold
the formatted string "BGX%d" for all valid bgx_id values. This caused
a -Wformat-truncation warning with `Werror` enabled during build.

Increase the buffer size from 5 to 7 and use `sizeof(bgx_sel)` in
snprintf() to ensure safety and suppress the warning.

Build warning:
  CC      drivers/net/ethernet/cavium/thunder/thunder_bgx.o
  drivers/net/ethernet/cavium/thunder/thunder_bgx.c: In function
‘bgx_acpi_match_id’:
  drivers/net/ethernet/cavium/thunder/thunder_bgx.c:1434:27: error: ‘%d’
directive output may be truncated writing between 1 and 3 bytes into a
region of size 2 [-Werror=format-truncation=]
    snprintf(bgx_sel, 5, "BGX%d", bgx->bgx_id);
                             ^~
  drivers/net/ethernet/cavium/thunder/thunder_bgx.c:1434:23: note:
directive argument in the range [0, 255]
    snprintf(bgx_sel, 5, "BGX%d", bgx->bgx_id);
                         ^~~~~~~
  drivers/net/ethernet/cavium/thunder/thunder_bgx.c:1434:2: note:
‘snprintf’ output between 5 and 7 bytes into a destination of size 5
    snprintf(bgx_sel, 5, "BGX%d", bgx->bgx_id);

compiler warning due to insufficient snprintf buffer size.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250711140532.2463602-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index f0e48b9373d6..0a71909bb2ee 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1430,9 +1430,9 @@ static acpi_status bgx_acpi_match_id(acpi_handle handle, u32 lvl,
 {
 	struct acpi_buffer string = { ACPI_ALLOCATE_BUFFER, NULL };
 	struct bgx *bgx = context;
-	char bgx_sel[5];
+	char bgx_sel[7];
 
-	snprintf(bgx_sel, 5, "BGX%d", bgx->bgx_id);
+	snprintf(bgx_sel, sizeof(bgx_sel), "BGX%d", bgx->bgx_id);
 	if (ACPI_FAILURE(acpi_get_name(handle, ACPI_SINGLE_NAME, &string))) {
 		pr_warn("Invalid link device\n");
 		return AE_OK;
-- 
2.39.5



