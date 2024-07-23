Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6167A13D521;
	Tue, 23 Jul 2024 18:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759140; cv=none; b=h8VMTSOcb+dmtF3oG+N/3E3ZsbtAxl6AgvglEJki/1j1rOQsvy0L2SMEP/XWc2gKcoimT4L1xrEcEPDujT9rUslId71EoJYQ2bsvNIQ/a7MiTXcU+Q6T9/7mA/o+MqiDvjcPs4QBdNXYKjyaoHOGRUiU9HoMA6aRtIcWiEx+3RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759140; c=relaxed/simple;
	bh=i0l14tRQCgEIeSr46U/UPve638cknil1XY8V35oVGR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiJN1N9uYXm5eo2DgLnLJfCb+iY60m2gbblwSnahTwcth01IFVTwhXu2dQAzIhmer90FUh+XxE4z3i3OveYawaYQtnP25cGzJAnjhFv5iEvRnsJnla8hbAjGhPBEX0zgb3Bj9sBy1lAfN3lI6kAFOixUbMY0JMDOSxzPBsfi2GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSZ7loEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSZ7loEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F91C4AF0A;
	Tue, 23 Jul 2024 18:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759140;
	bh=i0l14tRQCgEIeSr46U/UPve638cknil1XY8V35oVGR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSZ7loEsdkWNk3Q7habKWDgg68GGM8a0oPEHsrnGeMP7Qxd00kjF4z35YwW4Y6Our
	 h191Tpc8hVOF//LSOY8djRuOg+OJtp5ufa3a2pSrRToZRQsb09kG4FfZXhi4CzEcD+
	 0BFe/pGMhs1xuh6k+WWWsJk+cB8VAuhk3/ajHjYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/105] ACPI: EC: Avoid returning AE_OK on errors in address space handler
Date: Tue, 23 Jul 2024 20:22:53 +0200
Message-ID: <20240723180403.475314185@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit c4bd7f1d78340e63de4d073fd3dbe5391e2996e5 ]

If an error code other than EINVAL, ENODEV or ETIME is returned
by acpi_ec_read() / acpi_ec_write(), then AE_OK is incorrectly
returned by acpi_ec_space_handler().

Fix this by only returning AE_OK on success, and return AE_ERROR
otherwise.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index fc3dc83bb8707..7589908b358e3 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1332,8 +1332,10 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 		return AE_NOT_FOUND;
 	case -ETIME:
 		return AE_TIME;
-	default:
+	case 0:
 		return AE_OK;
+	default:
+		return AE_ERROR;
 	}
 }
 
-- 
2.43.0



