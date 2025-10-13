Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB122580F2;
	Mon, 13 Oct 2025 14:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367535; cv=none; b=KFwHElNPcKUWQBy4MKbZQDXnOdlshjuSwKRLkerVziKtwshC2Sdy0nDbwzEXffP5lUwO/+zzft/oy+WrJsvuIavQsGhzFoRfYGZuNmXtqlvqNXcHmm9vIMG+VMpURc+pihByGUiNNTmwWXuqkVhswas9QIriDdciNlxFxwspJUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367535; c=relaxed/simple;
	bh=zgOvPNs38PSfSX9EtnAjbn2NIpR8JAVTKW/dYPcB6NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYTnFXz+m6SbiKKm4Yy1HBYDdqhoPRpzHm+WS/g493LUF1EG7DgpC20D1lt96hvJl6EmLbpSVMNynfpUcRyDOqdrlcFq2xqyEYAB7AkJ36kRFD/9ulnX9WeDFBtQ2Q5+aqyBNyIMV5fnluGDVhXKH1OWsCW6gMRirTK2nIcdVhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcWA2d5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcWA2d5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B7CC4CEE7;
	Mon, 13 Oct 2025 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367535;
	bh=zgOvPNs38PSfSX9EtnAjbn2NIpR8JAVTKW/dYPcB6NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcWA2d5oyb0/4OBN8pmX/lzR9277ZRTJq8kNLft38gUQMDtkVCVrIyXUL8Tplpyf2
	 ri1RtBoxPqIpGtOJDvfMzOqo0huJTrxBQSYhRfZxdJi9x2LhWI8WEfgY6R+PKlIxY6
	 OF1cHIg21QanS83Gc0tWODhpg51UeWN+OESuJr94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/196] ACPICA: Fix largest possible resource descriptor index
Date: Mon, 13 Oct 2025 16:43:57 +0200
Message-ID: <20251013144316.868467134@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 8ca944fea4d6d9019e01f2d6f6e766f315a9d73f ]

ACPI_RESOURCE_NAME_LARGE_MAX should be equal to the last actually
used resource descriptor index (ACPI_RESOURCE_NAME_CLOCK_INPUT).

Otherwise 'resource_index' in 'acpi_ut_validate_resource()' may be
clamped incorrectly and resulting value may issue an out-of-bounds
access for 'acpi_gbl_resource_types' array. Compile tested only.

Fixes: 520d4a0ee5b6 ("ACPICA: add support for ClockInput resource (v6.5)")
Link: https://github.com/acpica/acpica/commit/cf00116c
Link: https://marc.info/?l=linux-acpi&m=175449676131260&w=2
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/aclocal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 82563b44af351..261dc8f87556d 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -1139,7 +1139,7 @@ struct acpi_port_info {
 #define ACPI_RESOURCE_NAME_PIN_GROUP_FUNCTION   0x91
 #define ACPI_RESOURCE_NAME_PIN_GROUP_CONFIG     0x92
 #define ACPI_RESOURCE_NAME_CLOCK_INPUT          0x93
-#define ACPI_RESOURCE_NAME_LARGE_MAX            0x94
+#define ACPI_RESOURCE_NAME_LARGE_MAX            0x93
 
 /*****************************************************************************
  *
-- 
2.51.0



