Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6020826B091;
	Thu, 13 Feb 2025 15:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459807; cv=none; b=aLYnV+47HNPZYK9kbecvO3eeAjIG12sOt6KUYgulnNY7IPvNIaoSzU4SdQBPfadWsS1fQiklRsyuE86JCDJocxHfN7JN2Z9MRLqwTDwgyc+ocOaC9GRPX/DMMyIbUGJxiGOCMy6oLzDKHVK3jBUhHfiFIzhdU1NN6JfaZm+Xn3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459807; c=relaxed/simple;
	bh=seXMGDIzxP0VmzoCoYAebZUF4BOuzmF+YD9lEz+SeJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beLnlWekD8HYJtPXwUySt82RWh0Ud83W6wYSdh6ZZ2O9rWAh+SUPGseKeIo27wN2kCuN1yYaDKVd6KR+aEbu7lJ5SsKbFJgGhdHOJugupKg9XhE+79MW62jFRsAZ0E3n4SAg6fmrb8ZuSutByXAbKwXQ2LBQlDy4Rp8SIUTXmv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1iwiiQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1iwiiQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF499C4CED1;
	Thu, 13 Feb 2025 15:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459807;
	bh=seXMGDIzxP0VmzoCoYAebZUF4BOuzmF+YD9lEz+SeJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1iwiiQcOebtMFmYzL4lQDGErPtmiWS0V7QwVBXWo+BAjBKlcKcedJhHjZMuw/y1F
	 MPfYn9Xa0kHT+aJKe86HAFbsOsQfCG3UNZTsPbG1rTc1KTMO1As8w3eP8iTgcrFWhw
	 m5lIG55ODAZdoO75J26xkLS3qRNXIv48lr4GqHTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 369/443] media: i2c: ds90ub960: Fix UB9702 VC map
Date: Thu, 13 Feb 2025 15:28:54 +0100
Message-ID: <20250213142454.849763838@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 5dbbd0609b83f6eb72c005e2e5979d0cd25243c8 upstream.

The driver uses a static CSI-2 virtual channel mapping where all virtual
channels from an RX port are mapped to a virtual channel number matching
the RX port number.

The UB960 and UB9702 have different registers for the purpose, and the
UB9702 version is not correct. Each of the VC_ID_MAP registers do not
contain a single mapping, as the driver currently thinks, but two.

This can cause received VCs other than 0 to be mapped in a wrong way.

Fix this by writing both mappings to each register.

Cc: stable@vger.kernel.org
Fixes: afe267f2d368 ("media: i2c: add DS90UB960 driver")
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ds90ub960.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ds90ub960.c
+++ b/drivers/media/i2c/ds90ub960.c
@@ -2532,7 +2532,7 @@ static int ub960_configure_ports_for_str
 				for (i = 0; i < 8; i++)
 					ub960_rxport_write(priv, nport,
 							   UB960_RR_VC_ID_MAP(i),
-							   nport);
+							   (nport << 4) | nport);
 			}
 
 			break;


